import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecuritysettingsScreen extends StatefulWidget {
  const SecuritysettingsScreen({super.key});

  @override
  State<SecuritysettingsScreen> createState() => _SecuritysettingsScreenState();
}

class _SecuritysettingsScreenState extends State<SecuritysettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _loginAlertsEnabled = true;
  bool _isLoading = true;
  bool _isUpdating = false;

  // Password visibility toggles
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _recoveryEmailController = TextEditingController();
  final TextEditingController _recoveryPhoneController = TextEditingController();

  List<Map<String, dynamic>> _loginActivities = [];

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
    _loadLoginActivities();
  }

  Future<void> _loadSecuritySettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('security_settings')
          .doc('preferences')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _twoFactorEnabled = data['twoFactorEnabled'] ?? false;
          _loginAlertsEnabled = data['loginAlertsEnabled'] ?? true;
          _recoveryEmailController.text = data['recoveryEmail'] ?? '';
          _recoveryPhoneController.text = data['recoveryPhone'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Error loading settings: ${e.toString()}');
    }
  }

  Future<void> _loadLoginActivities() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('login_activities')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      setState(() {
        _loginActivities = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error loading login activities: $e');
    }
  }

  Future<void> _updatePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackbar('Please fill in all password fields');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackbar('New passwords do not match');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorSnackbar('Password must be at least 6 characters');
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(_newPasswordController.text);

      // Log the password change
      await _logSecurityEvent('password_changed');

      _showSuccessSnackbar('Password updated successfully');

      // Clear fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showErrorSnackbar('Current password is incorrect');
      } else if (e.code == 'weak-password') {
        _showErrorSnackbar('Password is too weak');
      } else {
        _showErrorSnackbar('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Error updating password: ${e.toString()}');
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _updateSecurityPreference(String key, bool value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('security_settings')
          .doc('preferences')
          .set({
        key: value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _logSecurityEvent('${key}_${value ? "enabled" : "disabled"}');
    } catch (e) {
      _showErrorSnackbar('Error updating preference: ${e.toString()}');
    }
  }

  Future<void> _updateRecoveryOptions() async {
    if (_recoveryEmailController.text.isEmpty && _recoveryPhoneController.text.isEmpty) {
      _showErrorSnackbar('Please provide at least one recovery option');
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('security_settings')
          .doc('preferences')
          .set({
        'recoveryEmail': _recoveryEmailController.text.trim(),
        'recoveryPhone': _recoveryPhoneController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _logSecurityEvent('recovery_options_updated');

      Navigator.pop(context);
      _showSuccessSnackbar('Recovery options updated successfully');
    } catch (e) {
      _showErrorSnackbar('Error updating recovery options: ${e.toString()}');
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _logSecurityEvent(String eventType) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('security_logs')
          .add({
        'eventType': eventType,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
    } catch (e) {
      print('Error logging security event: $e');
    }
  }

  Future<void> _signOutAllDevices() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out All Devices',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will sign you out from all devices including this one. You will need to sign in again.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _logSecurityEvent('signed_out_all_devices');
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                _showErrorSnackbar('Error signing out: ${e.toString()}');
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _lockAccountTemporarily() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Lock Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your account will be locked for 24 hours. You won\'t be able to sign in during this period.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({
                  'accountLocked': true,
                  'lockedUntil': Timestamp.fromDate(
                    DateTime.now().add(const Duration(hours: 24)),
                  ),
                });

                await _logSecurityEvent('account_locked_temporarily');
                await FirebaseAuth.instance.signOut();

                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                _showErrorSnackbar('Error locking account: ${e.toString()}');
              }
            },
            child: const Text('Lock Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRecoveryOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Update Recovery Options',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _recoveryEmailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Recovery Email',
                labelStyle: const TextStyle(color: Colors.black),
                hintText: 'example@email.com',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _recoveryPhoneController,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Recovery Phone',
                labelStyle: const TextStyle(color: Colors.black),
                hintText: '+63 912 345 6789',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: _isUpdating ? null : _updateRecoveryOptions,
            child: _isUpdating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _recoveryEmailController.dispose();
    _recoveryPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 18, 68, 186),
          title: const Text("Security Settings", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 109, 188),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 68, 186),
        title: const Text("Security Settings", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Protect your account and data",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Change Password
          _sectionTitle(Icons.lock, "Change Password"),
          _passwordField(
            "Current Password",
            _currentPasswordController,
            _showCurrentPassword,
            () => setState(() => _showCurrentPassword = !_showCurrentPassword),
          ),
          _passwordField(
            "New Password",
            _newPasswordController,
            _showNewPassword,
            () => setState(() => _showNewPassword = !_showNewPassword),
          ),
          _passwordField(
            "Confirm New Password",
            _confirmPasswordController,
            _showConfirmPassword,
            () => setState(() => _showConfirmPassword = !_showConfirmPassword),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isUpdating ? null : _updatePassword,
            child: _isUpdating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                : const Text("Update Password", style: TextStyle(color: Colors.black)),
          ),

          const SizedBox(height: 20),

          // Two-Factor Authentication
          _sectionTitle(Icons.phonelink_lock, "Two-Factor Authentication"),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text("Enable 2FA", style: TextStyle(color: Colors.black)),
              subtitle: const Text("Add an extra layer of security to your account", style: TextStyle(color: Colors.black87)),
              value: _twoFactorEnabled,
              activeColor: Colors.teal,
              onChanged: (val) {
                setState(() => _twoFactorEnabled = val);
                _updateSecurityPreference('twoFactorEnabled', val);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Security Preferences
          _sectionTitle(Icons.shield, "Security Preferences"),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Login Alerts", style: TextStyle(color: Colors.black)),
                  subtitle: const Text("Get notified when someone signs into your account", style: TextStyle(color: Colors.black87)),
                  value: _loginAlertsEnabled,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() => _loginAlertsEnabled = val);
                    _updateSecurityPreference('loginAlertsEnabled', val);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Account Recovery", style: TextStyle(color: Colors.black)),
                  subtitle: Text(
                    'Recovery email: ${_recoveryEmailController.text.isEmpty ? "Not set" : _recoveryEmailController.text}\n'
                    'Recovery phone: ${_recoveryPhoneController.text.isEmpty ? "Not set" : _recoveryPhoneController.text}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: _showRecoveryOptionsDialog,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Recent Login Activity
          _sectionTitle(Icons.history, "Recent Login Activity"),
          if (_loginActivities.isEmpty)
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No login activities recorded', style: TextStyle(color: Colors.black87)),
                ),
              ),
            )
          else
            ..._loginActivities.map((activity) {
              final isCurrent = activity['isCurrent'] ?? false;
              return _loginActivityTile(
                _getDeviceIcon(activity['device'] ?? 'Unknown'),
                activity['device'] ?? 'Unknown Device',
                activity['location'] ?? 'Unknown Location',
                _formatTimestamp(activity['timestamp']),
                isCurrent,
              );
            }).toList(),

          const SizedBox(height: 20),

          // Emergency Actions
          _sectionTitle(Icons.warning, "Emergency Actions"),
          _emergencyButton(
            "Sign Out All Devices",
            Colors.white,
            _signOutAllDevices,
          ),
          const SizedBox(height: 10),
          _emergencyButton(
            "Lock Account Temporarily",
            Colors.white,
            _lockAccountTemporarily,
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String device) {
    if (device.toLowerCase().contains('iphone') || device.toLowerCase().contains('ios')) {
      return Icons.phone_iphone;
    } else if (device.toLowerCase().contains('android')) {
      return Icons.phone_android;
    } else if (device.toLowerCase().contains('windows') || device.toLowerCase().contains('mac')) {
      return Icons.computer;
    }
    return Icons.devices;
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(
    String hint,
    TextEditingController controller,
    bool showPassword,
    VoidCallback onToggle,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: !showPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _loginActivityTile(
    IconData icon,
    String device,
    String location,
    String time,
    bool isCurrent,
  ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isCurrent ? Colors.green : Colors.blue),
        title: Row(
          children: [
            Text(device, style: const TextStyle(color: Colors.black)),
            if (isCurrent)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Current", style: TextStyle(fontSize: 12, color: Colors.green)),
              ),
          ],
        ),
        subtitle: Text("$location\n$time", style: const TextStyle(color: Colors.black87)),
        isThreeLine: true,
      ),
    );
  }

  Widget _emergencyButton(
    String text,
    Color buttonColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}