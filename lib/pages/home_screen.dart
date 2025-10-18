import 'package:flutter/material.dart';

// ✅ Correct relative imports (all inside pages folder)
import 'pricelist_screen.dart';
import 'intermentrequest_screen.dart';
import 'myplans_screen.dart';
import 'notices_screen.dart';
import 'contact_support_screen.dart';
import 'payments_screen.dart';
import 'services_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart'; // 🔹 Add this import



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 🔹 List of Screens for each BottomNavigationBar tab
  final List<Widget> _screens = [
    const HomeTab(),
    const PaymentsScreen(),
    const ServicesScreen(),
    const ProfileScreen(), // Profile screen
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.teal.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.miscellaneous_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/// 🔹 Extracted the "Home" content into its own widget
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Widget _buildQuickMenuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 186, 153),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 189, 182),
     appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 18, 186, 153),
  elevation: 0,
  title: const Text(
    "Quick Menu",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  actions: [
    Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // 🔹 Navigate to NotificationsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              "2",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  ],
),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Quick Menu Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickMenuItem(context, Icons.shopping_cart, "Buy a Lot",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PriceListScreen(),
                    ),
                  );
                }),
                _buildQuickMenuItem(context, Icons.folder_copy, "My Lots", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPlansScreen(),
                    ),
                  );
                }),
                _buildQuickMenuItem(
                    context, Icons.assignment, "Interment Request", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntermentRequestScreen(),
                    ),
                  );
                }),
                _buildQuickMenuItem(
                    context, Icons.menu_book, "Notices & Guidelines", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoticesScreen(),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // Contact & Support Button
            Center(
              child: SizedBox(
                width: 300,
                height: 100,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 186, 153),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactSupportScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.support_agent,
                      color: Colors.white, size: 36),
                  label: const Text(
                    "Contact & Support",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Activity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            _buildRecentActivity(
              "Payment Successful",
              "Feb 15, 2024 • ₱2,500",
              Icons.check_circle,
              Colors.green,
            ),
            _buildRecentActivity(
              "Payment Reminder",
              "Next due: March 15, 2024",
              Icons.alarm,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}