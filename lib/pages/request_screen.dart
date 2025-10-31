import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 145, 189, 182),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // ✅ Requests List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRequestCard(
                  "Maria Santos Dela Cruz",
                  "Garden Family Estate • Block B, Lot 12",
                  "Requested Date: 3/25/2024",
                  "Submitted: 3/10/2024",
                  "Approved",
                  Colors.green,
                  2,
                ),
                _buildRequestCard(
                  "Roberto Villanueva",
                  "Memorial Garden • Block A, Lot 8, Niche 3",
                  "Requested Date: 4/5/2024",
                  "Submitted: 3/15/2024",
                  "Pending",
                  Colors.orange,
                  1,
                ),
                _buildRequestCard(
                  "Carmen Rodriguez",
                  "Lawn Area • Block C, Lot 25",
                  "Requested Date: 2/20/2024",
                  "Submitted: 2/10/2024",
                  "Completed",
                  Colors.blue,
                  3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔖 Request Card
  Widget _buildRequestCard(
    String name,
    String location,
    String requestedDate,
    String submittedDate,
    String status,
    Color statusColor,
    int documents,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // ✅ black
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            location,
            style: const TextStyle(color: Colors.black87), // ✅ black
          ),
          const SizedBox(height: 8),
          Text(
            requestedDate,
            style: const TextStyle(color: Colors.black87), // ✅ black
          ),
          Text(
            submittedDate,
            style: const TextStyle(color: Colors.black87), // ✅ black
          ),
          const SizedBox(height: 8),
          Text(
            "Note: Morning service preferred",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54, // ✅ black shade
            ),
          ),
          const SizedBox(height: 8),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$documents document(s)",
                style: const TextStyle(color: Colors.black87), // ✅ black
              ),
            ],
          ),
        ],
      ),
    );
  }
}
