import 'package:flutter/material.dart';
import 'package:dmp/pages/login_screen.dart';
import 'package:dmp/pages/signup_screen.dart'; // ✅ added import for signup

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  // ✅ Function to show authentication dialog
  void _showAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, color: Colors.teal, size: 50),
              const SizedBox(height: 12),
              const Text(
                "Authentication Required",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please log in or create an account to avail our services.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // ✅ Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Create Account Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.teal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memorial Park"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ServiceCard(
              icon: Icons.park_outlined,
              title: "Lawn Area",
              description:
                  "Traditional lawn burial spaces with well-maintained grounds.",
              categories: const [
                "Prime",
                "Special Premium",
                "Premium",
                "Regular",
              ],
              onAvailPressed: () => _showAuthDialog(context),
            ),
            ServiceCard(
              icon: Icons.grass_outlined,
              title: "Memorial Garden",
              description:
                  "Peaceful garden settings with ornamental landscaping.",
              categories: const [
                "Special Premium",
                "Premium",
                "Regular",
              ],
              onAvailPressed: () => _showAuthDialog(context),
            ),
            ServiceCard(
              icon: Icons.house_siding_outlined,
              title: "Garden Family Estate",
              description:
                  "Private family plots in serene garden environments.",
              categories: const [
                "Special Premium",
                "Premium",
              ],
              onAvailPressed: () => _showAuthDialog(context),
            ),
            ServiceCard(
              icon: Icons.account_balance_outlined,
              title: "Family Estate",
              description:
                  "Exclusive family mausoleums and estate properties.",
              categories: const [
                "Premier",
                "Prestige",
              ],
              onAvailPressed: () => _showAuthDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Updated ServiceCard widget with callback
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> categories;
  final VoidCallback onAvailPressed;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.categories,
    required this.onAvailPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Column(
              children: categories
                  .map(
                    (category) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          const Text("Contact for pricing",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 127, 220, 211),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onAvailPressed,
                child: const Text("Avail Service"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
