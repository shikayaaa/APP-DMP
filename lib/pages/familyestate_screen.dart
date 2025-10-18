import 'package:flutter/material.dart';

class FamilyEstateScreen extends StatefulWidget {
  const FamilyEstateScreen({super.key});

  @override
  State<FamilyEstateScreen> createState() => _FamilyEstateScreenState();
}

class _FamilyEstateScreenState extends State<FamilyEstateScreen> {
  String selectedCategory = "Family Estate";

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Price List"),
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

            // Show Family Estate Cards when selected
            if (selectedCategory == "Family Estate") ...[
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.teal),
                  SizedBox(width: 6),
                  Text(
                    "Family Estate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    _buildLotCard(
                      title: "Premier Family Estate",
                      lotPrice: "₱1,888,058",
                      care: "₱39,443",
                      total: "₱1,927,501",
                      downPayment: "₱385,500",
                      monthly: {
                        "12 mos": "₱145,758\nTotal: ₱2,169,096",
                        "36 mos": "₱61,017\nTotal: ₱2,586,612",
                        "60 mos": "₱43,196\nTotal: ₱2,955,876",
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLotCard(
                      title: "Prestige Family Estate",
                      lotPrice: "₱964,030",
                      care: "₱89,443",
                      total: "₱1,053,473",
                      downPayment: "₱210,695",
                      monthly: {
                        "12 mos": "₱79,106\nTotal: ₱1,233,270",
                        "36 mos": "₱33,111\nTotal: ₱1,392,996",
                        "60 mos": "₱23,456\nTotal: ₱1,523,360",
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
