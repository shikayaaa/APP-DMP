import 'package:flutter/material.dart';

class GardenfamilyScreen extends StatefulWidget {
  const GardenfamilyScreen({super.key});

  @override
  State<GardenfamilyScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<GardenfamilyScreen> {
  String selectedCategory = "Garden Family";

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Garden Family "),
        backgroundColor: Colors.teal.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Browse available lots",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),

            

            const SizedBox(height: 20),

            // Show Garden Family Estate Cards when selected
            if (selectedCategory == "Garden Family") ...[
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.teal),
                  SizedBox(width: 6),
                  Text(
                    "Garden Family Estate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    _buildLotCard(
                      title: "Special Premium",
                      lotPrice: "₱806,586",
                      care: "₱44,722",
                      total: "₱851,308",
                      downPayment: "₱170,262",
                      monthly: {
                        "12 mos": "₱64,397\nTotal: ₱943,026",
                        "36 mos": "₱26,957\nTotal: ₱1,127,574",
                        "60 mos": "₱19,069\nTotal: ₱1,314,402",
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLotCard(
                      title: "Premium",
                      lotPrice: "₱739,371",
                      care: "₱44,722",
                      total: "₱784,093",
                      downPayment: "₱156,819",
                      monthly: {
                        "12 mos": "₱59,312\nTotal: ₱868,563",
                        "36 mos": "₱24,487\nTotal: ₱1,038,711",
                        "60 mos": "₱17,563\nTotal: ₱1,210,599",
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Text(
                    "No data for $selectedCategory yet.",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLotCard({
    required String title,
    required String lotPrice,
    required String care,
    required String total,
    required String downPayment,
    required Map<String, String> monthly,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Prices
            Text("Lot Price: $lotPrice"),
            Text("Perpetual Care: $care"),
            const SizedBox(height: 8),
            Text("Total Price: $total",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text("Down Payment: $downPayment"),

            const SizedBox(height: 12),

            // Monthly Installment
            const Text("Monthly Installment Options:",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: monthly.entries.map((e) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          e.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("View details for $title")),
                  );
                },
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
