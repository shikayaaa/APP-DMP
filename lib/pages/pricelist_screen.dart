import 'package:flutter/material.dart';
import 'pre_need_purchase_screen.dart';


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

  // Reusable Lot Card
  Widget _buildLotCard({
    required String title,
    required String lotPrice,
    required String care,
    required String total,
    required String downPayment,
    required List<Map<String, String>> installments,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Price rows
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Lot Price"),
            Text(lotPrice),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Perpetual Care"),
            Text(care),
          ]),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Total Price"),
            Text(total,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.teal)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Down Payment"),
            Text(downPayment),
          ]),
          const SizedBox(height: 16),

          // Installments
          const Text("Monthly Installment Options",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: installments
                .map((opt) => _InstallmentBox(
                      term: opt["term"]!,
                      price: opt["price"]!,
                      total: opt["total"]!,
                    ))
                .toList(),
          ),

          const SizedBox(height: 16),

          // ✅ Fixed "View Details" button with navigation
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade800,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreNeedPurchaseScreen(
                      title: title,
                      totalPrice: total,
                      downPayment: downPayment,
                    ),
                  ),
                );
              },
              child: const Text(
                "View Details",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]),
      ),
    );
  }

  // Content per category
  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 0: // Lawn Area
        return Column(children: [
          _buildLotCard(
            title: "Prime",
            lotPrice: "₱73,871",
            care: "₱5,590",
            total: "₱79,461",
            downPayment: "₱15,892",
            installments: [
              {"term": "12 mos", "price": "₱6,011", "total": "₱88,024"},
              {"term": "36 mos", "price": "₱2,483", "total": "₱105,280"},
              {"term": "60 mos", "price": "₱1,780", "total": "₱122,692"},
            ],
          ),
          _buildLotCard(
            title: "Special Premium",
            lotPrice: "₱76,543",
            care: "₱5,590",
            total: "₱82,133",
            downPayment: "₱15,227",
            installments: [
              {"term": "12 mos", "price": "₱5,759", "total": "₱84,335"},
              {"term": "36 mos", "price": "₱2,379", "total": "₱100,671"},
              {"term": "60 mos", "price": "₱1,706", "total": "₱117,567"},
            ],
          ),
        ]);

      case 1: // Memorial Garden
        return Column(children: [
          _buildLotCard(
            title: "Special Premium",
            lotPrice: "₱377,239",
            care: "₱13,076",
            total: "₱391,315",
            downPayment: "₱78,262",
            installments: [
              {"term": "36 mos", "price": "₱9,201", "total": ""},
              {"term": "48 mos", "price": "₱7,364", "total": ""},
              {"term": "60 mos", "price": "₱6,364", "total": ""},
            ],
          ),
          _buildLotCard(
            title: "Premium",
            lotPrice: "₱332,750",
            care: "₱13,976",
            total: "₱346,726",
            downPayment: "₱69,345",
            installments: [
              {"term": "36 mos", "price": "₱8,136", "total": ""},
              {"term": "48 mos", "price": "₱6,518", "total": ""},
              {"term": "60 mos", "price": "₱5,611", "total": ""},
            ],
          ),
        ]);

      case 2: // Garden Family
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
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

            _buildLotCard(
              title: "Special Premium",
              lotPrice: "₱806,586",
              care: "₱44,722",
              total: "₱851,308",
              downPayment: "₱170,262",
              installments: [
                {"term": "12 mos", "price": "₱64,397", "total": "₱943,026"},
                {"term": "36 mos", "price": "₱26,957", "total": "₱1,127,574"},
                {"term": "60 mos", "price": "₱19,069", "total": "₱1,314,402"},
              ],
            ),
            _buildLotCard(
              title: "Premium",
              lotPrice: "₱739,371",
              care: "₱44,722",
              total: "₱784,093",
              downPayment: "₱156,819",
              installments: [
                {"term": "12 mos", "price": "₱59,312", "total": "₱868,563"},
                {"term": "36 mos", "price": "₱24,487", "total": "₱1,038,711"},
                {"term": "60 mos", "price": "₱17,563", "total": "₱1,210,599"},
              ],
            ),
          ],
        );

      case 3: // Family Estate
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
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

            _buildLotCard(
              title: "Premier Family Estate",
              lotPrice: "₱1,888,058",
              care: "₱39,443",
              total: "₱1,927,501",
              downPayment: "₱385,500",
              installments: [
                {"term": "12 mos", "price": "₱145,758", "total": "₱2,169,096"},
                {"term": "36 mos", "price": "₱61,017", "total": "₱2,586,612"},
                {"term": "60 mos", "price": "₱43,196", "total": "₱2,955,876"},
              ],
            ),
            _buildLotCard(
              title: "Prestige Family Estate",
              lotPrice: "₱964,030",
              care: "₱89,443",
              total: "₱1,053,473",
              downPayment: "₱210,695",
              installments: [
                {"term": "12 mos", "price": "₱79,106", "total": "₱1,233,270"},
                {"term": "36 mos", "price": "₱33,111", "total": "₱1,392,996"},
                {"term": "60 mos", "price": "₱23,456", "total": "₱1,523,360"},
              ],
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
    appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 18, 186, 153),
  iconTheme: const IconThemeData(
    color: Colors.white, // 👈 changes the back arrow color
  ),
  title: const Text(
    "Price List",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),


      body: Column(children: [
        // Category Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                      color: isSelected ? Colors.white : Colors.black87),
                ),
              );
            }),
          ),
        ),

        // Scrollable List
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildCategoryContent(),
          ),
        ),
      ]),
    );
  }
}

// Reusable Installment Box
class _InstallmentBox extends StatelessWidget {
  final String term;
  final String price;
  final String total;

  const _InstallmentBox(
      {required this.term, required this.price, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          Text(term,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(price, style: const TextStyle(color: Colors.teal)),
          if (total.isNotEmpty)
            Text("Total:\n$total",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }
}
