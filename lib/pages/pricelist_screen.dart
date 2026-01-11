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
Widget _buildLotCard({
  required String title,
  required String lotPrice,
  required String care,
  required String total,
  required String downPayment,
  required List<Map<String, String>> installments,
  required int categoryIndex, 
   String? imagePath,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: const Color.fromARGB(255, 231, 217, 217).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4))
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
   Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 18),
        
        // ✅ ADD IMAGE if provided
        if (imagePath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Price rows
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Lot Price", style: TextStyle(color: Colors.black)),
          Text(lotPrice, style: const TextStyle(color: Colors.black)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Perpetual Care", style: TextStyle(color: Colors.black)),
          Text(care, style: const TextStyle(color: Colors.black)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Total Price", style: TextStyle(color: Colors.black)),
          Text(total,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Down Payment", style: TextStyle(color: Colors.black)),
          Text(downPayment, style: const TextStyle(color: Colors.black)),
        ]),
        const SizedBox(height: 16),

        // Installments
        const Text("Monthly Installment Options",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
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

        // ✅ "Avail Plan" button with lot type and category
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 77, 90, 124),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      onPressed: () {
  // ✅ Use categoryIndex parameter instead of _selectedCategory
  String lotType = '';
  String lotCategory = '';
  
  if (categoryIndex == 0) {
    // Lawn Area
    lotCategory = 'LAWN AREA (1)';
    lotType = 'Lawn Area (1) - $title';
  } else if (categoryIndex == 1) {
    // Memorial Garden
    lotCategory = 'MEMORIAL GARDEN';
    lotType = 'Memorial Garden - $title';
  } else if (categoryIndex == 2) {
    // Garden Family Estate
    lotCategory = 'GARDEN FAMILY ESTATE';
    lotType = 'Garden Family Estate - $title';
  } else if (categoryIndex == 3) {
    // Family Estate (Mausoleum)
    lotCategory = 'FAMILY ESTATE (Mausoleum)';
    lotType = 'Family Estate - $title';
  }
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreNeedPurchaseScreen(
        title: title,
        totalPrice: total,
        downPayment: downPayment,
        lotType: lotType,
        lotCategory: lotCategory,
      ),
    ),
  );
},
            child: const Text(
              "Avail Plan",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        )
      ]),
    ),
  );
}
  // Category-specific content
  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 0:
        return Column(children: [
          _buildLotCard(
            title: "Prime",
            lotPrice: "₱73,871",
            care: "₱5,590",
            total: "₱79,461",
            downPayment: "₱15,892",
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
            imagePath: 'assets/images/laprime.jpg',
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
            total: "₱76,133",
            downPayment: "₱15,227",
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
               imagePath: 'assets/images/lasp.jpg',
            installments: [
              {"term": "12 mos", "price": "₱5,759", "total": "₱84,335"},
              {"term": "36 mos", "price": "₱2,379", "total": "₱100,871"},
              {"term": "60 mos", "price": "₱1,706", "total": "₱117,587"},
            ],
          ),
          _buildLotCard(
            title: "Premium",
            lotPrice: "₱66,816",
            care: "₱5,590",
            total: "₱72,406",
            downPayment: "₱14,482",
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
               imagePath: 'assets/images/lap.jpg',
            installments: [
              {"term": "12 mos", "price": "₱5,477", "total": "₱80,266"},
              {"term": "36 mos", "price": "₱2,262", "total": "₱95,914"},
              {"term": "60 mos", "price": "₱1,622", "total": "₱111,802"},
            ],
          ),
          _buildLotCard(
            title: "Regular",
            lotPrice: "₱63,888",
            care: "₱5,590",
            total: "₱69,478",
            downPayment: "₱13,896",
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
                 imagePath: 'assets/images/lar.jpg',
            installments: [
              {"term": "12 mos", "price": "₱5,256", "total": "₱76,968"},
              {"term": "36 mos", "price": "₱2,171", "total": "₱92,052"},
              {"term": "60 mos", "price": "₱1,557", "total": "₱107,316"},
            ],
          ),
        ]);

      case 1:
        return Column(children: [
          _buildLotCard(
            title: "Special Premium",
            lotPrice: "₱377,239",
            care: "₱13,076",
            total: "₱391,315",
            downPayment: "₱78,262",
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
              imagePath: 'assets/images/memorialg.jpg',
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
              categoryIndex: _selectedCategory, // ✅ ADD THIS LINE
                imagePath: 'assets/images/mgsp.jpg',
            installments: [
              {"term": "36 mos", "price": "₱8,136", "total": ""},
              {"term": "48 mos", "price": "₱6,518", "total": ""},
              {"term": "60 mos", "price": "₱5,611", "total": ""},
            ],
          ),
          _buildLotCard(
            title: "Regular",
            lotPrice: "₱292,820",
            care: "₱13,976",
            total: "₱306,796",
            downPayment: "₱61,359",
              categoryIndex: _selectedCategory, 
               imagePath: 'assets/images/mgr.jpg',
            installments: [
              {"term": "12 mos", "price": "₱23,208", "total": "₱339,855"},
              {"term": "36 mos", "price": "₱9,585", "total": "₱406,419"},
              {"term": "60 mos", "price": "₱6,872", "total": "₱473,679"},
            ],
          ),
        ]);

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.location_on, color: Color.fromARGB(255, 27, 0, 150)),
                SizedBox(width: 6),
                Text(
                  "Garden Family Estate",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
 categoryIndex: _selectedCategory, 
  imagePath: 'assets/images/gfsp.jpg',
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
               categoryIndex: _selectedCategory, 
                    imagePath: 'assets/images/gfp.jpg',
              installments: [
                {"term": "12 mos", "price": "₱59,312", "total": "₱868,563"},
                {"term": "36 mos", "price": "₱24,487", "total": "₱1,038,711"},
                {"term": "60 mos", "price": "₱17,563", "total": "₱1,210,599"},
              ],
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.location_on, color: Color.fromARGB(255, 0, 45, 150)),
                SizedBox(width: 6),
                Text(
                  "Family Estate",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
               categoryIndex: _selectedCategory, 
               imagePath: 'assets/images/gardenfam.jpg',
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
               categoryIndex: _selectedCategory, 
                 imagePath: 'assets/images/mausoleum.jpg',
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
        backgroundColor: const Color.fromARGB(255, 0, 16, 118),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)), // changed to black
        title: const Text(
          "Price List",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold), // changed
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
                  selectedColor: const Color.fromARGB(255, 0, 22, 121),
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
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
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
