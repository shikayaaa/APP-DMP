import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _openMap() async {
    final Uri mapUrl = Uri.parse('https://maps.app.goo.gl/fUyhiDi9hcVRsW817');
    if (!await launchUrl(mapUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not open the map link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF), // 🔵 light blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A6CFF), // 🔵 main blue
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "We're here to help you",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

      

            const SizedBox(height: 12),

            // EMAIL CARD
            _buildContactCard(
              context: context,
              icon: Icons.email,
              iconColor: const Color(0xFF0A6CFF), // 🔵 icon blue
              iconBgColor: const Color(0xFFE8F0FF), // 🔵 bg light blue
              title: "Email Us",
              subtitle: "Send us a detailed message",
              contact: "dumaguetememorialpark@gmail.com",
              buttonText: "Send Email",
              buttonColor: const Color(0xFF0046A3), // 🔵 dark blue
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening email app...")),
                );
              },
            ),

            const SizedBox(height: 20),

            // OFFICE HOURS
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFF0A6CFF), // 🔵 icon blue
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Office Hours",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildOfficeHourRow("Sunday - Monday", "6:00 AM - 7:00 PM"),
                  
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // VISIT OUR OFFICE
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFF0A6CFF), // 🔵 icon
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Visit Our Office",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Dumaguete Memorial Park",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "San Jose Ext., Taboan, Dumaguete City",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Negros Oriental, Philippines",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 12),

                    // VIEW MAP BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0A6CFF),
                          side: const BorderSide(
                            color: Color(0xFF0A6CFF), // 🔵 border blue
                            width: 1.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _openMap,
                        child: const Text(
                          "View Map",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF0A6CFF), // 🔵 text
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
    );
  }

  // CONTACT CARD
  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String contact,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        contact,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // 🔵 dark blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  elevation: 0,
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficeHourRow(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87),
        ),
      ],
    );
  }
}
