import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 190, 183),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
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
            // Contact Us Header
            const Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Call Office Card
            _buildContactCard(
              context: context,
              icon: Icons.phone,
              iconColor: const Color(0xFF4CAF50),
              iconBgColor: const Color(0xFFE8F5E9),
              title: "Call Office",
              subtitle: "Speak with our customer service team",
              contact: "0965-143-2479 / 0956-496-9637",
              buttonText: "Call Now",
              buttonColor: const Color(0xFF00695C),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening phone dialer...")),
                );
              },
            ),

            const SizedBox(height: 12),

            // Email Us Card
            _buildContactCard(
              context: context,
              icon: Icons.email,
              iconColor: const Color(0xFF2196F3),
              iconBgColor: const Color(0xFFE3F2FD),
              title: "Email Us",
              subtitle: "Send us a detailed message",
              contact: "dumaguetememorialpark@gmail.com",
              buttonText: "Send Email",
              buttonColor: const Color(0xFF00695C),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening email app...")),
                );
              },
            ),

            const SizedBox(height: 12),

            

            const SizedBox(height: 20),

            // Office Hours Card
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
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF00695C),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Office Hours",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildOfficeHourRow("Monday - Friday", "8:00 AM - 5:00 PM"),
                    const SizedBox(height: 6),
                    _buildOfficeHourRow("Saturday", "Closed"),
                    const SizedBox(height: 6),
                    _buildOfficeHourRow("Sunday", "Closed"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Visit Our Office Card
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
                          color: Color(0xFF00695C),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Visit Our Office",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Dumaguete Memorial Park",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "San Jose Ext., Taboan, Dumaguete City",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "Negros Oriental, Philippines",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Expanded View Map Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00695C),
                          side: const BorderSide(
                            color: Color(0xFF00695C),
                            width: 1.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Opening map...")),
                          );
                        },
                        child: const Text(
                          "View Map",
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
    );
  }

  // Reusable Contact Card
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
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
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
                  backgroundColor: buttonColor,
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
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
