import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payments_screen.dart'; // ✅ CHANGED: Import PaymentsScreen instead of payment_screen
import 'paymenthistory_screen.dart';
import 'deed_of_sale_screen.dart';

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({super.key});

  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _planData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlanData();
  }

  Future<void> _loadPlanData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        setState(() {
          _errorMessage = 'Please log in to view your plans';
          _isLoading = false;
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'No active plans found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _planData = querySnapshot.docs.first.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading plan data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  double _calculateProgress() {
    if (_planData == null) return 0.0;
    
   final totalPrice = _parseCurrency(_planData!['totalPrice'] ?? 0);
    final paidAmount = (_planData!['paidAmount'] as num?)?.toDouble() ?? 0.0;
    
    if (totalPrice <= 0) return 0.0;
    return (paidAmount / totalPrice).clamp(0.0, 1.0);
  }

double _parseCurrency(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.replaceAll(RegExp(r'[₱,\s]'), '')) ?? 0.0;
  }
  return 0.0;
}

  String _formatCurrency(double value) {
    return '₱${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Plans",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Your memorial plan details",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadPlanData,
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
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _planData?['planTitle'] ?? 'Premium',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "Active",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                          Text(
  _planData?['lotCategory'] ?? _planData?['location'] ?? 'N/A',
  style: const TextStyle(color: Colors.black87),
),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Start Date",
                                          style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 4),
                                      Text(
                                        _planData?['startDate'] ?? 'January 15, 2024',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Payment Term",
                                          style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 4),
                                      Text(
                                        _planData?['paymentTerm'] ?? '36 months',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              const Text("Remaining Balance",
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                        Text(
  _formatCurrency((_planData?['remainingBalance'] as num?)?.toDouble() ?? 45000),
  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: _calculateProgress(),
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${_formatCurrency((_planData?['paidAmount'] as num?)?.toDouble() ?? 0)} paid  •  ${(_calculateProgress() * 100).toStringAsFixed(0)}% complete',
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const SizedBox(height: 20),

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.blue.shade200, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: const Icon(Icons.calendar_today,
                                          color: Colors.blue, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Next Payment Due",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 13)),
                                          const SizedBox(height: 4),
                                          Text(
                                            _planData?['nextPaymentDate'] ??
                                                'March 15, 2024',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                Text(
  _formatCurrency((_planData?['nextPaymentAmount'] as num?)?.toDouble() ?? 2500),
  style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
const SizedBox(height: 16),

Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.payment),
        label: const Text("Pay Now"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentsScreen(),
            ),
          );
        },
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.history),
        label: const Text("History"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentHistoryScreen(),
            ),
          );
        },
      ),
    ),
  ],
),

// ✅ NEW "View Deed of Sale" button
const SizedBox(height: 12),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 47, 150),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    icon: const Icon(Icons.description),
    label: const Text("View Deed of Sale"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DeedOfSaleScreen(),
        ),
      );
    },
  ),
),
                            ],  // ✅ ADD THIS - closes the Column children
                          ),    // ✅ ADD THIS - closes the Column
                        ),      // ✅ ADD THIS - closes the Padding
                      ),        // ✅ ADD THIS - closes the Card
                      const SizedBox(height: 20),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Plan Benefits",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 16),
                              _buildBenefitItem(
                                Icons.nature,
                                "Perpetual Care Included",
                                "Ongoing maintenance and upkeep",
                              ),
                              _buildBenefitItem(
                                Icons.schedule,
                                "Flexible Payment Schedule",
                                "Pay early without penalties",
                              ),
                              _buildBenefitItem(
                                Icons.support_agent,
                                "24/7 Customer Support",
                                "Always here to help you",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}