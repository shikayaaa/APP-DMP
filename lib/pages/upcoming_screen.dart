import 'package:flutter/material.dart';

// Make sure you have this file in your project
// import 'interment_requirements_screen.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header: Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Maria Santos Dela Cruz",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // ✅ changed to black
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Confirmed",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text(
            "Garden Family Estate • Block B, Lot 12",
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 16),

          // 🔹 Date Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today, color: Colors.teal, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Monday, March 25, 2024",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black, // ✅ black
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Please arrive 30 minutes before the scheduled time",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Text(
            "Note: Morning service preferred",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // 👉 Navigate to Interment Requirements Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntermentRequirementsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 105, 185, 177),
                  foregroundColor: Colors.black, // ✅ text now black
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("View Requirements"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// ========================================
// INTERMENT REQUIREMENTS SCREEN
// Save this as: interment_requirements_screen.dart
// ========================================

class IntermentRequirementsScreen extends StatelessWidget {
  const IntermentRequirementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // ✅ light background instead of dark
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F5257),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Interment Requirements',
                      style: TextStyle(
                        color: Colors.black, // ✅ changed from white
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.black, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please ensure you have the following documents ready for the interment service:',
                        style: TextStyle(
                          color: Colors.black87, // ✅ black
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const RequirementCard(
                        title: 'Death Certificate',
                        subtitle: 'Original copy from the civil registrar',
                        icon: Icons.check_circle,
                        backgroundColor: Color(0xFFD1FAE5),
                        textColor: Color(0xFF065F46),
                        iconColor: Color(0xFF059669),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Burial Permit',
                        subtitle: 'Issued by the local health office',
                        icon: Icons.check_circle,
                        backgroundColor: Color(0xFFD1FAE5),
                        textColor: Color(0xFF065F46),
                        iconColor: Color(0xFF059669),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Medical Certificate',
                        subtitle: 'Cause of death from attending physician',
                        icon: Icons.description,
                        backgroundColor: Color(0xFFDBEAFE),
                        textColor: Color(0xFF1E40AF),
                        iconColor: Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Valid ID of Claimant',
                        subtitle: 'Government-issued identification',
                        icon: Icons.description,
                        backgroundColor: Color(0xFFDBEAFE),
                        textColor: Color(0xFF1E40AF),
                        iconColor: Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Proof of Lot Ownership',
                        subtitle: 'Contract or certificate of ownership',
                        icon: Icons.access_time,
                        backgroundColor: Color(0xFFFEF3C7),
                        textColor: Color(0xFF92400E),
                        iconColor: Color(0xFFD97706),
                      ),

                      const SizedBox(height: 20),

                      // Note Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black87, // ✅ black
                              fontSize: 13,
                              height: 1.5,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Note: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Please bring original copies and one photocopy of each document. Arrive at least 30 minutes before the scheduled interment time.',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Close Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 145, 189, 182),
                            foregroundColor: Colors.black, // ✅ black text
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }
}

class RequirementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const RequirementCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
