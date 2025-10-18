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
      "color": Colors.blue,
      "title": "GCash",
      "subtitle": "Pay via GCash mobile wallet",
    },
    {
      "icon": Icons.payment,
      "color": Colors.green,
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
      backgroundColor: const Color.fromARGB(255, 181, 215, 216),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 249, 249)),
        title: const Text("Payment",
            style: TextStyle(color: Color.fromARGB(255, 252, 249, 249), fontWeight: FontWeight.bold)),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Choose payment method",
              style: TextStyle(color: Colors.black54, fontSize: 14),
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
              color: const Color.fromARGB(255, 95, 167, 164),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: const [
                Text("₱0",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("You are paying today",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                SizedBox(height: 6),
                Text("Next due: Nov 10, 2025 • ₱2,500",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
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
                    Icon(Icons.lock, color: Colors.green, size: 18),
                    SizedBox(width: 6),
                    Text("Secure Payment",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  "Your payment information is encrypted and secure.\nWe never store your card details.",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 8),
                Text(
                  "By proceeding with this payment, you agree to the terms and conditions of your memorial plan contract.\n\nPayment processing may take 1–3 business days depending on your chosen method.",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
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
                ? const Color.fromARGB(255, 245, 244, 244)
                : const Color.fromARGB(255, 238, 240, 240),
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
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
