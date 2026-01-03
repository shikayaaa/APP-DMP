import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 167, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 35, 186),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "How we collect, use, and protect your data",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 16),

          _buildSection(
            "Information We Collect",
            [
              "Personal Information: Name, email, phone number, address",
              "Financial Information: Payment details, transaction history",
              "Account Information: Login credentials, preferences",
              "Documents: ID copies, interment-related documents",
              "Usage Data: App activity, device information",
            ],
          ),

          _buildSection(
            "How We Use Your Information",
            [
              "Process and manage your pre-need plan payments",
              "Verify your identity and prevent fraud",
              "Send payment reminders and important notifications",
              "Process interment requests and services",
              "Improve our app and customer service",
              "Comply with legal and regulatory requirements",
            ],
          ),

          _buildSection(
            "Data Security",
            [
              "AES-256 encryption for all sensitive data",
              "Secure SSL/TLS communication protocols",
              "PCI-DSS compliant payment processing",
              "Regular security audits and updates",
              "Access controls and authentication systems",
            ],
          ),

          _buildSection(
            "Information Sharing",
            [
              "Payment processors (GCash, Maya, banks) for transactions",
              "Government agencies when legally required",
              "Service providers who assist in app operations",
              "Legal authorities in case of disputes or fraud",
            ],
          ),

          _buildSection(
            "Your Rights",
            [
              "Access your personal data at any time",
              "Request corrections to inaccurate information",
              "Request deletion of your data (subject to legal obligations)",
              "Opt-out of marketing communications",
              "File a complaint with the National Privacy Commission",
            ],
          ),

          _buildSection(
            "Data Retention",
            [
              "We retain your personal information as needed to fulfill the purposes outlined in this policy.",
              "Financial records are kept for a minimum of 10 years per Philippine regulations.",
            ],
          ),

          _buildSection(
            "Cookies & Tracking",
            [
              "We use cookies and similar technologies to improve your experience and maintain your session.",
              "You can manage cookie preferences in your device settings.",
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 Contact Privacy Officer
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Our Privacy Officer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "For privacy-related inquiries, contact our Data Protection Officer at:",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "privacy@dumaguetememorial.com",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 I Understand Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 18, 52, 186),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "I Understand",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper Method for Sections
  static Widget _buildSection(String title, List<String> items) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "• ",
                      style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
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
}
