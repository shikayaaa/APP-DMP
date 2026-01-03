import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'editprofile_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userProfile;
  bool _isLoading = true;
  int _activePlansCount = 0;
  double _totalPaid = 0.0;
  String _phoneNumber = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadAllUserData();
  }

  Future<void> _loadAllUserData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        // Load user profile
        final dbService = DatabaseService();
        final userProfile = await dbService.getUserProfile(currentUser.uid);

        // Load active plans count
        final plansSnapshot = await FirebaseFirestore.instance
            .collection('preNeedAgreements')
            .where('userId', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'active')
            .get();

        // Load total paid from payments
        final paymentsSnapshot = await FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'completed')
            .get();

        double total = 0.0;
        for (var doc in paymentsSnapshot.docs) {
          final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
          total += amount;
        }

        // Get phone and address from first active plan if available
        String phone = '+63 912 345 6789';
        String addr = 'Dumaguete City, Negros Oriental';
        
        if (plansSnapshot.docs.isNotEmpty) {
          final planData = plansSnapshot.docs.first.data();
          phone = planData['phone'] ?? phone;
          addr = planData['address'] ?? addr;
          if (planData['city'] != null && planData['city'].toString().isNotEmpty) {
            addr = '${planData['address'] ?? ''}, ${planData['city']}';
          }
        }

        setState(() {
          _userProfile = userProfile;
          _activePlansCount = plansSnapshot.docs.length;
          _totalPaid = total;
          _phoneNumber = phone;
          _address = addr;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatCurrency(double value) {
    return '₱${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  Future<void> _handleSignOut() async {
    try {
      final shouldSignOut = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldSignOut == true && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        );

        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signOut();

        if (mounted) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    final displayName = _userProfile?.displayName ?? 
                        FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? 
                        "User";
    final email = _userProfile?.email ?? 
                  FirebaseAuth.instance.currentUser?.email ?? 
                  "user@example.com";
    final initials = _getInitials(displayName);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
       
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Manage your account settings",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          Container(
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        _phoneNumber,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Plans and Payments (FIREBASE DATA)
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  _activePlansCount.toString(),
                  "Active Plans",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  _formatCurrency(_totalPaid),
                  "Total Paid",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact Info
          _sectionTitle("Contact Information"),
          _contactTile(Icons.email, email, "Email Address"),
          _contactTile(Icons.phone, _phoneNumber, "Phone Number"),
          _contactTile(Icons.location_on, _address, "Address"),
          _contactTile(
            Icons.calendar_today,
            "Member since ${_userProfile?.createdAt.year ?? DateTime.now().year}",
            "Account Created",
          ),

          const SizedBox(height: 16),

          // Action Tiles
          _actionTile(
            context,
            Icons.edit,
            "Edit Profile",
            "Update your personal information",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
          ),

          _actionTile(
            context,
            Icons.settings,
            "Settings",
            "App preferences and configurations",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()),
              );
            },
          ),

          const SizedBox(height: 8),

          // Sign Out Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _handleSignOut,
                child: const ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Sign out of your account",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "Dumaguete Memorial Park v1.0.0\n© 2024 All rights reserved",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _contactTile(IconData icon, String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}