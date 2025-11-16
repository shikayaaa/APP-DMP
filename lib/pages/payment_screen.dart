import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? _selectedMethod; // store selected payment method

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "icon": Icons.account_balance_wallet,
      "color": Color(0xFF0A6CFF), // 🔵 Blue
      "title": "GCash",
      "subtitle": "Pay via GCash mobile wallet",
    },
    {
      "icon": Icons.payment,
      "color": Color(0xFF0A6CFF), // 🔵 Blue
      "title": "Maya (PayMaya)",
      "subtitle": "Pay via Maya digital wallet",
    },
    {
      "icon": Icons.account_balance,
      "color": Colors.grey,
      "title": "Bank Transfer",
      "subtitle": "Online banking or over-the-counter",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF), // 🔵 light blue
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A6CFF), // 🔵 main blue
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Payment",
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Choose payment method",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Amount Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0046A3), // 🔵 dark blue
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Text("₱0",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 6),
                Text("You are paying today",
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 6),
                Text("Next due: Nov 10, 2025 • ₱2,500",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Payment Methods
          Expanded(
            child: ListView.builder(
              itemCount: paymentMethods.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RadioListTile<int>(
                    value: index,
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    },
                    secondary: CircleAvatar(
                      backgroundColor:
                          (method["color"] as Color).withOpacity(0.1),
                      child: Icon(method["icon"], color: method["color"]),
                    ),
                    title: Text(method["title"]),
                    subtitle: Text(method["subtitle"]),
                  ),
                );
              },
            ),
          ),

          // Secure Payment Info
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.lock, color: Color(0xFF0A6CFF), size: 18), // 🔵 Blue
                    SizedBox(width: 6),
                    Text("Secure Payment",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  "Your payment information is encrypted and secure.\nWe never store your card details.",
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  "By proceeding with this payment, you agree to the terms and conditions of your memorial plan contract.\n\nPayment processing may take 1–3 business days depending on your chosen method.",
                  style: TextStyle(color: Colors.black87, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),

      // Confirm Payment Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: _selectedMethod == null
                ? const Color(0xFFB0CFFF) // 🔵 disabled light blue
                : const Color(0xFF0A6CFF), // 🔵 active blue
          ),
          onPressed: _selectedMethod == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Confirmed!")),
                  );
                },
          child: Text(
            _selectedMethod == null
                ? "Confirm Payment - ₱0"
                : "Confirm Payment - ₱2,500",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
