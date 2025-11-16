import 'package:flutter/material.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});

  @override
  State<DataStorageScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  double documents = 12.4;
  double cache = 5.2;
  double receipts = 3.8;

  bool autoDownloadReceipts = true;
  bool syncDocuments = true;

  double get total => documents + cache + receipts;

  // 🔹 Show confirmation dialog
  Future<void> _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
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
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 3, 81),
        title: const Text("Data & Storage"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Storage Usage Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Storage Usage",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
          const Text("Data Management",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                onConfirm: () {
                  setState(() {
                    cache = 0.0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cache cleared successfully")),
                  );
                },
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
                onConfirm: () {
                  setState(() {
                    documents = 0.0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Download history cleared")),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔹 Download Preferences
          const Text("Download Preferences",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          _buildSwitchTile(
            "Auto-Download Receipts",
            "Payment receipts are automatically saved for offline access",
            autoDownloadReceipts,
            (val) {
              setState(() => autoDownloadReceipts = val);
            },
          ),
          _buildSwitchTile(
            "Sync Documents",
            "Keep your documents synced across devices",
            syncDocuments,
            (val) {
              setState(() => syncDocuments = val);
            },
          ),

          const SizedBox(height: 20),

          // 🔹 Data Security Notice
          Card(
            color: const Color.fromARGB(255, 93, 109, 174),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "🔒 Data Security\n\n"
                "All your data is encrypted and securely stored. "
                "Clearing cache will not delete your important documents or payment records.",
                style: TextStyle(fontSize: 14),
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
          Text(title,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14)),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  // 🔹 Switch Tile
  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SwitchListTile(
        activeColor: const Color.fromARGB(255, 3, 8, 78),
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
