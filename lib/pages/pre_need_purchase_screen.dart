import 'package:flutter/material.dart';

class PreNeedPurchaseScreen extends StatefulWidget {
  final String title;
  final String totalPrice;
  final String downPayment;

  const PreNeedPurchaseScreen({
    super.key,
    required this.title,
    required this.totalPrice,
    required this.downPayment,
  });

  @override
  State<PreNeedPurchaseScreen> createState() => _PreNeedPurchaseScreenState();
}

class _PreNeedPurchaseScreenState extends State<PreNeedPurchaseScreen> {
  // Checkbox states
  bool _agreedToTerms = false;
  bool _consentedToData = false;
  bool _confirmedInformation = false;

  // Form field controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _beneficiaryPhoneController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();

  // Dropdown values
  String? _civilStatus;
  String? _paymentTerm;
  String? _paymentMethod;
  String? _relationship;

  bool get _allChecked =>
      _agreedToTerms && _consentedToData && _confirmedInformation;

  @override
  void dispose() {
    // Dispose all controllers
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    _occupationController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _zipCodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _beneficiaryNameController.dispose();
    _beneficiaryPhoneController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  void _saveFormData() {
    // Collect all form data
    final formData = {
      'planTitle': widget.title,
      'totalPrice': widget.totalPrice,
      'downPayment': widget.downPayment,
      'fullName': _fullNameController.text,
      'dateOfBirth': _dateOfBirthController.text,
      'civilStatus': _civilStatus ?? '',
      'occupation': _occupationController.text,
      'nationality': _nationalityController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'province': _provinceController.text,
      'zipCode': _zipCodeController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'emergencyContact': _emergencyContactController.text,
      'emergencyPhone': _emergencyPhoneController.text,
      'paymentTerm': _paymentTerm ?? '',
      'paymentMethod': _paymentMethod ?? '',
      'beneficiaryName': _beneficiaryNameController.text,
      'relationship': _relationship ?? '',
      'beneficiaryPhone': _beneficiaryPhoneController.text,
      'specialInstructions': _specialInstructionsController.text,
      'agreedToTerms': _agreedToTerms,
      'consentedToData': _consentedToData,
      'confirmedInformation': _confirmedInformation,
      'submittedAt': DateTime.now().toString(),
    };

    // Print the data (for debugging)
    debugPrint('Form Data Saved: $formData');

    // Here you can:
    // 1. Save to local database (SQLite, Hive, etc.)
    // 2. Send to backend API
    // 3. Save to shared preferences
    // 4. Save to a file
    // Example: await saveToDatabase(formData);
    // Example: await sendToAPI(formData);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pre-Need Agreement Saved Successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to home screen after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 186, 153),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Pre-Need Purchase Agreement",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Plan
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Total Price: ${widget.totalPrice}"),
                  Text("Down Payment (20%): ${widget.downPayment}"),
                ],
              ),
            ),

            // Personal Information
            _buildCard(
              title: "Personal Information",
              child: Column(
                children: [
                  _buildTextField("Full Name *", _fullNameController),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Date of Birth", _dateOfBirthController)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDropdown("Civil Status")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Occupation", _occupationController)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField("Nationality", _nationalityController)),
                    ],
                  ),
                ],
              ),
            ),

            // Contact Information
            _buildCard(
              title: "Contact Information",
              child: Column(
                children: [
                  _buildTextField("Complete Address *", _addressController),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("City", _cityController)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField("Province", _provinceController)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField("Zip Code", _zipCodeController)),
                    ],
                  ),
                  _buildTextField("Email Address *", _emailController),
                  _buildTextField("Phone Number *", _phoneController),
                  _buildTextField("Emergency Contact", _emergencyContactController),
                  _buildTextField("Emergency Phone", _emergencyPhoneController),
                ],
              ),
            ),

            // Payment Information
            _buildCard(
              title: "Payment Information",
              child: Column(
                children: [
                  _buildDropdown("Payment Term"),
                  _buildDropdown("Initial Payment Method"),
                ],
              ),
            ),

            // Beneficiary Information
            _buildCard(
              title: "Beneficiary Information",
              child: Column(
                children: [
                  _buildTextField("Beneficiary Name", _beneficiaryNameController),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown("Relationship")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField("Beneficiary Phone", _beneficiaryPhoneController)),
                    ],
                  ),
                ],
              ),
            ),

            // Additional Information
            _buildCard(
              title: "Additional Information",
              child: _buildTextField("Special Instructions", _specialInstructionsController),
            ),

            // Terms and Conditions
            _buildCard(
              title: "Terms and Conditions",
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    title: const Text(
                        "I have read and agree to the Terms and Conditions"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: _consentedToData,
                    onChanged: (value) {
                      setState(() {
                        _consentedToData = value ?? false;
                      });
                    },
                    title: const Text(
                        "I consent to the collection and processing of my personal data"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: _confirmedInformation,
                    onChanged: (value) {
                      setState(() {
                        _confirmedInformation = value ?? false;
                      });
                    },
                    title: const Text(
                        "I confirm that all information provided is true"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  // "Done" button that appears when all checkboxes are checked
                  if (_allChecked) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _saveFormData,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 29, 98, 89),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            const SizedBox(height: 20),
            const Text(
              "By submitting this form, you are entering into a binding agreement with Dumaguete Memorial Park. You will be redirected to complete your initial payment.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const Divider(),
            ],
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    List<String> items = [];

    if (hint == "Civil Status") {
      items = ["Single", "Married", "Widowed", "Divorced"];
    } else if (hint == "Payment Term") {
      items = ["12 months - ₱ 6,011", "36 months - ₱2,483", "60 months - ₱1,780"];
    } else if (hint == "Initial Payment Method") {
      items = ["GCash", "PayMaya", "Bank Transfer"];
    } else if (hint == "Relationship") {
      items = ["Spouse", "Child", "Sibling", "Parent", "Relative", "Friend"];
    } else {
      items = ["Option 1", "Option 2"];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            if (hint == "Civil Status") {
              _civilStatus = value;
            } else if (hint == "Payment Term") {
              _paymentTerm = value;
            } else if (hint == "Initial Payment Method") {
              _paymentMethod = value;
            } else if (hint == "Relationship") {
              _relationship = value;
            }
          });
          debugPrint("Selected $hint: $value");
        },
      ),
    );
  }
}