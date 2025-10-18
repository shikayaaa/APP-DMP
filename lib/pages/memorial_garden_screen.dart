import 'package:flutter/material.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    "Lawn Area",
    "Memorial Garden",
    "Garden Family",
    "Family Estate"
  ];

  // 🔑 Data for each category
  final Map<String, List<Map<String, dynamic>>> _categoryLots = {
    "Lawn Area": [
      {
        "title": "Prime",
        "lotPrice": "₱73,871",
        "care": "₱5,590",
        "total": "₱79,461",
        "down": "₱15,892",
        "installments": ["12 mos ₱6,011", "36 mos ₱2,483", "60 mos ₱1,780"],
      },
    ],
    "Memorial Garden": [
      {
        "title": "Special Premium",
        "lotPrice": "₱377,239",
        "care": "₱13,076",
        "total": "₱391,315",
        "down": "₱78,262",
        "installments": [
          "36 mos ₱9,201",
          "48 mos ₱7,364",
          "60 mos ₱6,364"
        ],
      },
      {
        "title": "Premium",
        "lotPrice": "₱332,750",
        "care": "₱13,976",
        "total": "₱346,726",
        "down": "₱69,345",
        "installments": [
          "36 mos ₱8,136",
          "48 mos ₱6,518",
          "60 mos ₱5,611"
        ],
      },
      {
        "title": "Regular",
        "lotPrice": "₱292,820",
        "care": "₱13,976",
        "total": "₱306,796",
        "down": "₱61,359",
        "installments": [
          "36 mos ₱7,000",
          "48 mos ₱5,600",
          "60 mos ₱4,900"
        ],
      },
    ],
    "Garden Family": [
      {
        "title": "Family Lot A",
        "lotPrice": "₱500,000",
        "care": "₱15,000",
        "total": "₱515,000",
        "down": "₱100,000",
        "installments": ["12 mos ₱34,500", "36 mos ₱12,000", "60 mos ₱8,500"],
      }
    ],
    "Family Estate": [
      {
        "title": "Estate Block",
        "lotPrice": "₱1,000,000",
        "care": "₱25,000",
        "total": "₱1,025,000",
        "down": "₱200,000",
        "installments": ["12 mos ₱70,000", "36 mos ₱25,000", "60 mos ₱18,000"],
      }
    ],
  };

  // 🔑 Build reusable lot card
  Widget _buildPriceCard(Map<String, dynamic> lot) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lot["title"],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Lot Price: ${lot["lotPrice"]}"),
            Text("Perpetual Care: ${lot["care"]}"),
            const SizedBox(height: 8),
            Text("Total Price: ${lot["total"]}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            Text("Down Payment: ${lot["down"]}"),
            const SizedBox(height: 10),
            const Text("Monthly Installment Options:",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: (lot["installments"] as List<String>)
                  .map((opt) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(opt),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing ${lot["title"]} details...')),
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

  @override
  Widget build(BuildContext context) {
    final lots = _categoryLots[_categories[_selectedCategory]] ?? [];

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade900,
        title: const Text("Price List"),
      ),
      body: Column(
        children: [
          // 🔑 Category selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategory == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    selectedColor: Colors.teal.shade700,
                    backgroundColor: Colors.grey.shade300,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }),
            ),
          ),

          // 🔑 Show correct lots
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: lots.map((lot) => _buildPriceCard(lot)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
