import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? _selectedMethod;
  bool _isProcessing = false;
  bool _isLoading = true;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Payment data from Firebase
  double _paymentAmount = 0.0;
  String _nextDueDate = '';
  String _agreementId = '';
  String _planTitle = '';
  String _location = '';
  double _remainingBalance = 0.0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "icon": Icons.account_balance_wallet,
      "color": Colors.blue,
      "title": "GCash",
      "subtitle": "Pay via GCash mobile wallet",
    },
    {
      "icon": Icons.payment,
      "color": Colors.blue,
      "title": "Maya (PayMaya)",
      "subtitle": "Pay via Maya digital wallet",
    },
    {
      "icon": Icons.account_balance,
      "color": Colors.grey,
      "title": "Bank Transfer",
      "subtitle": "Online banking or over-the-counter",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  Future<void> _loadPaymentData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Please log in to make a payment');
      }

      // Get active agreement
      final agreementSnapshot = await _firestore
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (agreementSnapshot.docs.isEmpty) {
        throw Exception('No active plan found');
      }

      final agreementDoc = agreementSnapshot.docs.first;
      final data = agreementDoc.data();

     setState(() {
  _agreementId = agreementDoc.id;
  
  // Handle nextPaymentAmount - could be String or double
  final nextPaymentRaw = data['nextPaymentAmount'];
  if (nextPaymentRaw is double) {
    _paymentAmount = nextPaymentRaw;
  } else if (nextPaymentRaw is int) {
    _paymentAmount = nextPaymentRaw.toDouble();
  } else {
    _paymentAmount = _parseCurrency(nextPaymentRaw?.toString() ?? '₱0');
  }
  
  _nextDueDate = data['nextPaymentDate'] ?? '';
  _planTitle = data['planTitle'] ?? 'Memorial Plan';
  _location = data['location'] ?? 'Garden Family Estate';
  
  // Handle remainingBalance - could be String, double, or int
  final remainingRaw = data['remainingBalance'];
  if (remainingRaw is double) {
    _remainingBalance = remainingRaw;
  } else if (remainingRaw is int) {
    _remainingBalance = remainingRaw.toDouble();
  } else {
    _remainingBalance = _parseCurrency(remainingRaw?.toString() ?? '₱0');
  }
  
  _isLoading = false;
});
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
        Navigator.pop(context);
      }
    }
  }

  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[₱,\s]'), '')) ?? 0.0;
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _getNextDueDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    return '${_getMonthName(nextMonth.month)} ${nextMonth.day}, ${nextMonth.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> _processPayment() async {
    if (_selectedMethod == null) {
      _showErrorDialog('Please select a payment method');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      if (_paymentAmount <= 0) {
        throw Exception('Invalid payment amount');
      }

      final paymentMethodName = paymentMethods[_selectedMethod!]['title'];
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Calculate new values
      final newRemainingBalance = _remainingBalance - _paymentAmount;
      final newNextDueDate = _getNextDueDate();

      // Use batch write for atomic operation
      final batch = _firestore.batch();

      // 1. Create payment record
      final paymentRef = _firestore.collection('payments').doc();
      batch.set(paymentRef, {
        'agreementId': _agreementId,
        'userId': user.uid,
        'userEmail': user.email,
        'amount': _paymentAmount,
        'paymentType': 'Monthly Payment',
        'paymentMethod': paymentMethodName,
        'transactionId': transactionId,
        'status': 'completed',
        'planTitle': _planTitle,
        'location': _location,
        'dueDate': _nextDueDate,
        'paidAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'description': 'Monthly payment of ₱${_formatCurrency(_paymentAmount)} via $paymentMethodName',
      });

      // 2. Update agreement
      final agreementRef = _firestore.collection('preNeedAgreements').doc(_agreementId);
      
     // Get current values
final agreementDoc = await agreementRef.get();
final agreementData = agreementDoc.data();

// Get current paid amount (handle both int and double)
final paidAmountRaw = agreementData?['paidAmount'];
double currentPaidAmount = 0.0;
if (paidAmountRaw is double) {
  currentPaidAmount = paidAmountRaw;
} else if (paidAmountRaw is int) {
  currentPaidAmount = paidAmountRaw.toDouble();
} else if (paidAmountRaw is String) {
  currentPaidAmount = _parseCurrency(paidAmountRaw);
}
// Ensure _paymentAmount is a number
if (_paymentAmount == 0.0) {
  throw Exception('Invalid payment amount');
}

// Debug: Print types to verify
print('currentPaidAmount type: ${currentPaidAmount.runtimeType}');
print('_paymentAmount type: ${_paymentAmount.runtimeType}');

final newPaidAmount = currentPaidAmount + _paymentAmount;

// Get current paid months
final paidMonthsRaw = agreementData?['paidMonths'] ?? 0;
final currentPaidMonths = paidMonthsRaw is int ? paidMonthsRaw : int.tryParse(paidMonthsRaw.toString()) ?? 0;
final newPaidMonths = currentPaidMonths + 1;

  batch.update(agreementRef, {
  'paidAmount': newPaidAmount,
  'paidMonths': newPaidMonths, // Increment paid months
  'remainingBalance': newRemainingBalance, // Store as number
  'remainingBalanceString': '₱${_formatCurrency(newRemainingBalance)}',
  'nextPaymentDate': newNextDueDate,
  'nextPaymentAmount': _paymentAmount, // Store as number
  'nextPaymentAmountString': '₱${_formatCurrency(_paymentAmount)}',
  'lastPaymentDate': FieldValue.serverTimestamp(),
  'lastPaymentAmount': _paymentAmount,
  'lastPaymentMethod': paymentMethodName,
  'updatedAt': FieldValue.serverTimestamp(),
});

      // Commit batch
      await batch.commit();

      // Show success dialog
      if (mounted) {
        _showSuccessDialog(transactionId, paymentMethodName);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccessDialog(String transactionId, String paymentMethod) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₱${_formatCurrency(_paymentAmount)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'via $paymentMethod',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Transaction ID',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transactionId,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your payment has been recorded and your balance has been updated.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Go back with success
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Payment Failed', style: TextStyle(color: Colors.black)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Payment",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Choose payment method",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Amount Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "₱${_formatCurrency(_paymentAmount)}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "You are paying today",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  "Next due: $_nextDueDate",
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  _location,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),

          // Payment Method Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: RadioListTile<int>(
                    value: index,
                    groupValue: _selectedMethod,
                    activeColor: Colors.blue,
                    onChanged: _isProcessing
                        ? null
                        : (value) {
                            setState(() {
                              _selectedMethod = value;
                            });
                          },
                    secondary: CircleAvatar(
                      backgroundColor:
                          (method["color"] as Color).withOpacity(0.15),
                      child: Icon(method["icon"], color: method["color"]),
                    ),
                    title: Text(
                      method["title"],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      method["subtitle"],
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ),
                );
              },
            ),
          ),

          // Secure Info
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.blue, size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      "Secure Payment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your payment information is encrypted and secure.\nWe never store your card details.",
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  "By proceeding with this payment, you agree to the terms and conditions of your memorial plan contract.\n\nPayment processing may take 1–3 business days depending on your chosen method.",
                  style: TextStyle(color: Colors.black54, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),

      // Confirm Payment Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: _selectedMethod == null || _isProcessing
                ? Colors.grey.shade300
                : Colors.blue,
          ),
          onPressed: _selectedMethod == null || _isProcessing
              ? null
              : _processPayment,
          child: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Confirm Payment - ₱${_formatCurrency(_paymentAmount)}",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}