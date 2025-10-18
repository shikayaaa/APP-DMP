import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        title: const Text("Terms of Service"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Last updated: October 10, 2025",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  _buildSection(
                    "1. Acceptance of Terms",
                    "By accessing and using the Dumaguete Memorial Park mobile application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use this application.",
                  ),
                  _buildSection(
                    "2. Pre-Need Plan Agreement",
                    "When you purchase a pre-need cemetery lot plan through this application, you enter into a legally binding agreement. You agree to:\n\n"
                        "• Make timely monthly payments as per your selected plan\n"
                        "• Maintain accurate personal and contact information\n"
                        "• Provide valid identification and required documents\n"
                        "• Comply with memorial park rules and regulations",
                  ),
                  _buildSection(
                    "3. Payment Terms",
                    "All payments made through the app are subject to verification and processing. Payment methods include GCash, Maya, Bank Transfer, and Credit/Debit cards. A grace period of 15 days is provided for monthly installments. Late payments may incur additional charges as specified in your contract.",
                  ),
                  _buildSection(
                    "4. Interment Services",
                    "Interment requests must be submitted at least 48 hours in advance. The memorial park reserves the right to approve or deny requests based on availability and compliance with regulations. Additional fees may apply for weekend or holiday services.",
                  ),
                  _buildSection(
                    "5. User Account Security",
                    "You are responsible for maintaining the confidentiality of your account credentials. Any activity that occurs under your account is your responsibility. Notify us immediately of any unauthorized access or security breaches.",
                  ),
                  _buildSection(
                    "6. Cancellation & Refund Policy",
                    "Plan cancellations must be submitted in writing. Refunds are subject to a processing fee and will be calculated based on the amount paid minus administrative costs and any utilized services. Full terms are available in your pre-need contract.",
                  ),
                  _buildSection(
                    "7. Limitation of Liability",
                    "Dumaguete Memorial Park is not liable for any indirect, incidental, or consequential damages arising from the use of this application. We do not guarantee uninterrupted or error-free service.",
                  ),
                  _buildSection(
                    "8. Modifications to Terms",
                    "We reserve the right to modify these terms at any time. Changes will be communicated through the app and email. Continued use of the application constitutes acceptance of modified terms.",
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Contact Box
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Questions?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "For questions about these terms, please contact our support team "
                            "at info@dumaguetememorial.com or call (035) 422-XXXX.",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // 🔹 Bottom Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade900,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "I Understand",
                style: TextStyle(
                  color: Colors.white, // ✅ White text
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper widget for sections
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
