import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});

  @override
  State<DataStorageScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  double documents = 0.0;
  double cache = 0.0;
  double receipts = 0.0;

  bool autoDownloadReceipts = true;
  bool syncDocuments = true;
  bool _isLoading = true;

  double get total => documents + cache + receipts;

  @override
  void initState() {
    super.initState();
    _loadStorageData();
  }

  // 🔹 Load storage data from Firebase
  Future<void> _loadStorageData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('storage_settings')
          .doc('data')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          documents = (data['documents'] ?? 12.4).toDouble();
          cache = (data['cache'] ?? 5.2).toDouble();
          receipts = (data['receipts'] ?? 3.8).toDouble();
          autoDownloadReceipts = data['autoDownloadReceipts'] ?? true;
          syncDocuments = data['syncDocuments'] ?? true;
          _isLoading = false;
        });
      } else {
        // Initialize with default values if no data exists
        await _saveStorageData();
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Error loading storage data: ${e.toString()}');
    }
  }

  // 🔹 Save storage data to Firebase
  Future<void> _saveStorageData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('storage_settings')
          .doc('data')
          .set({
        'documents': documents,
        'cache': cache,
        'receipts': receipts,
        'autoDownloadReceipts': autoDownloadReceipts,
        'syncDocuments': syncDocuments,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _showErrorSnackbar('Error saving storage data: ${e.toString()}');
    }
  }

  // 🔹 Clear cache
  Future<void> _clearCache() async {
    setState(() => cache = 0.0);
    await _saveStorageData();
    _showSuccessSnackbar('Cache cleared successfully');
  }

  // 🔹 Clear download history
  Future<void> _clearDownloadHistory() async {
    setState(() => documents = 0.0);
    await _saveStorageData();
    _showSuccessSnackbar('Download history cleared');
  }

  // 🔹 Update preference
  Future<void> _updatePreference(String key, bool value) async {
    if (key == 'autoDownloadReceipts') {
      setState(() => autoDownloadReceipts = value);
    } else if (key == 'syncDocuments') {
      setState(() => syncDocuments = value);
    }
    await _saveStorageData();
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

  // 🔹 Show confirmation dialog
  Future<void> _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        content: Text(message, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 1, 93),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFEFF6F5),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 3, 81),
          title: const Text("Data & Storage", style: TextStyle(color: Colors.white)),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 11, 3, 81),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 3, 81),
        title: const Text("Data & Storage", style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Storage Usage Card
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Storage Usage",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStorageRow(
                      "Documents & Files", "${documents.toStringAsFixed(1)} MB"),
                  _buildStorageRow(
                      "Cached Data", "${cache.toStringAsFixed(1)} MB"),
                  _buildStorageRow("Payment Receipts",
                      "${receipts.toStringAsFixed(1)} MB"),
                  const Divider(),
                  _buildStorageRow(
                      "Total Storage", "${total.toStringAsFixed(1)} MB",
                      bold: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Data Management
          const Text(
            "Data Management",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          _buildActionTile(
            title: "Clear Cache",
            subtitle: "Free up ${cache.toStringAsFixed(1)} MB of storage",
            icon: Icons.delete_sweep,
            color: Colors.blue,
            onTap: () {
              _showConfirmDialog(
                title: "Clear Cache",
                message: "Are you sure you want to clear cached data?",
                onConfirm: _clearCache,
              );
            },
          ),
          _buildActionTile(
            title: "Clear Download History",
            subtitle: "Remove temporary downloads",
            icon: Icons.history,
            color: Colors.orange,
            onTap: () {
              _showConfirmDialog(
                title: "Clear Download History",
                message: "Are you sure you want to clear download history?",
                onConfirm: _clearDownloadHistory,
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔹 Download Preferences
          const Text(
            "Download Preferences",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          _buildSwitchTile(
            "Auto-Download Receipts",
            "Payment receipts are automatically saved for offline access",
            autoDownloadReceipts,
            (val) => _updatePreference('autoDownloadReceipts', val),
          ),
          _buildSwitchTile(
            "Sync Documents",
            "Keep your documents synced across devices",
            syncDocuments,
            (val) => _updatePreference('syncDocuments', val),
          ),

          const SizedBox(height: 20),

          // 🔹 Data Security Notice
          Card(
            color: const Color.fromARGB(255, 93, 109, 174),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "🔒 Data Security\n\n"
                "All your data is encrypted and securely stored. "
                "Clearing cache will not delete your important documents or payment records.",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Done Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 3, 77),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Done",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Storage Row
  Widget _buildStorageRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Action Tile
  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
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
        onTap: onTap,
      ),
    );
  }

  // 🔹 Switch Tile
  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SwitchListTile(
        activeColor: const Color.fromARGB(255, 3, 8, 78),
        value: value,
        onChanged: onChanged,
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
}