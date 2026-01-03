import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IntermentRequestScreen extends StatefulWidget {
  const IntermentRequestScreen({super.key});

  @override
  State<IntermentRequestScreen> createState() => _IntermentRequestScreenState();
}

class _IntermentRequestScreenState extends State<IntermentRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _nicheController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedSection;
  String? _selectedTime;
  bool _isSubmitting = false;

  final List<String> sections = [
    "Lawn Area",
    "Memorial Garden",
    "Garden Family Estate",
    "Family Estate"
  ];

  final List<String> times = [
    "Morning (8:00 AM-11:00 AM)",
    "Afternoon (1:00 PM-4:00 PM)"
  ];

  List<PlatformFile> uploadedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        uploadedFiles = result.files;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
      });
    }
  }

  Future<List<String>> _uploadFiles() async {
    List<String> fileUrls = [];

    try {
      for (var file in uploadedFiles) {
        if (file.bytes != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('interment_documents')
              .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

          final uploadTask = await storageRef.putData(file.bytes!);
          final downloadUrl = await uploadTask.ref.getDownloadURL();
          fileUrls.add(downloadUrl);
        }
      }
    } catch (e) {
      print('Error uploading files: $e');
      throw Exception('Failed to upload documents');
    }

    return fileUrls;
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a section")),
      );
      return;
    }

    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a preferred date")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Please log in to submit a request');
      }

      // Upload files to Firebase Storage
      List<String> documentUrls = [];
      if (uploadedFiles.isNotEmpty) {
        documentUrls = await _uploadFiles();
      }

      // Save request to Firestore
      await FirebaseFirestore.instance.collection('interment_requests').add({
        'userId': user.uid,
        'deceasedName': _nameController.text.trim(),
        'section': _selectedSection,
        'block': _blockController.text.trim(),
        'lotNumber': _lotController.text.trim(),
        'niche': _nicheController.text.trim(),
        'preferredDate': _dateController.text,
        'preferredTime': _selectedTime ?? '',
        'contactPersonName': _contactNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'additionalNotes': _notesController.text.trim(),
        'documentUrls': documentUrls,
        'status': 'Pending',
        'submittedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Interment Request Submitted Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _nameController.clear();
        _blockController.clear();
        _lotController.clear();
        _nicheController.clear();
        _dateController.clear();
        _contactNameController.clear();
        _phoneController.clear();
        _notesController.clear();
        setState(() {
          _selectedSection = null;
          _selectedTime = null;
          uploadedFiles.clear();
        });

        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _blockController.dispose();
    _lotController.dispose();
    _nicheController.dispose();
    _dateController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "New Interment Request",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCard(
                    title: "Deceased Information",
                    child: _whiteTextField(
                      controller: _nameController,
                      label: "Full Name *",
                      hint: "Enter full name of deceased",
                      validator: (value) =>
                          value!.isEmpty ? "Full name is required" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Lot Information",
                    child: Column(
                      children: [
                        _whiteDropdown(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _whiteTextField(
                                controller: _blockController,
                                label: "Block *",
                                hint: "e.g., A, B, C",
                                validator: (value) =>
                                    value!.isEmpty ? "Block required" : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _whiteTextField(
                                controller: _lotController,
                                label: "Lot Number *",
                                hint: "e.g., 12",
                                validator: (value) =>
                                    value!.isEmpty ? "Lot number required" : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _whiteTextField(
                          controller: _nicheController,
                          label: "Niche (if applicable)",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Preferred Schedule",
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            label: "Preferred Date *",
                            hint: "mm/dd/yyyy",
                            icon: Icons.calendar_today,
                          ),
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 12),
                        _whiteTimeDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Contact Person",
                    child: Column(
                      children: [
                        _whiteTextField(
                          controller: _contactNameController,
                          label: "Contact Person Name *",
                          hint: "Enter contact person name",
                          validator: (value) =>
                              value!.isEmpty ? "Contact person is required" : null,
                        ),
                        const SizedBox(height: 12),
                        _whiteTextField(
                          controller: _phoneController,
                          label: "Phone Number *",
                          hint: "Enter phone number",
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty ? "Phone number required" : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Required Documents",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Please upload:",
                            style: TextStyle(color: Colors.black)),
                        const SizedBox(height: 8),
                        const Text("• Burial Permit (Required)",
                            style: TextStyle(color: Colors.black)),
                        const Text("• Death Certificate (Recommended)",
                            style: TextStyle(color: Colors.black)),
                        const Text("• Medical Certificate (If applicable)",
                            style: TextStyle(color: Colors.black)),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isSubmitting ? null : _pickFiles,
                          icon: const Icon(Icons.upload_file, color: Colors.black),
                          label: const Text(
                            "Choose Files",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (uploadedFiles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: uploadedFiles
                                .map((file) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.attach_file,
                                              size: 16, color: Colors.black54),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              file.name,
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Additional Notes",
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration(
                        label: "Notes",
                        hint: "Any special requests or information...",
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitRequest,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Submit Interment Request",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String label, String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black38, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black38),
      ),
    );
  }

  Widget _whiteTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: _inputDecoration(label: label, hint: hint),
      validator: validator,
      enabled: !_isSubmitting,
    );
  }

  Widget _whiteDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSection,
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      decoration: _inputDecoration(label: "Select Section *"),
      items: sections
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: _isSubmitting ? null : (val) => setState(() => _selectedSection = val),
      validator: (val) => val == null ? "Please select section" : null,
    );
  }

  Widget _whiteTimeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTime,
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      decoration: _inputDecoration(label: "Preferred Time"),
      items:
          times.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: _isSubmitting ? null : (val) => setState(() => _selectedTime = val),
    );
  }
}