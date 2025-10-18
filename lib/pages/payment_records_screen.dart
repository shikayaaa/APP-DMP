import 'package:flutter/material.dart';
import 'service_invoice_screen.dart'; // ✅ make sure this file exists

class PaymentRecordsPage extends StatelessWidget {
  const PaymentRecordsPage({super.key});

  static final List<PaymentRecord> records = [
    PaymentRecord(
      title: 'Service Invoice - February',
      subtitle: 'Monthly payment receipt - ₱2,500.00',
      date: 'February 15, 2024',
      status: PaymentStatus.available,
      icon: Icons.receipt_long_outlined,
    ),
    PaymentRecord(
      title: 'Payment History Summary',
      subtitle: 'Complete payment history and receipts',
      date: 'March 1, 2024',
      status: PaymentStatus.available,
      icon: Icons.history_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F766E),
      appBar: AppBar(
        title: const Text('Contracts & Documents'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: const [
                _CategoryChip(label: 'Contracts', selected: false),
                SizedBox(width: 8),
                _CategoryChip(label: 'Payment Records', selected: true),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: PaymentCard(record: records[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentRecord {
  final String title;
  final String subtitle;
  final String date;
  final PaymentStatus status;
  final IconData icon;

  PaymentRecord({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.icon,
  });
}

enum PaymentStatus { available, pending, unavailable }

class PaymentCard extends StatelessWidget {
  final PaymentRecord record;
  const PaymentCard({required this.record, super.key});

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
              child: Icon(record.icon, size: 28, color: const Color(0xFF0F766E)),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _onView(context, record),
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _onDownload(context, record),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (record.status == PaymentStatus.pending) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Processing...',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: record.status),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Updated navigation logic
  void _onView(BuildContext context, PaymentRecord record) {
    if (record.title == 'Service Invoice - February' ||
        record.title == 'Payment History Summary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ServiceInvoiceScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No page linked for: ${record.title}')),
      );
    }
  }

  void _onDownload(BuildContext context, PaymentRecord record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading: ${record.title}')),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PaymentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color bg;
    Color textColor;

    switch (status) {
      case PaymentStatus.available:
        text = 'Available';
        bg = const Color(0xFFE6FBF8);
        textColor = const Color(0xFF0F766E);
        break;
      case PaymentStatus.pending:
        text = 'Pending';
        bg = const Color(0xFFFFF4E5);
        textColor = Colors.orange.shade800;
        break;
      case PaymentStatus.unavailable:
        text = 'Unavailable';
        bg = Colors.grey.shade300;
        textColor = Colors.black54;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
