import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

// Screens
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
        selectedItemColor: Colors.blue.shade800,
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
  List<Map<String, dynamic>> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRecentActivities();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final dbService = DatabaseService();
        final userProfile = await dbService.getUserProfile(user.uid);

        setState(() {
          _userName = userProfile?.displayName ??
              user.email?.split('@')[0] ??
              "User";
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get recent payments
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('paidAt', descending: true)
          .limit(3)
          .get();

      List<Map<String, dynamic>> activities = [];

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'type': 'payment',
          'title': 'Payment Successful',
          'subtitle': '${_formatDate(data['paidAt'])} • ${_formatCurrency((data['amount'] as num?)?.toDouble() ?? 0.0)}',
          'icon': Icons.check_circle,
          'color': Colors.green,
        });
      }

      // Get next payment due
      final agreementSnapshot = await FirebaseFirestore.instance
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (agreementSnapshot.docs.isNotEmpty) {
        final agreement = agreementSnapshot.docs.first.data();
        activities.add({
          'type': 'reminder',
          'title': 'Payment Reminder',
          'subtitle': 'Next due: ${agreement['nextPaymentDate'] ?? 'TBD'}',
          'icon': Icons.alarm,
          'color': Colors.blue,
        });
      }

      setState(() {
        _recentActivities = activities;
      });
    } catch (e) {
      // Silently fail - recent activities are optional
      print('Error loading activities: $e');
    }
  }

  String _formatCurrency(double value) {
    return '₱${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = timestamp.toDate();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildQuickMenuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
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
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth > 1000 ? 800 : (screenWidth * 0.9);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
              if (_recentActivities.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _recentActivities.length.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
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
                GridView.count(
                  crossAxisCount: screenWidth > 900 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickMenuItem(context, Icons.shopping_cart,
                        "Buy a Lot", () {
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

                const SizedBox(height: 24),

                SizedBox(
                  width: 350,
                  height: 90,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),

                if (_recentActivities.isEmpty)
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: const [
                          Icon(Icons.inbox, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'No recent activities',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._recentActivities.map((activity) => _buildRecentActivity(
                        activity['title'],
                        activity['subtitle'],
                        activity['icon'],
                        activity['color'],
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}