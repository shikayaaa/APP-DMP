import 'package:flutter/material.dart';

class SecuritysettingsScreen extends StatefulWidget {
  const SecuritysettingsScreen({super.key});

  @override
  State<SecuritysettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SecuritysettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _loginAlertsEnabled = true;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 77, 101, 159), // dark teal bg
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 68, 186),
        title: const Text("Security Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Protect your account and data",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Change Password
          _sectionTitle(Icons.lock, "Change Password"),
          _passwordField("Current Password", _currentPasswordController),
          _passwordField("New Password", _newPasswordController),
          _passwordField("Confirm New Password", _confirmPasswordController),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 204, 215, 214),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text(
              "Update Password",
              style: TextStyle(color: Colors.black), // 🔹 text black now
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Two-Factor Authentication
          _sectionTitle(Icons.phonelink_lock, "Two-Factor Authentication"),
          SwitchListTile(
            title: const Text("Enable 2FA"),
            subtitle:
                const Text("Add an extra layer of security to your account"),
            value: _twoFactorEnabled,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() {
                _twoFactorEnabled = val;
              });
            },
          ),

          const SizedBox(height: 20),

          // 🔹 Security Preferences
          _sectionTitle(Icons.shield, "Security Preferences"),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Login Alerts"),
                  subtitle: const Text(
                      "Get notified when someone signs into your account"),
                  value: _loginAlertsEnabled,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _loginAlertsEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Account Recovery"),
                  subtitle: const Text(
                      "Recovery email: john.doe@example.com\nRecovery phone: +63 912 345 6789"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 204, 215, 214),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Update Recovery Options",
                      style: TextStyle(color: Colors.black), // 🔹 text black now
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Recent Login Activity
          _sectionTitle(Icons.history, "Recent Login Activity"),
          _loginActivityTile(Icons.phone_iphone, "iPhone 14 Pro",
              "Dumaguete City, Negros Oriental", "2 hours ago", true),
          _loginActivityTile(Icons.computer, "Windows PC",
              "Dumaguete City, Negros Oriental", "1 day ago", false),
          _loginActivityTile(Icons.phone_android, "Android Phone",
              "Sibulan, Negros Oriental", "3 days ago", false),

          const SizedBox(height: 20),

          // 🔹 Emergency Actions
          _sectionTitle(Icons.warning, "Emergency Actions"),
          _emergencyButton(
            "Sign Out All Devices",
            const Color.fromARGB(255, 40, 110, 87),
            const Color.fromARGB(255, 3, 45, 20),
            () {
              // TODO: handle sign out all
            },
          ),
          const SizedBox(height: 10),
          _emergencyButton(
            "Lock Account Temporarily",
            Colors.white,
            const Color.fromARGB(255, 11, 35, 9),
            () {
              // TODO: handle lock account
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  // 🔹 Password TextField
  Widget _passwordField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.black), // 🔹 input text black
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: Colors.black54), // 🔹 hint text blackish
          suffixIcon: const Icon(Icons.visibility_off, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // 🔹 Login Activity Tile
  Widget _loginActivityTile(IconData icon, String device, String location,
      String time, bool isCurrent) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isCurrent ? Colors.green : Colors.blue),
        title: Row(
          children: [
            Text(device),
            if (isCurrent)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Current",
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ),
          ],
        ),
        subtitle: Text("$location\n$time"),
        isThreeLine: true,
      ),
    );
  }

  // 🔹 Emergency Buttons
  Widget _emergencyButton(
      String text, Color textColor, Color borderColor, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.5),
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
