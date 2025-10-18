import 'package:flutter/material.dart';

class PreNeedAgreementScreen extends StatefulWidget {
  const PreNeedAgreementScreen({super.key});

  @override
  State<PreNeedAgreementScreen> createState() => _PreNeedAgreementScreenState();
}

class _PreNeedAgreementScreenState extends State<PreNeedAgreementScreen> {
  String requestType = 'New Request';
  String priority = 'Normal';
  String paymentTerm = 'Monthly';

  final _nameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController(text: '+63 912 345 6789');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _addressController = TextEditingController();
  final _budgetController = TextEditingController(text: '₱500,000');
  final _monthlyController = TextEditingController(text: '₱15,000');
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 212, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        elevation: 0,
        title: const Text(
          'Pre-Need Purchase Agreement Request',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Submit Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request submitted successfully!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'DUMAGUETE MEMORIAL PARK',
              style: TextStyle(
                  color: Color.fromARGB(255, 8, 40, 25),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
            const Text(
              'San Jose Ext., Taclobo, Dumaguete City\nNegros Oriental, Philippines',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromARGB(233, 0, 68, 53), fontSize: 13),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pre-Need Purchase Agreement Request',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Request for pre-need purchase agreement setup',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Divider(height: 20),

                  _sectionTitle('Request Type'),
                  _dropdown(
                    value: requestType,
                    items: const ['New Request', 'Update Request', 'Renewal'],
                    onChanged: (v) => setState(() => requestType = v!),
                  ),

                  _sectionTitle('Priority'),
                  _dropdown(
                    value: priority,
                    items: const ['Normal', 'Urgent'],
                    onChanged: (v) => setState(() => priority = v!),
                  ),

                  const SizedBox(height: 10),
                  _sectionHeader('Customer Information'),
                  _textField('Full Name *', controller: _nameController),
                  _textField('Phone Number *', controller: _phoneController),
                  _textField('Email Address *', controller: _emailController),
                  _textField('Address', controller: _addressController),

                  const SizedBox(height: 10),
                  _sectionHeader('Agreement Details'),
                  _textField('Desired Lot Location',
                      hint: 'Preferred block'),
                  _textField('Budget Range', controller: _budgetController),
                  _dropdown(
                    value: paymentTerm,
                    items: const ['Monthly', 'Quarterly', 'Annually'],
                    onChanged: (v) => setState(() => paymentTerm = v!),
                    label: 'Payment Terms',
                  ),
                  _textField('Preferred Monthly Payment',
                      controller: _monthlyController),

                  const SizedBox(height: 10),
                  _sectionHeader('Additional Notes'),
                  _textField(
                    'Any additional information or special requests...',
                    controller: _notesController,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Legal Notice: This is a digital copy of an official document. '
                      'For legal purposes, please refer to the original signed document. '
                      'This digital version is provided for convenience and reference only.',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 1.4,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      );

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.teal),
        ),
      );

  Widget _textField(String label,
      {TextEditingController? controller, String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}