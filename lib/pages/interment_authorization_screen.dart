import 'package:flutter/material.dart';

// Remove the main function and IntermentAuthorizationApp class
// Only keep the screen class

class IntermentAuthorizationScreen extends StatefulWidget {
  const IntermentAuthorizationScreen({super.key});

  @override
  State<IntermentAuthorizationScreen> createState() =>
      _IntermentAuthorizationScreenState();
}

class _IntermentAuthorizationScreenState
    extends State<IntermentAuthorizationScreen> {
  final _formKey = GlobalKey<FormState>();

  String requestType = 'New Request';
  String priority = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interment Authorization Request"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      "DUMAGUETE MEMORIAL PARK",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "San Jose Ext., Taclobo, Dumaguete City\nNegros Oriental, Philippines",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Interment Authorization Request",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Request for interment services and authorization",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: requestType,
                items: ['New Request', 'Update', 'Cancel']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: "Request Type",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => requestType = val!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: priority,
                items: ['Normal', 'Urgent']
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => priority = val!),
              ),
              const SizedBox(height: 20),
              const Text("Customer Information",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField("Full Name *"),
              const SizedBox(height: 10),
              _buildTextField("Phone Number *",
                  keyboard: TextInputType.phone),
              const SizedBox(height: 10),
              _buildTextField("Email Address *",
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField("Address"),
              const SizedBox(height: 20),
              const Text("Interment Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField("Name of Deceased *"),
              const SizedBox(height: 10),
              _buildTextField("Interment Date (mm/dd/yyyy)"),
              const SizedBox(height: 10),
              _buildTextField("Interment Time"),
              const SizedBox(height: 10),
              _buildTextField("Lot Information"),
              const SizedBox(height: 10),
              _buildTextField("Special Instructions",
                  maxLines: 3),
              const SizedBox(height: 10),
              _buildTextField("Additional Notes", maxLines: 3),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Submit Request"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Request submitted successfully")),
                        );
                      }
                    },
                  ),
                 
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "Legal Notice: This is a digital copy of an official document. "
                  "For legal purposes, please refer to the original signed document. "
                  "This digital version is provided for convenience and reference only.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          label.contains('*') && (value == null || value.isEmpty)
              ? 'Required field'
              : null,
    );
  }
}