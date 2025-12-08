import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

// Correct imports
import 'pricelist_screen.dart';
import 'intermentrequest_screen.dart';
import 'myplans_screen.dart';
import 'notices_screen.dart';
import 'contact_support_screen.dart';
import 'payments_screen.dart';
import 'services_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const PaymentsScreen(),
    const ServicesScreen(),
    const ProfileScreen(),
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
        selectedItemColor: Colors.blue.shade800, // BLUE
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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _userName = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        final dbService = DatabaseService();
        final userProfile = await dbService.getUserProfile(currentUser.uid);
        setState(() {
          _userName = userProfile?.displayName ?? currentUser.email?.split('@')[0] ?? "User";
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildQuickMenuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue, // BLUE BOX
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth =
        screenWidth > 1000 ? 800 : (screenWidth * 0.9);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 180, 205, 255), // LIGHT BLUE BG
      appBar: AppBar(
        backgroundColor: Colors.blue, // BLUE
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _isLoading
            ? const Text(
                "Quick Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                "Welcome, $_userName!",
                style: const TextStyle(
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

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quick Menu
                GridView.count(
                  crossAxisCount: screenWidth > 900 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickMenuItem(
                        context, Icons.shopping_cart, "Buy a Lot", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PriceListScreen(),
                        ),
                      );
                    }),
                    _buildQuickMenuItem(
                        context, Icons.folder_copy, "My Lots", () {
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
                          builder: (context) =>
                              const IntermentRequestScreen(),
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

                const SizedBox(height: 24),

                // Contact & Support Button
                SizedBox(
                  width: 350,
                  height: 90,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // BLUE
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
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

                const SizedBox(height: 30),

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
        ),
      ),
    );
  }
}