import 'package:dmp/pages/data_storage_screen.dart';
import 'package:flutter/material.dart';
import 'securitysettings_screen.dart';
import 'privacycontrols_screen.dart';
import 'appinfo_screen.dart';
import 'support_screen.dart'; // ✅ Added import for Help & Support screen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 189, 182),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Security & Privacy
          _sectionTitle("Security & Privacy"),
          _settingsTile(
            context,
            icon: Icons.security,
            color: Colors.red,
            title: "Security Settings",
            subtitle: "Password, 2FA, and account security",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecuritysettingsScreen(),
                ),
              );
            },
          ),
          _settingsTile(
            context,
            icon: Icons.lock,
            color: Colors.purple,
            title: "Privacy Controls",
            subtitle: "Data privacy and sharing preferences",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyControlsScreen(),
                ),
              );
            },
          ),

          // ✅ New Data Storage tile
          _settingsTile(
            context,
            icon: Icons.storage,
            color: Colors.teal,
            title: "Data Storage",
            subtitle: "Manage how your data is stored and used",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataStorageScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔹 App Settings
          _sectionTitle("App Settings"),
          _settingsTile(
            context,
            icon: Icons.info,
            color: Colors.blue,
            title: "App Info",
            subtitle: "About, Terms & Privacy Policy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppInfoScreen(),
                ),
              );
            },
          ),

          // ✅ Added Help & Support tile
          _settingsTile(
            context,
            icon: Icons.help_outline,
            color: Colors.orange,
            title: "Help & Support",
            subtitle: "Get assistance and contact support",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Section title widget
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 2, 77, 73),
        ),
      ),
    );
  }

  // 🔹 Reusable tile widget
  Widget _settingsTile(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
