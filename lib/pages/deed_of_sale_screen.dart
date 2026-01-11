import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';



class DeedOfSaleScreen extends StatefulWidget {
  const DeedOfSaleScreen({super.key});

  @override
  State<DeedOfSaleScreen> createState() => _DeedOfSaleScreenState();
}

class _DeedOfSaleScreenState extends State<DeedOfSaleScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _contractData;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContractData();
  }

  Future<void> _loadContractData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        setState(() {
          _errorMessage = 'Please log in to view your contract';
          _isLoading = false;
        });
        return;
      }

      // Get user data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Get contract data
      final contractQuery = await FirebaseFirestore.instance
          .collection('preNeedAgreements')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (contractQuery.docs.isEmpty) {
        setState(() {
          _errorMessage = 'No active contract found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _userData = userDoc.data();
        _contractData = contractQuery.docs.first.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading contract: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
String _formatCurrency(dynamic value) {
  if (value is num) {
    return value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  if (value is String) {
    final numValue = double.tryParse(value.replaceAll(RegExp(r'[₱,\s]'), ''));
    if (numValue != null) {
      return numValue.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
  }

  return '0.00';
}


  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 135, 177, 231),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 10, 35, 172),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Deed of Sale & Perpetual Care',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 135, 177, 231),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 10, 35, 172),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Deed of Sale & Perpetual Care',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Extract data with fallbacks
    final userName = _userData?['displayName'] ?? 
                     _userData?['fullName'] ?? 
                     _contractData?['client'] ?? 
                     'N/A';
    
    final userAddress = _userData?['address'] ?? 
                        _contractData?['address'] ?? 
                        'N/A';
    
    final userPhone = _userData?['phoneNumber'] ?? 
                      _contractData?['contact'] ?? 
                      'N/A';
    
    final userEmail = _userData?['email'] ?? 
                      _contractData?['email'] ?? 
                      'N/A';

    final lotCategory = _contractData?['lotCategory'] ?? 
                        _contractData?['location'] ?? 
                        'Garden Family Estate';
    
    final lotNumber = _contractData?['lotNumber'] ?? 
                      _contractData?['lot'] ?? 
                      'N/A';
    
    final lotSize = _contractData?['lotSize'] ?? '2m x 1m';

    final totalPrice = _contractData?['totalCost'] ?? 
                       _contractData?['totalAmount'] ?? 
                       0;
    
    final downPayment = _contractData?['initialPayment'] ?? 
                        _contractData?['downPayment'] ?? 
                        0;
    
    final monthlyPayment = _contractData?['monthlyPayment'] ?? 0;
    final paymentTerm = _contractData?['paymentTerm'] ?? '12 months';
    final remainingBalance = _contractData?['remainingBalance'] ?? 
                            (totalPrice - downPayment);

    final contractDate = _contractData?['startDate'] ?? _getCurrentDate();
    final contractId = _contractData?['contractId'] ?? 'N/A';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 177, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 35, 172),
        elevation: 0,
        title: const Text(
          'Deed of Sale & Perpetual Care',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lotCategory,
              style: const TextStyle(
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
                  Text(
                    'Contract ID: $contractId',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(thickness: 1, height: 20),

                  _sectionTitle('PURCHASER INFORMATION'),
                  _infoBlock({
                    'Name': userName,
                    'Address': userAddress,
                    'Contact': userPhone,
                    'Email': userEmail,
                  }),

                  const SizedBox(height: 12),
                  _sectionTitle('LOT DETAILS'),
                  _infoBlock({
                    'Section': lotCategory,
                    'Lot Number': lotNumber,
                    'Area': lotSize,
                  }),

                  const SizedBox(height: 12),
                  _sectionTitle('FINANCIAL DETAILS'),
                  _infoBlock({
                    'Total Contract Price': _formatCurrency(totalPrice),
                    'Down Payment': _formatCurrency(downPayment),
                    'Balance': _formatCurrency(remainingBalance),
                    'Monthly Installment': _formatCurrency(monthlyPayment),
                    'Term': paymentTerm,
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
                    children: [
                      _SignatureColumn(
                        title: 'PURCHASER SIGNATURE',
                        name: userName,
                      ),
                      const _SignatureColumn(
                        title: 'AUTHORIZED REPRESENTATIVE',
                        name: 'Dumaguete Memorial Park',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $contractDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ WORKS ON BOTH WEB AND ANDROID
  Future<void> _generateAndSavePdf(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      // Extract data
      final userName = _userData?['displayName'] ?? 
                       _userData?['fullName'] ?? 
                       _contractData?['client'] ?? 
                       'N/A';
      final userAddress = _userData?['address'] ?? _contractData?['address'] ?? 'N/A';
      final userPhone = _userData?['phoneNumber'] ?? _contractData?['contact'] ?? 'N/A';
      final userEmail = _userData?['email'] ?? _contractData?['email'] ?? 'N/A';
      final lotCategory = _contractData?['lotCategory'] ?? _contractData?['location'] ?? 'Garden Family Estate';
      final lotNumber = _contractData?['lotNumber'] ?? _contractData?['lot'] ?? 'N/A';
      final lotSize = _contractData?['lotSize'] ?? '2m x 1m';
      final totalPrice = _contractData?['totalCost'] ?? _contractData?['totalAmount'] ?? 0;
      final downPayment = _contractData?['initialPayment'] ?? _contractData?['downPayment'] ?? 0;
      final monthlyPayment = _contractData?['monthlyPayment'] ?? 0;
      final paymentTerm = _contractData?['paymentTerm'] ?? '12 months';
      final remainingBalance = _contractData?['remainingBalance'] ?? (totalPrice - downPayment);
      final contractDate = _contractData?['startDate'] ?? _getCurrentDate();
      final contractId = _contractData?['contractId'] ?? 'N/A';

      // Create PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('DUMAGUETE MEMORIAL PARK',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('San Jose Ext., Taclobo, Dumaguete City, Negros Oriental'),
                  pw.SizedBox(height: 10),
                  pw.Text('DEED OF SALE & PERPETUAL CARE',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Contract ID: $contractId', style: const pw.TextStyle(fontSize: 10)),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text('PURCHASER INFORMATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  _pdfInfoBlock({'Name': userName, 'Address': userAddress, 'Contact': userPhone, 'Email': userEmail}),
                  pw.SizedBox(height: 10),
                  pw.Text('LOT DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  _pdfInfoBlock({'Section': lotCategory, 'Lot Number': lotNumber, 'Area': lotSize}),
                  pw.SizedBox(height: 10),
                  pw.Text('FINANCIAL DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  _pdfInfoBlock({
                    'Total Contract Price': _formatCurrency(totalPrice),
                    'Down Payment': _formatCurrency(downPayment),
                    'Balance': _formatCurrency(remainingBalance),
                    'Monthly Installment': _formatCurrency(monthlyPayment),
                    'Term': paymentTerm,
                  }),
                  pw.SizedBox(height: 10),
                  pw.Text('TERMS AND CONDITIONS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    '1. This deed serves as proof of ownership upon full payment.\n'
                    '2. Purchaser agrees to pay balance in monthly installments.\n'
                    '3. Perpetual care includes maintenance and security.\n'
                    '4. Transfer requires approval and fees.\n'
                    '5. Governed by Philippine laws.',
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text('PURCHASER SIGNATURE', style: const pw.TextStyle(fontSize: 11)),
                        pw.SizedBox(height: 5),
                        pw.Text(userName, style: const pw.TextStyle(fontSize: 11)),
                      ]),
                      pw.Column(children: [
                        pw.Text('AUTHORIZED REPRESENTATIVE', style: const pw.TextStyle(fontSize: 11)),
                        pw.SizedBox(height: 5),
                        pw.Text('Dumaguete Memorial Park', style: const pw.TextStyle(fontSize: 11)),
                      ]),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Date: $contractDate', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      );

      final fileName = 'Deed_of_Sale_$contractId.pdf';
      final bytes = await pdf.save();

 {
        // ANDROID: Save to Downloads folder
        await Permission.storage.request();
        
        Directory? directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }

        final file = File('${directory!.path}/$fileName');
        await file.writeAsBytes(bytes);

        if (mounted) {
          Navigator.pop(context);
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success!'),
              content: Text('PDF saved to:\n${directory!.path}/$fileName'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

 pw.Widget _pdfInfoBlock(Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: data.entries
          .map((e) => pw.Text('${e.key}: ${e.value}',
              style: const pw.TextStyle(fontSize: 11)))
          .toList(),
    );
  }

 Widget _sectionTitle(String title) {
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

Widget _infoBlock(Map<String, String> data) {
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