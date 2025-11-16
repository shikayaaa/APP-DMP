import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 176, 221), // BLUE TINT
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue, // CHANGED TO BLUE
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment History",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your transaction records",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // ✅ Down Payment Card
            _buildPaymentCard(
              title: "Down Payment",
              amount: "₱30,000",
              date: "Feb 15, 2024",
              status: "Completed",
            ),
            const SizedBox(height: 12),

            // ✅ Monthly Payment Card
            _buildPaymentCard(
              title: "Monthly Payment",
              amount: "₱2,500",
              date: "Feb 15, 2024",
              status: "Completed",
            ),
            const SizedBox(height: 12),

            _buildPaymentCard(
              title: "Monthly Payment",
              amount: "₱2,500",
              date: "Jan 15, 2024",
              status: "Completed",
            ),
            const SizedBox(height: 20),

            // ✅ Payment Summary
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Payment Summary",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    buildSummaryRow("Total Paid", "₱35,000"),
                    buildSummaryRow("Completed Payments", "3"),
                    buildSummaryRow("Last Payment", "Feb 15, 2024"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Payment Card (BLUE VERSION)
  Widget _buildPaymentCard({
    required String title,
    required String amount,
    required String date,
    required String status,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100, // CHANGED
                  child: const Icon(Icons.check_circle, color: Colors.blue), // CHANGED
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(date, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Text(amount,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, // CHANGED
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold), // CHANGED
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Tap for details",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Summary Row (UNCHANGED)
class buildSummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const buildSummaryRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
