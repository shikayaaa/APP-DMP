import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  final double? customAmount;
  final String? agreementId;
  
  const PaymentScreen({
    super.key,
    this.customAmount,
    this.agreementId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  double _paymentAmount = 0.0;
  bool _isProcessing = false;
  bool _isLoading = true;
  String? _agreementData;
  int? _selectedMethod;

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
    
    // FIXED: Properly use the custom amount passed from payments_screen
    if (widget.customAmount != null && widget.customAmount! > 0) {
      _paymentAmount = widget.customAmount!;
    }
    
    _loadPaymentData();
  }

  Future<void> _loadPaymentData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Load agreement details
      if (widget.agreementId != null) {
        final agreementDoc = await _firestore
            .collection('preNeedAgreements')
            .doc(widget.agreementId)
            .get();

        if (agreementDoc.exists) {
          final data = agreementDoc.data();
          _agreementData = data?['planType'] ?? 'Pre-Need Plan';
        }
      } else {
        // If no agreementId provided, try to find active agreement
        final agreementSnapshot = await _firestore
            .collection('preNeedAgreements')
            .where('userId', isEqualTo: user.uid)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (agreementSnapshot.docs.isNotEmpty) {
          final data = agreementSnapshot.docs.first.data();
          _agreementData = data['planType'] ?? 'Pre-Need Plan';
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _processPayment() async {
    if (_paymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid payment amount')),
      );
      return;
    }

    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text(
          'Are you sure you want to pay ₱${_formatNumber(_paymentAmount)} via ${paymentMethods[_selectedMethod!]['title']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final paymentMethodName = paymentMethods[_selectedMethod!]['title'];
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Determine which agreement to use
      String? targetAgreementId = widget.agreementId;
      
      if (targetAgreementId == null) {
        // Find active agreement if not provided
        final agreementSnapshot = await _firestore
            .collection('preNeedAgreements')
            .where('userId', isEqualTo: user.uid)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (agreementSnapshot.docs.isNotEmpty) {
          targetAgreementId = agreementSnapshot.docs.first.id;
        }
      }

     // Create payment record in Firebase (root collection)
await _firestore.collection('payments').add({
  'userId': user.uid,
  'agreementId': targetAgreementId,
  'amount': _paymentAmount,
  'status': 'completed',
  'paymentMethod': paymentMethodName,
  'transactionId': transactionId,
  'paymentDate': Timestamp.now(),
  'createdAt': Timestamp.now(),
});

// ✅ ALSO write to user's payment history for admin dashboard
await _firestore
    .collection('users')
    .doc(user.uid)
    .collection('payments')
    .doc('transactions')
    .collection('history')
    .add({
  'userId': user.uid,
  'agreementId': targetAgreementId,
  'amount': _paymentAmount,
  'status': 'completed',
  'paymentMethod': paymentMethodName,
  'transactionId': transactionId,
  'paymentDate': Timestamp.now(),
  'transactionType': 'Payment',
  'createdAt': Timestamp.now(),
});

// ✅ Update payment summary for this user
final paymentSummaryRef = _firestore
    .collection('users')
    .doc(user.uid)
    .collection('payments')
    .doc('summary');

final paymentSummarySnap = await paymentSummaryRef.get();

if (paymentSummarySnap.exists) {
  final currentData = paymentSummarySnap.data() ?? {};
  final currentTotalPaid = (currentData['totalPaid'] as num?)?.toDouble() ?? 0.0;
  final totalAmount = (currentData['totalAmount'] as num?)?.toDouble() ?? 0.0;
  final newTotalPaid = currentTotalPaid + _paymentAmount;
  
  await paymentSummaryRef.update({
    'totalPaid': newTotalPaid,
    'remainingBalance': totalAmount - newTotalPaid,
    'updatedAt': Timestamp.now(),
  });
} else {
  // Create payment summary if it doesn't exist
  if (targetAgreementId != null) {
    final agreementDoc = await _firestore
        .collection('preNeedAgreements')
        .doc(targetAgreementId)
        .get();
    
    if (agreementDoc.exists) {
      final data = agreementDoc.data();
      final totalAmount = (data?['totalAmount'] as num?)?.toDouble() ?? 0.0;
      final lotNumber = data?['lotNumber'] ?? data?['lot'] ?? data?['location'] ?? 'N/A';
      
      await paymentSummaryRef.set({
        'contractId': targetAgreementId,
        'paymentId': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        'lotNumber': lotNumber,
        'totalAmount': totalAmount,
        'totalPaid': _paymentAmount,
        'remainingBalance': totalAmount - _paymentAmount,
        'nextDueDate': DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T')[0],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
      
      print('✅ Created payment summary with lotNumber: $lotNumber');
    }
  }
}

      // FIXED: Update the agreement with proper advance payment logic
      if (targetAgreementId != null) {
        final agreementDoc = await _firestore
            .collection('preNeedAgreements')
            .doc(targetAgreementId)
            .get();

        if (agreementDoc.exists) {
          final data = agreementDoc.data();
          
          // Get current values
          final totalAmount = (data?['totalAmount'] as num?)?.toDouble() ?? 0.0;
          final currentBalance = (data?['remainingBalance'] as num?)?.toDouble() ?? totalAmount;
          final currentPaidMonths = (data?['paidMonths'] as num?)?.toInt() ?? 0;
          final termMonths = (data?['termMonths'] as num?)?.toInt() ?? 12;
          final monthlyPayment = (data?['monthlyPayment'] as num?)?.toDouble() ?? 0.0;
          final startDateStr = data?['startDate'] as String?;
          
          // Calculate new balance
          final newBalance = currentBalance - _paymentAmount;
          final finalBalance = newBalance > 0 ? newBalance : 0.0;

          // Calculate how many months this payment covers
          int monthsCovered = 0;
          if (monthlyPayment > 0) {
            monthsCovered = (_paymentAmount / monthlyPayment).floor();
            if (monthsCovered < 1) monthsCovered = 1; // At least 1 month
          }
          
          final newPaidMonths = currentPaidMonths + monthsCovered;
          final cappedPaidMonths = newPaidMonths > termMonths ? termMonths : newPaidMonths;

          // Determine new status
          String newStatus = data?['status'] ?? 'active';
          if (finalBalance == 0 || cappedPaidMonths >= termMonths) {
            newStatus = 'completed';
          }

          // Calculate next payment date and amount
          String? nextPaymentDate;
          double nextPaymentAmount = monthlyPayment;
          
          if (finalBalance > 0 && newStatus != 'completed') {
            // Calculate next payment date based on paid months
            if (startDateStr != null) {
              try {
                final startDate = DateTime.parse(startDateStr);
                final nextDate = DateTime(
                  startDate.year,
                  startDate.month + cappedPaidMonths,
                  startDate.day,
                );
                nextPaymentDate = '${nextDate.month}/${nextDate.day}/${nextDate.year}';
              } catch (e) {
                nextPaymentDate = 'TBD';
              }
            }
            
            // If remaining balance is less than monthly payment, adjust
            if (finalBalance < monthlyPayment) {
              nextPaymentAmount = finalBalance;
            }
          } else {
            // Payment completed
            nextPaymentDate = 'Completed';
            nextPaymentAmount = 0.0;
          }

          // Update the agreement
          final updateData = {
            'remainingBalance': finalBalance,
            'paidMonths': cappedPaidMonths,
            'status': newStatus,
            'updatedAt': Timestamp.now(),
          };

          // Add next payment info if not completed
if (newStatus != 'completed') {
  updateData['nextPaymentAmount'] = nextPaymentAmount;
  updateData['nextPaymentDate'] = nextPaymentDate ?? 'TBD';
} else {
  updateData['nextPaymentAmount'] = 0.0;
  updateData['nextPaymentDate'] = 'Completed';
}
          await _firestore
              .collection('preNeedAgreements')
              .doc(targetAgreementId)
              .update(updateData);
        }
      }

      setState(() {
        _isProcessing = false;
      });

      // Show success message
      if (mounted) {
        await showDialog(
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
                  '₱${_formatNumber(_paymentAmount)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'via $paymentMethodName',
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
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
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
                  "₱${_formatNumber(_paymentAmount)}",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Amount to Pay",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (_agreementData != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _agreementData!,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.blue, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Secure Payment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  "Your payment information is encrypted and secure.",
                  style: TextStyle(color: Colors.black87, fontSize: 12),
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
                  "Confirm Payment - ₱${_formatNumber(_paymentAmount)}",
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