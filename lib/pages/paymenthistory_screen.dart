import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _payments = [];
  String? _errorMessage;
  double _totalPaid = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

 Future<void> _loadPaymentHistory() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      setState(() {
        _errorMessage = 'Please log in to view payment history';
        _isLoading = false;
      });
      return;
    }

    // Simplified query - no orderBy
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      setState(() {
        _payments = [];
        _totalPaid = 0.0;
        _errorMessage = 'No payment history found';
        _isLoading = false;
      });
      return;
    }

    // Sort manually in code
    List<Map<String, dynamic>> paymentsList = [];
    double total = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      paymentsList.add(data);
      
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      total += amount;
    }

    // Sort by date manually
    paymentsList.sort((a, b) {
      final aTime = (a['paidAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bTime = (b['paidAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

    setState(() {
      _payments = paymentsList;
      _totalPaid = total;
      _isLoading = false;
      _errorMessage = null; // Clear error
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Error loading payments: ${e.toString()}';
      _isLoading = false;
    });
  }
}

  String _formatCurrency(double value) {
    return '₱${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment History",
          style: TextStyle(color: Colors.white),
        ),
       
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadPaymentHistory,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your transaction records",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      // Payment Cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _payments.length,
                        itemBuilder: (context, index) {
                          final payment = _payments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildPaymentCard(
                              title: payment['paymentType'] ??
                                  'Monthly Payment',
                              amount: _formatCurrency(
                                  (payment['amount'] as num?)?.toDouble() ??
                                      0.0),
                              date: _formatDate(payment['paidAt']),
                              status: payment['status'] ?? 'Completed',
                              description: payment['description'] ?? '',
                              paymentMethod: payment['paymentMethod'] ?? '',
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Summary Card
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Payment Summary",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 12),
                              _buildSummaryRow("Total Paid",
                                  _formatCurrency(_totalPaid)),
                              _buildSummaryRow("Completed Payments",
                                  _payments.length.toString()),
                              _buildSummaryRow(
                                  "Last Payment",
                                  _payments.isNotEmpty
                                      ? _formatDate(_payments.first['paidAt'])
                                      : 'N/A'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required String amount,
    required String date,
    required String status,
    required String description,
    required String paymentMethod,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.check_circle, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(date,
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
            
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                if (paymentMethod.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      paymentMethod,
                      style: const TextStyle(
                          color: Colors.black87, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}