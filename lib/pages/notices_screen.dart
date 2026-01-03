import 'package:flutter/material.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notices & Guidelines",
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
            fullText: _parkRules,
          ),
          _buildNoticeCard(
            context,
            icon: Icons.policy,
            title: "Policies & Procedures",
            description:
                "Important policies for lot ownership, transfers, and plan usage.",
            date: "Updated: Jan 2025",
            fullText: _policies,
          ),
          _buildNoticeCard(
            context,
            icon: Icons.help_outline,
            title: "Frequently Asked Questions",
            description:
                "Quick answers to common questions about plans, payments, and services.",
            date: "Updated: Dec 2024",
            fullText: _faq,
          ),
          _buildNoticeCard(
            context,
            icon: Icons.menu_book,
            title: "General Guidelines",
            description:
                "A helpful guide for lot owners and their families regarding memorial services.",
            date: "Updated: Nov 2024",
            fullText: _generalGuidelines,
          ),
        ],
      ),
    );
  }

  // ---------- CARD WIDGET ----------
  Widget _buildNoticeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String date,
    required String fullText,
  }) {
    return Card(
      color: Colors.white, // ← FIXED: WHITE CARD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(color: Colors.black54),
                ),
                TextButton(
                  child: const Text("Read More"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white, // ← FIXED: WHITE DIALOG
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Text(
                            fullText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
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

//--------------------------- FULL CONTENT TEXTS ---------------------------//

// 1. Park Rules & Regulations
const String _parkRules = """


1. Visiting Hours
• The park is open daily from 6:00 AM to 7:00 PM.
• Overnight stays are not allowed unless permitted for special occasions.

2. Conduct Inside the Park
• Maintain peaceful behavior at all times.
• Avoid loud music, shouting, or gatherings that may disturb others.
• Children must be accompanied by an adult.

3. Cleanliness & Environment Care
• Please dispose of all trash in designated bins.
• No picking of flowers, plants, or damaging landscaping.
• Pets are not allowed inside memorial grounds unless permitted.

4. Vehicles & Parking
• Drive slowly and follow park traffic rules.
• Parking is allowed only in designated areas.

5. Safety
• Climbing on structures, monuments, or tombstones is strictly prohibited.
• Firearms, fireworks, or dangerous items are not allowed.

Thank you for helping maintain a peaceful environment for all families.
""";

// 2. Policies & Procedures
const String _policies = """


1. Lot Ownership
• Ownership documents must be presented for verification.
• Only the registered owner or authorized representative may request services.

2. Transfer of Ownership
• All transfers must be processed through the administration office.
• Necessary documents include valid ID, transfer forms, and proof of ownership.

3. Interment Procedures
• Request for interment must be submitted at least 24–48 hours in advance.
• Required documents: Death Certificate, Burial Permit, Authorization forms.
• All fees must be settled before the service.

4. Maintenance Policy
• Park management performs general ground maintenance.
• Families are responsible for maintaining personal markers, flowers, and ornaments.

5. Prohibited Items
• Hazardous materials, permanent structures, and unauthorized renovations are not allowed.
""";

// 3. FAQs
const String _faq = """


1. What are the visiting hours?
• The park is open from 7:00 AM to 6:00 PM daily.

2. Can we bring food or set up tents?
• Small snacks are allowed.
• Tents, grills, and large gatherings require prior approval.

3. How do we request an interment?
• Visit the office or contact customer service at least 24–48 hours before the service.
• Prepare the required documents and payment.

4. Can I transfer my lot to another person?
• Yes, as long as ownership documents are updated and processed through the office.

5. Are pets allowed?
• Pets are not permitted inside the memorial grounds for safety and sanitation.

6. What forms of payment do you accept?
• Cash, bank transfer, and approved financing plans.
""";

// 4. General Guidelines
const String _generalGuidelines = """


1. Respect for the Sacred Grounds
• The memorial park is a place of remembrance — please act respectfully.
• Avoid stepping on graves or monuments whenever possible.

2. Decorations on Graves
• Fresh flowers are allowed.
• Avoid glass, candles, or sharp objects.
• Decorations may be removed after a certain period for safety and cleanliness.

3. Event Conduct
• Family gatherings should remain peaceful and orderly.
• Use designated spaces for ceremonies or services.

4. Photography & Recording
• Allowed, but be respectful and avoid capturing other visitors without permission.

5. Emergencies
• Contact park staff immediately for assistance or first-aid needs.

We appreciate your cooperation in keeping the park a safe and peaceful place.
""";
