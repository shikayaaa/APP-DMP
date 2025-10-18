import 'package:flutter/material.dart';

class ServiceInvoiceScreen extends StatelessWidget {
  const ServiceInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Invoice - February'),
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
      ),
      body: const Center(
        child: Text(
          'Service Invoice Details\n(February 2024)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
