import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12BA99),
        title: const Text("Help & Support"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            "Need Help?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "If you experience any issues or have questions, you can reach us through the following support channels:",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text("Email"),
              subtitle: Text("dumaguetememorialpark@gmail.com"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text("Phone"),
              subtitle: Text("(035) 422-XXXX"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.help_outline, color: Colors.teal),
              title: Text("FAQ"),
              subtitle: Text("Visit our website for frequently asked questions."),
            ),
          ),
        ],
      ),
    );
  }
}
