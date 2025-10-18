import 'package:flutter/material.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
     appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 18, 186, 153),
  iconTheme: const IconThemeData(color: Colors.white), // ← makes the arrow white
  title: const Text(
    "New Interment Request",
    style: TextStyle(
      color: Colors.white, // ← makes text white
      fontWeight: FontWeight.bold, // ← makes it bold
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

  // helper widget for a card
  Widget _buildNoticeCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required String date}) {
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
                Icon(icon, color: Colors.teal, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(color: Colors.grey)),
                TextButton(
                  child: const Text("Read More"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(title),
                        content: Text(
                            "$description\n\nThis is the full content for $title."),
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
            )
          ],
        ),
      ),
    );
  }
}
