import 'package:flutter/material.dart';
import 'package:dmp/pages/login_screen.dart';


class PriceListModal extends StatelessWidget {
  final String serviceTitle;

  const PriceListModal({super.key, required this.serviceTitle});

  Map<String, dynamic> getServiceData() {
    switch (serviceTitle) {
      case "Lawn Area":
        return _lawnAreaData;
      case "Memorial Garden":
        return _memorialGardenData;
      case "Garden Family Estate":
        return _gardenFamilyEstateData;
      case "Family Estate (Mausoleum)":
        return _mausoleumData;
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = getServiceData();
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1024;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // ✅ HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                color: Color(0xFF009688),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? serviceTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Pre-Need Installment Price List",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        const Text(
                          "Effective July 1, 2020",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ✅ MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ IMAGES
                    if (serviceTitle == "Lawn Area")
                      _buildImage(context, "assets/images/lawn.jpg"),
                    if (serviceTitle == "Memorial Garden")
                      _buildImage(context, "assets/images/memorialg.jpg"),
                    if (serviceTitle == "Garden Family Estate")
                      _buildImage(context, "assets/images/gardenfam.jpg"),
                    if (serviceTitle == "Family Estate (Mausoleum)")
                      _buildImage(context, "assets/images/mausoleum.jpg"),

                    const SizedBox(height: 24),

                    // ✅ RESPONSIVE LAYOUT
                    isMobile
                        ? _buildCardList(
                            (data['columns'] as List<String>?) ?? [],
                            (data['rows'] as List<List<String>>?) ?? [],
                          )
                        : _buildTable(
                            (data['columns'] as List<String>?) ?? [],
                            (data['rows'] as List<List<String>>?) ?? [],
                          ),

                    const SizedBox(height: 24),

                    if (data['notes'] != null) _buildNotes(data['notes']),

                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "For more information or to schedule a visit, please contact us",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(child: _buildContactButton(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- IMAGE -------------------
  Widget _buildImage(BuildContext context, String path) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.55,
          height: 350,
        ),
      ),
    );
  }

  // ------------------- TABLE (DESKTOP) -------------------
  Widget _buildTable(List<String> columns, List<List<String>> rows) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey.shade300),
        ),
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
          4: FlexColumnWidth(1.8),
          5: FlexColumnWidth(1.8),
          6: FlexColumnWidth(1.8),
          7: FlexColumnWidth(1.8),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
            children: columns
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      c,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          for (var i = 0; i < rows.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color:
                    i.isEven ? Colors.white : const Color.fromARGB(255, 249, 249, 249),
              ),
              children: rows[i]
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        cell,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ------------------- CARD LIST (MOBILE) -------------------
  Widget _buildCardList(List<String> columns, List<List<String>> rows) {
    return Column(
      children: rows.map((row) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFE0F2F1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF009688), Color(0xFF4DB6AC)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    row[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // PRICE GRID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceItem("Lot Price", row[1]),
                    _buildPriceItem("Perpetual Care", row[2]),
                  ],
                ),
                const Divider(),
                _buildPriceHighlight("Total", row[3], Colors.teal.shade700),
                _buildPriceHighlight("20% Down Payment", row[4], Colors.orange.shade700),

                const SizedBox(height: 8),
                const Text(
                  "Installment Plans:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),

                _buildPaymentPlan("12 Months", row[5], Colors.blue),
                _buildPaymentPlan("36 Months", row[6], Colors.purple),
                _buildPaymentPlan("60 Months", row[7], Colors.green),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildPriceHighlight(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPaymentPlan(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          Text(value,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 13)),
        ],
      ),
    );
  }

  // ------------------- NOTES -------------------
  Widget _buildNotes(List<String> notes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 61, 59),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Note:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ...notes.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ",
                      style:
                          TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  Expanded(
                      child: Text(n,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.white70))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- CONTACT BUTTON -------------------
  Widget _buildContactButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
  Navigator.pop(context); // close the modal first
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
},

      icon: const Icon(Icons.calendar_today, size: 18, color: Colors.white),
      label: const Text("Plan Ahead"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF009688),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

// ------------------- PRICE DATA -------------------
final Map<String, dynamic> _lawnAreaData = {
  'title': "Lawn Area",
  'columns': [
    "Description and Name of Lots",
    "Lot Price",
    "Perpetual Care",
    "Total",
    "20% Down Payment",
    "12 Months",
    "36 Months",
    "60 Months"
  ],
  'rows': [
    ["Prime(2)", "₱73,871", "₱5,590", "₱79,461", "₱15,892", "₱6,011", "₱2,483", "₱1,780"],
    ["Special Premium(3)", "₱70,543", "₱5,590", "₱76,133", "₱15,227", "₱5,759", "₱2,379", "₱1,706"],
    ["Premium(4)", "₱66,816", "₱5,590", "₱72,406", "₱14,482", "₱5,477", "₱2,262", "₱1,622"],
    ["Regular", "₱63,888", "₱5,590", "₱69,478", "₱13,896", "₱5,256", "₱2,171", "₱1,557"],
  ],
  'notes': [
    "(1) All Lawn lots are sold as Double Tiered.",
    "(2) Special Premium lots are those situated in Garden Areas."
  ],
};

final Map<String, dynamic> _memorialGardenData = {
  'title': "Memorial Garden",
  'columns': _lawnAreaData['columns'],
  'rows': _lawnAreaData['rows'],
  'notes': [
    "(1) All Lawn lots are sold as Double Tiered.",
    "(2) Special Premium lots are those situated in Garden Areas.",
    "(3) Prices do not include cost of interment fees and markers."
  ],
};

final Map<String, dynamic> _gardenFamilyEstateData = {
  'title': "Garden Family Estate",
  'columns': _lawnAreaData['columns'],
  'rows': _lawnAreaData['rows'],
  'notes': [
    "(1) Family Estates are available in different configurations.",
    "(2) Prices depend on garden and location."
  ],
};

final Map<String, dynamic> _mausoleumData = {
  'title': "Family Estate (Mausoleum)",
  'columns': _lawnAreaData['columns'],
  'rows': [
    [
      "Premier Family Estate",
      "₱1,838,058",
      "₱89,443",
      "₱1,927,501",
      "₱385,500",
      "₱145,805",
      "₱60,218",
      "₱43,174"
    ],
    [
      "Prestige Family Estate",
      "₱964,030",
      "₱89,443",
      "₱1,053,473",
      "₱210,695",
      "₱79,690",
      "₱32,912",
      "₱23,597"
    ],
  ],
  'notes': [
    "(1) All Lawn lots are sold as Double Tiered.",
    "(2) Special Premium lots are those situated in Garden Areas.",
    "(3) Special Premium lots are those situated along or beside the road.",
    "(4) Premium Lawn and Memorial Areas are those nearest a road, walkway, tree, or embellishment.",
    "(5) Premium Family Estate are lots along walkways.",
  ],
};
