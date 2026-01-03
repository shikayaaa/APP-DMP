import 'package:flutter/material.dart';

class DataPrivacyComplianceScreen extends StatelessWidget {
  const DataPrivacyComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 62, 145),
        title: const Text(
          "Data Privacy Act Compliance",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Republic Act No. 10173",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 16),

          // 🔹 About the Data Privacy Act
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "The Data Privacy Act of 2012 (Republic Act No. 10173) is a law in the "
                "Philippines that protects individual personal information in information "
                "and communications systems in both government and private sector. "
                "Dumaguete Memorial Park is fully committed to compliance with this act.",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Our Compliance Measures",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),

          _buildCompliance(
            "Registered with NPC",
            "We are registered with the National Privacy Commission as a personal information controller.",
          ),
          _buildCompliance(
            "Data Protection Officer",
            "We have appointed a dedicated Data Protection Officer to oversee compliance and handle inquiries.",
          ),
          _buildCompliance(
            "Lawful Processing",
            "We process personal data only when we have a lawful basis (consent, contract, legal obligation, or legitimate interest).",
          ),
          _buildCompliance(
            "Data Minimization",
            "We only collect data that is necessary for providing our services and fulfilling our obligations.",
          ),
          _buildCompliance(
            "Security Safeguards",
            "We implement organizational, physical, and technical security measures to protect personal data.",
          ),
          _buildCompliance(
            "Breach Notification",
            "We have procedures to detect, report, and investigate personal data breaches within 72 hours.",
          ),

          const SizedBox(height: 20),
          const Text(
            "Your Rights Under the DPA",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),

          _buildRight("Right to be Informed", "Know what data is being collected and how it's used"),
          _buildRight("Right to Access", "Request copies of your personal data"),
          _buildRight("Right to Object", "Object to processing of your data"),
          _buildRight("Right to Erasure/Blocking", "Request deletion or suspension of data processing"),
          _buildRight("Right to Rectification", "Correct inaccurate or incomplete data"),
          _buildRight("Right to Data Portability", "Obtain and reuse your data for your own purposes"),
          _buildRight("Right to Damages", "Seek compensation for violations"),

          const SizedBox(height: 20),
          const Text(
            "Filing a Complaint",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),

          const Text(
            "If you believe your data privacy rights have been violated, you may file a complaint with:",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 10),

          // 🔹 National Privacy Commission
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
                    "National Privacy Commission",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "5th Floor, Philippine International Convention Center (PICC)\n"
                    "Vicente Sotto Street, Pasay City, 1307",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 6),
                  Text("Email: info@privacy.gov.ph", style: TextStyle(color: Colors.black)),
                  Text("Hotline: (02) 8234-2228", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Exercise Your Rights
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
                    "Exercise Your Rights",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "To exercise any of your data privacy rights, contact our Data Protection Officer at "
                    "privacy@dumaguetememorial.com or visit our office.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 I Understand button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 18, 54, 186),
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
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Compliance Item (White Card)
  static Widget _buildCompliance(String title, String subtitle) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  // 🔹 Rights Item (Just text, no card)
  static Widget _buildRight(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black)),
    );
  }
}
