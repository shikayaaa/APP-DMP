import 'package:flutter/material.dart';
import 'payment_screen.dart'; // <-- Import your PaymentScreen here
import 'paymenthistory_screen.dart'; // <-- Import your PaymentHistoryScreen here

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 221, 217),
      appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 18, 186, 153),
  elevation: 0,
  iconTheme: const IconThemeData(
    color: Colors.white, // 👈 makes the back arrow white
  ),
  title: const Text(
    "My Plans",
    style: TextStyle(
      color: Colors.white, // 👈 makes text white
      fontWeight: FontWeight.bold, // 👈 makes text bold
    ),
  ),
  centerTitle: false,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
  bottom: const PreferredSize(
    preferredSize: Size.fromHeight(20),
    child: Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        "Your memorial plan details",
        style: TextStyle(color: Color.fromARGB(179, 0, 62, 52), fontSize: 14),
      ),
    ),
  ),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Plan Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Premium",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Active",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("Garden Family Estate"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Start Date & Term
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("January 15, 2024"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Term",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("36 months"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Remaining Balance
                    const Text("Remaining Balance"),
                    const SizedBox(height: 4),
                    const Text(
                      "₱45,000",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.94,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.teal,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 6),
                    const Text("₱739,093 paid    •    94% complete",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),

                    // Next Payment Due
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 4, 4, 4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 13, 157, 167),
                            child: const Icon(Icons.calendar_today,
                                color: Colors.blue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Next Payment Due"),
                                SizedBox(height: 4),
                                Text("March 15, 2024",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Text(
                            "₱2,500",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal.shade900,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  icon: const Icon(Icons.payment, color: Colors.white), // icon white
  label: const Text(
    "Pay Now",
    style: TextStyle(
      color: Colors.white, // text white only, no bold
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      ),
    );
  },
),

                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.history),
                            label: const Text("History"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PaymentHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Plan Benefits Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Plan Benefits",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      Icons.nature,
                      "Perpetual Care Included",
                      "Ongoing maintenance and upkeep",
                    ),
                    _buildBenefitItem(
                      Icons.schedule,
                      "Flexible Payment Schedule",
                      "Pay early without penalties",
                    ),
                    _buildBenefitItem(
                      Icons.support_agent,
                      "24/7 Customer Support",
                      "Always here to help you",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for benefits
  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
