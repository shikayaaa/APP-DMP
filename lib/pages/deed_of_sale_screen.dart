import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';



class DeedOfSaleScreen extends StatelessWidget {
  const DeedOfSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 211, 204),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        elevation: 0,
        title: const Text(
          'Deed of Sale & Perpetual Care',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              await _generateAndSavePdf(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Garden Family Estate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'DUMAGUETE MEMORIAL PARK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'San Jose Ext., Taclobo, Dumaguete City\nNegros Oriental, Philippines',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DEED OF SALE & PERPETUAL CARE',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Divider(thickness: 1, height: 20),

                  _sectionTitle('PURCHASER INFORMATION'),
                  _infoBlock({
                    'Name': 'Juan Carlos Dela Cruz',
                    'Address': '123 Rizal Boulevard, Dumaguete City',
                    'Contact': '0965-743-2479',
                    'Email': 'juan.delacruz@gmail.com',
                  }),

                  const SizedBox(height: 12),
                  _sectionTitle('LOT DETAILS'),
                  _infoBlock({
                    'Section': 'Garden Family Estate',
                    'Block': 'B',
                    'Lot Number': '12',
                    'Area': '6 square meters',
                  }),

                  const SizedBox(height: 12),
                  _sectionTitle('FINANCIAL DETAILS'),
                  _infoBlock({
                    'Total Contract Price': '₱75,000.00',
                    'Down Payment': '₱15,000.00',
                    'Balance': '₱60,000.00',
                    'Monthly Installment': '₱2,500.00',
                    'Term': '24 months',
                    'Perpetual Care Fee': '₱5,000.00',
                  }),

                  const SizedBox(height: 12),
                  _sectionTitle('TERMS AND CONDITIONS'),
                  const SizedBox(height: 6),
                  const Text(
                    '1. This deed serves as proof of ownership of the memorial lot described above upon full payment of the contract price.\n\n'
                    '2. The purchaser agrees to pay the balance in monthly installments as specified above.\n\n'
                    '3. Perpetual care includes general maintenance, landscaping, and security of the memorial grounds.\n\n'
                    '4. Transfer of ownership is subject to approval and payment of applicable fees.\n\n'
                    '5. This contract is governed by the laws of the Republic of the Philippines.',
                    style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                  ),

                  const Divider(thickness: 1, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SignatureColumn(
                        title: 'PURCHASER SIGNATURE',
                        name: 'Juan Carlos Dela Cruz',
                      ),
                      _SignatureColumn(
                        title: 'AUTHORIZED REPRESENTATIVE',
                        name: 'Dumaguete Memorial Park',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Date: January 15, 2024',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔽 Function to actually create and save PDF
  Future<void> _generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text('DUMAGUETE MEMORIAL PARK',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('San Jose Ext., Taclobo, Dumaguete City, Negros Oriental'),
                pw.SizedBox(height: 10),
                pw.Text('DEED OF SALE & PERPETUAL CARE',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.SizedBox(height: 10),

                pw.Text('PURCHASER INFORMATION',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                _pdfInfoBlock({
                  'Name': 'Juan Carlos Dela Cruz',
                  'Address': '123 Rizal Boulevard, Dumaguete City',
                  'Contact': '0965-743-2479',
                  'Email': 'juan.delacruz@gmail.com',
                }),
                pw.SizedBox(height: 10),

                pw.Text('LOT DETAILS',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                _pdfInfoBlock({
                  'Section': 'Garden Family Estate',
                  'Block': 'B',
                  'Lot Number': '12',
                  'Area': '6 square meters',
                }),
                pw.SizedBox(height: 10),

                pw.Text('FINANCIAL DETAILS',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                _pdfInfoBlock({
                  'Total Contract Price': '₱75,000.00',
                  'Down Payment': '₱15,000.00',
                  'Balance': '₱60,000.00',
                  'Monthly Installment': '₱2,500.00',
                  'Term': '24 months',
                  'Perpetual Care Fee': '₱5,000.00',
                }),
                pw.SizedBox(height: 10),

                pw.Text('TERMS AND CONDITIONS',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  '1. This deed serves as proof of ownership of the memorial lot described above upon full payment.\n'
                  '2. The purchaser agrees to pay the balance in monthly installments.\n'
                  '3. Perpetual care includes maintenance and security of the grounds.\n'
                  '4. Transfer of ownership requires approval and applicable fees.\n'
                  '5. Governed by the laws of the Republic of the Philippines.',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.SizedBox(height: 20),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text('PURCHASER SIGNATURE',
                          style: const pw.TextStyle(fontSize: 11)),
                      pw.Text('Juan Carlos Dela Cruz',
                          style: const pw.TextStyle(fontSize: 11)),
                    ]),
                    pw.Column(children: [
                      pw.Text('AUTHORIZED REPRESENTATIVE',
                          style: const pw.TextStyle(fontSize: 11)),
                      pw.Text('Dumaguete Memorial Park',
                          style: const pw.TextStyle(fontSize: 11)),
                    ]),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text('Date: January 15, 2024',
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Deed_of_Sale.pdf');
    await file.writeAsBytes(await pdf.save());

    // Confirm download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF downloaded to: ${file.path}')),
    );
  }

  static pw.Widget _pdfInfoBlock(Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: data.entries
          .map((e) => pw.Text('${e.key}: ${e.value}',
              style: const pw.TextStyle(fontSize: 11)))
          .toList(),
    );
  }

  static Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  static Widget _infoBlock(Map<String, String> data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: RichText(
                    text: TextSpan(
                      text: '${e.key}: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 13),
                      children: [
                        TextSpan(
                          text: e.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _SignatureColumn extends StatelessWidget {
  final String title;
  final String name;
  const _SignatureColumn({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
