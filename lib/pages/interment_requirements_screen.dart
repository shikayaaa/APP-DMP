// Updated Flutter code with green header background and card-style transition
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorial Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black54,
                pageBuilder: (_, __, ___) => const IntermentRequirementsScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Text("View Requirements"),
        ),
      ),
    );
  }
}

class IntermentRequirementsScreen extends StatelessWidget {
  const IntermentRequirementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF00695C), // GREEN HEADER
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
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please ensure you have the following documents ready for the interment service:',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const RequirementCard(
                        title: 'Death Certificate',
                        subtitle: 'Original copy from the civil registrar',
                        icon: Icons.check_circle,
                        backgroundColor: Color(0xFFD1FAE5),
                        iconColor: Color(0xFF059669),
                        textColor: Color(0xFF065F46),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Burial Permit',
                        subtitle: 'Issued by the local health office',
                        icon: Icons.check_circle,
                        backgroundColor: Color(0xFFD1FAE5),
                        iconColor: Color(0xFF059669),
                        textColor: Color(0xFF065F46),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Medical Certificate',
                        subtitle: 'Cause of death from attending physician',
                        icon: Icons.description_outlined,
                        backgroundColor: Color(0xFFDBEAFE),
                        iconColor: Color(0xFF2563EB),
                        textColor: Color(0xFF1E40AF),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Valid ID of Claimant',
                        subtitle: 'Government-issued identification',
                        icon: Icons.badge_outlined,
                        backgroundColor: Color(0xFFDBEAFE),
                        iconColor: Color(0xFF2563EB),
                        textColor: Color(0xFF1E40AF),
                      ),
                      const SizedBox(height: 12),

                      const RequirementCard(
                        title: 'Proof of Lot Ownership',
                        subtitle: 'Contract or certificate of ownership',
                        icon: Icons.folder_copy,
                        backgroundColor: Color(0xFFFEF3C7),
                        iconColor: Color(0xFFD97706),
                        textColor: Color(0xFF92400E),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              height: 1.6,
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

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.grey[800],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(fontSize: 15),
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
  final Color iconColor;
  final Color textColor;

  const RequirementCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
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
                  style: TextStyle(color: textColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}