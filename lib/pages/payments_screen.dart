import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_screen.dart';
import 'paymenthistory_screen.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // ADD: TextEditingController for custom amount input
  final TextEditingController _customAmountController = TextEditingController();
  
  bool _isLoading = true;
  double _remainingBalance = 0.0;
  double _totalPaid = 0.0;
  int _paymentCount = 0;
  double _nextDueAmount = 0.0;
  String _nextDueDate = '';

  String? _error;
  String? _agreementId;

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  // ADD: Dispose controller to prevent memory leaks
  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadPaymentData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Please log in to view payments');
      }

      // Get active agreement
      final agreementSnapshot = await _firestore
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (agreementSnapshot.docs.isEmpty) {
        setState(() {
          _error = 'No active plan found. Please purchase a plan first.';
          _isLoading = false;
        });
        return;
      }

      final agreementDoc = agreementSnapshot.docs.first;
      final agreementData = agreementDoc.data();
      _agreementId = agreementDoc.id;

      // Get total paid from payments collection
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'completed')
          .get();

      double totalPaid = 0.0;
      for (var doc in paymentsSnapshot.docs) {
        final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
        totalPaid += amount;
      }

      // Calculate remaining balance
      final totalPrice = _parseCurrency(agreementData['totalPrice'] ?? '₱0');
      final remaining = totalPrice - totalPaid;

      setState(() {
        _remainingBalance = remaining > 0 ? remaining : 0.0;
        _totalPaid = totalPaid;
        _paymentCount = paymentsSnapshot.docs.length;
        
        // Handle nextPaymentAmount - it's stored as a number in Firestore
        final nextPaymentAmountData = agreementData['nextPaymentAmount'];
        if (nextPaymentAmountData is num) {
          _nextDueAmount = nextPaymentAmountData.toDouble();
        } else if (nextPaymentAmountData is String) {
          _nextDueAmount = _parseCurrency(nextPaymentAmountData);
        } else {
          _nextDueAmount = 0.0;
        }

        // Handle nextPaymentDate
        final nextPaymentDateData = agreementData['nextPaymentDate'];
        if (nextPaymentDateData is String) {
          _nextDueDate = nextPaymentDateData;
        } else if (nextPaymentDateData is Timestamp) {
          final date = nextPaymentDateData.toDate();
          _nextDueDate = '${date.month}/${date.day}/${date.year}';
        } else {
          _nextDueDate = 'TBD';
        }
       
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[₱,\s]'), '')) ?? 0.0;
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // ADD: Function to handle custom payment navigation
  Future<void> _proceedWithCustomPayment() async {
    final customAmountText = _customAmountController.text.trim();
    
    if (customAmountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a payment amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final customAmount = double.tryParse(customAmountText);
    
    if (customAmount == null || customAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (customAmount > _remainingBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Amount exceeds remaining balance of ₱${_formatNumber(_remainingBalance)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to PaymentScreen with custom amount
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          customAmount: customAmount,
          agreementId: _agreementId,
        ),
      ),
    );
    
    if (result == true) {
      _customAmountController.clear();
      _loadPaymentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Payments & Receipts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
       
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Manage your payment history",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No Active Plan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _loadPaymentData,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Remaining Balance Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "Remaining Balance",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "₱${_formatNumber(_remainingBalance)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Next Due & Total Paid Row
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Next Due",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "₱${_formatNumber(_nextDueAmount)}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _nextDueDate,
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Total Paid",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "₱${_formatNumber(_totalPaid)}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$_paymentCount payments",
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // MODIFIED: Payment Amount Input with Arrow Button
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Custom Payment Amount",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _customAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      prefixText: '₱ ',
                                      hintText: 'Enter amount to advance payment',
                                      // ADD: Suffix icon button
                                      suffixIcon: IconButton(
                                        icon: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        onPressed: _proceedWithCustomPayment,
                                        tooltip: 'Proceed to Payment',
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.blue.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.blue.shade50,
                                    ),
                                    onSubmitted: (value) {
                                      // Allow pressing Enter/Return to proceed
                                      _proceedWithCustomPayment();
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tip: Enter any amount up to ₱${_formatNumber(_remainingBalance)} to advance your payment',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // PAY NOW BUTTON (Next Due Amount)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: _nextDueAmount > 0
                                    ? () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                              customAmount: _nextDueAmount,
                                              agreementId: _agreementId,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadPaymentData();
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.payment),
                                label: Text(
                                  "Pay Next Due - ₱${_formatNumber(_nextDueAmount)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // HISTORY BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentHistoryScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.receipt_long),
                                label: const Text(
                                  "View Payment History",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}