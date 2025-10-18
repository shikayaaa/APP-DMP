import 'package:flutter/material.dart';

class PrivacyControlsScreen extends StatelessWidget {
  const PrivacyControlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        title: const Text("Privacy Controls"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _privacyTile(
            "Data Encryption",
            "Your personal and financial data is encrypted using industry-standard AES-256 encryption.",
          ),
          _privacyTile(
            "Secure Payments",
            "All payment information is processed through PCI-DSS compliant payment gateways.",
          ),
          _privacyTile(
            "Limited Data Sharing",
            "Your information is only shared with Dumaguete Memorial Park staff for service purposes.",
          ),
          _privacyTile(
            "Access Control",
            "You have full control over who can access your account and documents.",
          ),
          _privacyTile(
            "Data Protection Compliance",
            "We comply with the Data Privacy Act of 2012 (Republic Act No. 10173) and international data protection standards.",
          ),
          _privacyTile(
            "Right to Deletion",
            "You can request deletion of your personal data at any time, subject to legal and contractual obligations.",
          ),

          const SizedBox(height: 20),

          // Action Buttons
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 124, 186, 176),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Got It",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 11, 61, 53),
              side: const BorderSide(color: Color.fromARGB(255, 6, 71, 60)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              // TODO: Navigate to Support Screen
            },
            child: const Text(
              "Contact Support for More Info",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable privacy info tile
  Widget _privacyTile(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
