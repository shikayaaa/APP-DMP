import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _agreedToTerms = false;
  bool _consentedToData = false;
  bool _confirmedInformation = false;
  bool _isLoading = false;

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

  String? _civilStatus;
  String? _paymentTerm;
  String? _paymentMethod;
  String? _relationship;

  bool get _allChecked =>
      _agreedToTerms && _consentedToData && _confirmedInformation;

  @override
  void dispose() {
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

  // Helper function to extract lot size from package name
  String _getLotSize(String packageName) {
    if (packageName.contains('Lawn')) {
      return '2x2m';
    } else if (packageName.contains('Memorial Garden')) {
      return '3x3m';
    } else if (packageName.contains('Garden Family Estate')) {
      return '4x4m';
    } else if (packageName.contains('Premier')) {
      return '5x5m';
    } else if (packageName.contains('Prestige')) {
      return '4x5m';
    }
    return '2x2m'; // Default
  }

  // Parse monthly payment string to number
  double _parseMonthlyPayment(String paymentString) {
    return double.tryParse(paymentString.replaceAll(RegExp(r'[₱,\s]'), '')) ?? 0.0;
  }

  // Calculate end date
  String _getEndDate(String startDateStr, int months) {
    final start = DateTime.now();
    final end = DateTime(start.year, start.month + months, start.day);
    return '${_getMonthName(end.month)} ${end.day}, ${end.year}';
  }

  // Parse total price to get numeric value
  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[₱,\s]'), '')) ?? 0.0;
  }

  // Calculate remaining balance
  double _calculateRemainingBalance(double totalPrice, double downPayment) {
    return totalPrice - downPayment;
  }

  // Calculate monthly payment based on term
  String _calculateMonthlyPayment() {
    if (_paymentTerm == null) return '₱0';
    
    if (_paymentTerm!.contains('12 months')) {
      return '₱6,011';
    } else if (_paymentTerm!.contains('36 months')) {
      return '₱2,483';
    } else if (_paymentTerm!.contains('60 months')) {
      return '₱1,780';
    }
    return '₱0';
  }

  // Get payment term in months
  int _getPaymentTermMonths() {
    if (_paymentTerm == null) return 12;
    
    if (_paymentTerm!.contains('12 months')) return 12;
    if (_paymentTerm!.contains('36 months')) return 36;
    if (_paymentTerm!.contains('60 months')) return 60;
    return 12;
  }

  // Calculate next payment date (1 month from now)
  String _getNextPaymentDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    return '${_getMonthName(nextMonth.month)} ${nextMonth.day}, ${nextMonth.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> _saveFormData() async {
    // Validate required fields
    if (_fullNameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter your complete address');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email address');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    if (_paymentTerm == null) {
      _showError('Please select a payment term');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        _showError('You must be logged in to submit this form');
        setState(() => _isLoading = false);
        return;
      }

      // Calculate values
      final totalPrice = _parseCurrency(widget.totalPrice);
      final downPaymentAmount = _parseCurrency(widget.downPayment);
      final remainingBalance = _calculateRemainingBalance(totalPrice, downPaymentAmount);
      final now = DateTime.now();
      final startDate = '${_getMonthName(now.month)} ${now.day}, ${now.year}';

      // Calculate contract ID
      final existingPlans = await FirebaseFirestore.instance
          .collection('preNeedAgreements')
          .get();
      final contractId = 'PN-${(existingPlans.size + 1).toString().padLeft(3, '0')}';

      // Prepare complete form data - matching admin panel field names
      final formData = {
        // Contract ID
        'contractId': contractId,
        
        // User Information
        'userId': user.uid,
        'userEmail': user.email,
        
        // Client Information (admin uses these field names)
        'client': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'contact': _phoneController.text.trim(),
        
        // Plan Details (matching admin field names)
        'planType': widget.title,
        'planTitle': widget.title,
        'packageName': widget.title,
        'lotSize': _getLotSize(widget.title),
        
        // Amounts as NUMBERS (not strings)
        'totalAmount': totalPrice,
        'totalPrice': widget.totalPrice, // Keep string version for display
        'downPayment': downPaymentAmount,
        'downPaymentString': widget.downPayment, // String version
        
        // Payment Information
        'monthlyPayment': _parseMonthlyPayment(_calculateMonthlyPayment()),
        'termMonths': _getPaymentTermMonths(),
        'paidMonths': 1, // Down payment counts as first month
        'remainingBalance': remainingBalance,
        
        // Payment tracking
        'paymentTerm': '${_getPaymentTermMonths()} months',
        'paymentMethod': _paymentMethod ?? '',
        'monthlyPaymentString': _calculateMonthlyPayment(),
        'nextPaymentDate': _getNextPaymentDate(),
    'nextPaymentAmount': _parseMonthlyPayment(_calculateMonthlyPayment()),
        
        // Dates
        'startDate': startDate,
        'endDate': _getEndDate(startDate, _getPaymentTermMonths()),
        'submittedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastPaymentDate': startDate,
        
        // Personal Information
        'fullName': _fullNameController.text.trim(),
        'dateOfBirth': _dateOfBirthController.text.trim(),
        'civilStatus': _civilStatus ?? '',
        'occupation': _occupationController.text.trim(),
        'nationality': _nationalityController.text.trim(),
        
        // Contact Information
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'province': _provinceController.text.trim(),
        'zipCode': _zipCodeController.text.trim(),
        'emergencyContact': _emergencyContactController.text.trim(),
        'emergencyPhone': _emergencyPhoneController.text.trim(),
        
        // Beneficiary Information
        'beneficiary': _beneficiaryNameController.text.trim(),
        'beneficiaryName': _beneficiaryNameController.text.trim(),
        'relationship': _relationship ?? '',
        'beneficiaryPhone': _beneficiaryPhoneController.text.trim(),
        
        // Additional Information
        'specialInstructions': _specialInstructionsController.text.trim(),
        'notes': _specialInstructionsController.text.trim(),
        
        // Terms and Status
        'agreedToTerms': _agreedToTerms,
        'consentedToData': _consentedToData,
        'confirmedInformation': _confirmedInformation,
        'status': 'active',
        
        // Legacy fields for compatibility
        'location': 'Garden Family Estate',
        'totalPayments': 1,
        'paymentsRemaining': _getPaymentTermMonths() - 1,
        
        // Additional for MyPlansScreen compatibility
        'paidAmount': downPaymentAmount,
      };

      // Save to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('preNeedAgreements')
          .add(formData);

      // Create initial payment record
      await FirebaseFirestore.instance
          .collection('payments')
          .add({
        'agreementId': docRef.id,
        'contractId': contractId,
        'userId': user.uid,
        'amount': downPaymentAmount,
        'paymentType': 'Down Payment',
        'paymentMethod': _paymentMethod ?? 'Not specified',
        'status': 'completed',
        'paidAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'description': 'Initial down payment for ${widget.title}',
      });

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pre-Need Agreement Submitted Successfully!'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to home/price list screen after short delay
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to submit form: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                  const SizedBox(height: 4),
                  Text("Total Price: ${widget.totalPrice}",
                      style: const TextStyle(color: Colors.black87)),
                  Text("Down Payment (20%): ${widget.downPayment}",
                      style: const TextStyle(color: Colors.black87)),
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
                      Expanded(
                          child: _buildTextField(
                              "Date of Birth", _dateOfBirthController)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDropdown("Civil Status")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              "Occupation", _occupationController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildTextField(
                              "Nationality", _nationalityController)),
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
                      Expanded(
                          child:
                              _buildTextField("Province", _provinceController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildTextField("Zip Code", _zipCodeController)),
                    ],
                  ),
                  _buildTextField("Email Address *", _emailController),
                  _buildTextField("Phone Number *", _phoneController),
                  _buildTextField(
                      "Emergency Contact", _emergencyContactController),
                  _buildTextField("Emergency Phone", _emergencyPhoneController),
                ],
              ),
            ),

            // Payment Information
            _buildCard(
              title: "Payment Information",
              child: Column(
                children: [
                  // Down Payment Summary Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Down Payment (20%)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              widget.downPayment,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Package Price",
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            Text(
                              widget.totalPrice,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Remaining Balance",
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            Text(
                              '₱${_calculateRemainingBalance(
                                _parseCurrency(widget.totalPrice),
                                _parseCurrency(widget.downPayment),
                              ).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  _buildDropdown("Payment Term"),
                  
                  // Monthly Payment Display (shown after selecting payment term)
                  if (_paymentTerm != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monthly Payment",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "Starting next month",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _calculateMonthlyPayment(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
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
                      Expanded(
                          child: _buildTextField(
                              "Beneficiary Phone", _beneficiaryPhoneController)),
                    ],
                  ),
                ],
              ),
            ),

            // Additional Information
            _buildCard(
              title: "Additional Information",
              child: _buildTextField(
                  "Special Instructions", _specialInstructionsController),
            ),

            // Terms and Conditions
            _buildCard(
              title: "Terms and Conditions",
              child: Column(
                children: [
                  _buildCheckboxRow(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value ?? false);
                    },
                    text: "I have read and agree to the Terms and Conditions",
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxRow(
                    value: _consentedToData,
                    onChanged: (value) {
                      setState(() => _consentedToData = value ?? false);
                    },
                    text: "I consent to the collection and processing of my personal data",
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxRow(
                    value: _confirmedInformation,
                    onChanged: (value) {
                      setState(() => _confirmedInformation = value ?? false);
                    },
                    text: "I confirm that all information provided is true",
                  ),

                  if (_allChecked) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveFormData,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.check_circle, color: Colors.white),
                        label: Text(
                          _isLoading ? "Submitting..." : "Submit Agreement",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "By submitting this form, you are entering into a binding agreement with Dumaguete Memorial Park.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black)),
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 12, top: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: value ? Colors.blue : Colors.grey.shade400,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            color: value ? Colors.blue : Colors.white,
          ),
          child: Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
              checkColor: Colors.white,
              side: BorderSide.none,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String hint) {
    List<String> items = [];
    dynamic currentValue;

    if (hint == "Civil Status") {
      items = ["Single", "Married", "Widowed", "Divorced"];
      currentValue = _civilStatus;
    } else if (hint == "Payment Term") {
      items = [
        "12 months - ₱ 6,011",
        "36 months - ₱2,483",
        "60 months - ₱1,780"
      ];
      currentValue = _paymentTerm;
    } else if (hint == "Initial Payment Method") {
      items = ["GCash", "Maya", "Bank Transfer"];
      currentValue = _paymentMethod;
    } else if (hint == "Relationship") {
      items = ["Spouse", "Child", "Sibling", "Parent", "Relative", "Friend"];
      currentValue = _relationship;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        hint: Text(
          hint,
          style: const TextStyle(color: Colors.black54),
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
        },
      ),
    );
  }
}