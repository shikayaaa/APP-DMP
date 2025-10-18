import 'package:flutter/material.dart';
import 'contact_support_screen.dart';  // ✅ For the button
   // ✅ For memorial services
import 'pricelist_screen.dart';
import 'intermentrequest_screen.dart';
import 'request_screen.dart';
import 'upcoming_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String selectedCategory = "Services"; // Default tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 189, 182),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        elevation: 0,
        title: const Text(
          "Services",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          // ✅ Top Category Buttons
          Container(
            color: const Color.fromARGB(255, 18, 186, 153),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("Services"),
                _buildCategoryButton("Requests"),
                _buildCategoryButton("Upcoming"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ✅ Show content depending on category
          Expanded(child: _buildCategoryContent()),
        ],
      ),
    );
  }

  // 🔘 Reusable Category Button
  Widget _buildCategoryButton(String category) {
    final bool isSelected = selectedCategory == category;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 35, 85, 81)
            : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(category),
    );
  }

  // 📦 Content depending on selected category
  Widget _buildCategoryContent() {
    if (selectedCategory == "Services") {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildServiceCard(
            "Pre-Need Installment Plans",
            "Secure your family's future with flexible payment plans...",
            "View Plans & Pricing",
          ),
          _buildServiceCard(
            "Interment Services",
            "Professional burial and interment services...",
            "Request Service",
          ),
          _buildServiceCard(
            "Memorial Services",
            "Commemorate your loved ones with beautiful memorial services...",
            "Learn More",
          ),
        ],
      );
    } else if (selectedCategory == "Requests") {
      return const RequestScreen();
    } else if (selectedCategory == "Upcoming") {
      return const UpcomingScreen();
    } else {
      return const Center(
        child: Text(
          "Select a category.",
          style: TextStyle(color: Colors.black87),
        ),
      );
    }
  }

  // 🔖 Service Card with navigation
  Widget _buildServiceCard(String title, String description, String buttonText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(description,
              style: const TextStyle(color: Color.fromARGB(136, 0, 0, 0))),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (buttonText == "View Plans & Pricing") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PriceListScreen(),
                  ),
                );
              } else if (buttonText == "Request Service") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntermentRequestScreen(),
                  ),
                );
              } else if (buttonText == "Learn More") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen(), // ✅ Navigate to LearnMoreScreen
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 119, 187, 179),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}