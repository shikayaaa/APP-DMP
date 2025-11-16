import 'package:flutter/material.dart';
import 'editprofile_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart'; // 👈 added import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF), // 🔵 light blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A6CFF), // 🔵 blue top bar
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white, // white text for better contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Manage your account settings",
              style: TextStyle(
                color: Colors.white70, // softer white
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF0A6CFF), // blue circle
                  child: const Text(
                    "JD",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white, // white initials for contrast
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A6CFF), // name in blue
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "john.doe@example.com",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "+63 912 345 6789",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Plans and Payment Info
          Row(
            children: [
              Expanded(
                child: _infoCard("2", "Active Plans"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard("₱25,000", "Total Paid"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Contact Information
          _sectionTitle("Contact Information"),
          _contactTile(Icons.email, "john.doe@example.com", "Email Address"),
          _contactTile(Icons.phone, "+63 912 345 6789", "Phone Number"),
          _contactTile(Icons.location_on, "Dumaguete City, Negros Oriental", "Address"),
          _contactTile(Icons.calendar_today, "Member since January 2024", "Account Created"),

          const SizedBox(height: 16),

          // 🔹 Settings and Options
          _actionTile(
            context,
            Icons.edit,
            "Edit Profile",
            "Update your personal information",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          _actionTile(
            context,
            Icons.settings,
            "Settings",
            "App preferences and configurations",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          const SizedBox(height: 8),

          // 🔹 Sign Out
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Sign out of your account",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Footer
          const Center(
            child: Text(
              "Dumaguete Memorial Park v1.0.0\n© 2024 All rights reserved",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Info Card
  Widget _infoCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A6CFF), // blue for value
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A6CFF), // blue
        ),
      ),
    );
  }

  // 🔹 Contact Info Tile
  Widget _contactTile(IconData icon, String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A6CFF)),
        title: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  // 🔹 Action Tile
  Widget _actionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A6CFF)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
