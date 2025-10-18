import 'package:flutter/material.dart';
import 'deed_of_sale_screen.dart';
import 'pre_need_agreement_screen.dart';
import 'interment_authorization_screen.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contracts & Documents',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ContractDocumentsPage(),
    );
  }
}

class ContractDocumentsPage extends StatefulWidget {
  const ContractDocumentsPage({super.key});

  @override
  State<ContractDocumentsPage> createState() => _ContractDocumentsPageState();
}

class _ContractDocumentsPageState extends State<ContractDocumentsPage> {
  bool showContracts = true;

  static final List<ContractDocument> contractDocs = [
    ContractDocument(
      title: 'Deed of Sale & Certificate of Perpetual Care',
      subtitle: 'Automatically issued upon full payment completion',
      date: 'March 19, 2021',
      status: DocumentStatus.available,
      icon: Icons.description,
    ),
    ContractDocument(
      title: 'Pre-Need Purchase Agreement',
      subtitle: '',
      date: '',
      status: DocumentStatus.available,
      icon: Icons.article_outlined,
    ),
    ContractDocument(
      title: 'Interment Order Form',
      subtitle: '',
      date: '',
      status: DocumentStatus.available,
      icon: Icons.assignment_late_outlined,
    ),
  ];

  static final List<ContractDocument> paymentRecords = [
    ContractDocument(
      title: 'Service Invoice - February',
      subtitle: 'Monthly payment receipt - ₱2,500.00',
      date: 'February 15, 2024',
      status: DocumentStatus.available,
      icon: Icons.receipt_long_outlined,
    ),
    
    ContractDocument(
      title: 'Payment History Summary',
      subtitle: 'Complete payment history and receipts',
      date: 'March 1, 2024',
      status: DocumentStatus.available,
      icon: Icons.history_edu_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<ContractDocument> visibleList =
        showContracts ? contractDocs : paymentRecords;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 213, 209),
      appBar: AppBar(
        title: const Text('Contracts & Documents'),
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => showContracts = true),
                  child: _CategoryChip(
                    label: 'Contracts',
                    selected: showContracts,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => showContracts = false),
                  child: _CategoryChip(
                    label: 'Payment Records',
                    selected: !showContracts,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ListView.builder(
                  key: ValueKey(showContracts),
                  itemCount: visibleList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DocumentCard(document: visibleList[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContractDocument {
  final String title;
  final String subtitle;
  final String date;
  final DocumentStatus status;
  final IconData icon;

  ContractDocument({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.icon,
  });
}

enum DocumentStatus { available, pending, unavailable }

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black87 : const Color.fromARGB(255, 1, 156, 120),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final ContractDocument document;
  const DocumentCard({required this.document, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFEFFAF9), Color(0xFFF7FBFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Icon(document.icon, size: 28, color: const Color(0xFF0F766E)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 6),
                  if (document.subtitle.isNotEmpty)
                    Text(document.subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                  if (document.date.isNotEmpty) const SizedBox(height: 6),
                  if (document.date.isNotEmpty)
                    Text(document.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _onView(context, document),
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _onDownload(context, document),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 149, 197, 193),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: document.status),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onView(BuildContext context, ContractDocument doc) {
    if (doc.title == 'Deed of Sale & Certificate of Perpetual Care') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DeedOfSaleScreen()),
      );
    } else if (doc.title == 'Pre-Need Purchase Agreement') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PreNeedAgreementScreen()),
      );
    } else if (doc.title == 'Interment Order Form') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const IntermentAuthorizationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Viewing: ${doc.title}')),
      );
    }
  }

  void _onDownload(BuildContext context, ContractDocument doc) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Downloading: ${doc.title}')));
  }
}

class _StatusBadge extends StatelessWidget {
  final DocumentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color bg;
    Color textColor;

    switch (status) {
      case DocumentStatus.available:
        text = 'Available';
        bg = const Color(0xFFE6FBF8);
        textColor = const Color(0xFF0F766E);
        break;
      case DocumentStatus.pending:
        text = 'Pending';
        bg = const Color(0xFFFFF4E5);
        textColor = Colors.orange.shade800;
        break;
      case DocumentStatus.unavailable:
        text = 'Unavailable';
        bg = Colors.grey.shade300;
        textColor = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}