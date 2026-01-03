import 'package:flutter/material.dart';
import 'terms_of service_screen.dart';
import 'privacypolicy_screen.dart';
import 'data_privacy_compliance_screen.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 52, 186),
        title: const Text("App Information"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "About Dumaguete Memorial Park App",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.white, // ✅ WHITE CARD
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFDFF3E6),
                child: Icon(Icons.apartment,
                    color: Color.fromARGB(255, 76, 152, 175)),
              ),
              title: Text(
                "Dumaguete Memorial Park",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // ✅ BLACK TEXT
                ),
              ),
              subtitle: Text(
                "Version 1.0.0\nYour trusted digital companion for managing "
                "pre-need cemetery lot plans, payments, and interment services.",
                style: TextStyle(color: Colors.black), // ✅ BLACK TEXT
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Key Features",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          _buildFeature("Pre-need installment plan management"),
          _buildFeature("Secure payment processing (GCash, Maya, Bank Transfer)"),
          _buildFeature("Digital document management"),
          _buildFeature("Interment request submission"),
          _buildFeature("Real-time payment tracking & receipts"),

          const SizedBox(height: 20),

          const Text(
            "Legal & Privacy",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildNavTile(
            context,
            title: "Terms of Service",
            subtitle: "View our terms and conditions",
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),

          _buildNavTile(
            context,
            title: "Privacy Policy",
            subtitle: "How we protect your data",
            icon: Icons.privacy_tip,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          _buildNavTile(
            context,
            title: "Data Privacy Act Compliance",
            subtitle: "Republic Act No. 10173",
            icon: Icons.shield,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataPrivacyComplianceScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Card(
                color: Colors.white, // ✅ WHITE CARD
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Dumaguete Memorial Park & Crematory",
                          style: TextStyle(color: Colors.black)),
                      Text("Bagacay, Dumaguete City, Negros Oriental",
                          style: TextStyle(color: Colors.black)),
                      SizedBox(height: 8),
                      Text("Email: info@dumaguetememorial.com",
                          style: TextStyle(color: Colors.black)),
                      Text("Phone: (035) 422-XXXX",
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 243, 242),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Close",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Feature tile
  static Widget _buildFeature(String text) {
    return Card(
      color: Colors.white, // ✅ WHITE
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading:
            const Icon(Icons.check_circle, color: Color.fromARGB(255, 76, 175, 173)),
        title: Text(
          text,
          style: const TextStyle(color: Colors.black), // ✅ BLACK TEXT
        ),
      ),
    );
  }

  // 🔹 Navigation Card Tile
  static Widget _buildNavTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white, // ✅ WHITE CARD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          child: Icon(icon, color: const Color.fromARGB(255, 5, 0, 150)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ BLACK TEXT
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black), // ✅ BLACK TEXT
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
