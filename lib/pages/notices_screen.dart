import 'package:flutter/material.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // ← SIMPLE BLUE BACKGROUND

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0), // ← BLUE
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "New Interment Request",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNoticeCard(
            context,
            icon: Icons.rule,
            title: "Park Rules & Regulations",
            description:
                "Learn about visitation hours, proper conduct, and guidelines for memorial park visitors.",
            date: "Updated: Feb 2025",
          ),
          _buildNoticeCard(
            context,
            icon: Icons.policy,
            title: "Policies & Procedures",
            description:
                "Important policies for lot ownership, transfers, and plan usage.",
            date: "Updated: Jan 2025",
          ),
          _buildNoticeCard(
            context,
            icon: Icons.help_outline,
            title: "Frequently Asked Questions",
            description:
                "Quick answers to common questions about plans, payments, and services.",
            date: "Updated: Dec 2024",
          ),
          _buildNoticeCard(
            context,
            icon: Icons.menu_book,
            title: "General Guidelines",
            description:
                "A helpful guide for lot owners and their families regarding memorial services.",
            date: "Updated: Nov 2024",
          ),
        ],
      ),
    );
  }

  // helper widget
  Widget _buildNoticeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String date,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 28), // ← BLUE ICON
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // FIXED: White text → Black text so it's readable
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(221, 255, 255, 255),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                TextButton(
                  child: const Text("Read More"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(title),
                        content: Text(
                          "$description\n\nThis is the full content for $title.",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Close"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
