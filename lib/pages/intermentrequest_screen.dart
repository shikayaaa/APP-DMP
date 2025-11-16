import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class IntermentRequestScreen extends StatefulWidget {
  const IntermentRequestScreen({super.key});

  @override
  State<IntermentRequestScreen> createState() => _IntermentRequestScreenState();
}

class _IntermentRequestScreenState extends State<IntermentRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _nicheController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Dropdown values
  String? _selectedSection;
  String? _selectedTime;

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

  // File uploads
  List<String> uploadedFiles = [];

  // Pick files
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      withData: true,
    );

    if (result != null) {
      setState(() {
        uploadedFiles = result.files.map((f) => f.name).toList();
      });
    }
  }

  // Date Picker
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,   // ← SIMPLE BLUE
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0), // ← DEEP BLUE
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "New Interment Request",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // Deceased Info
              _buildCard(
                title: "Deceased Information",
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name *",
                    hintText: "Enter full name of deceased",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Full name is required" : null,
                ),
              ),

              const SizedBox(height: 16),

              // Lot Info
              _buildCard(
                title: "Lot Information",
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedSection,
                      decoration: const InputDecoration(
                        labelText: "Select Section *",
                        border: OutlineInputBorder(),
                      ),
                      items: sections
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedSection = val;
                      }),
                      validator: (val) =>
                          val == null ? "Please select section" : null,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _blockController,
                            decoration: const InputDecoration(
                              labelText: "Block *",
                              hintText: "e.g., A, B, C",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Block required" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lotController,
                            decoration: const InputDecoration(
                              labelText: "Lot Number *",
                              hintText: "e.g., 12",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Lot number required" : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nicheController,
                      decoration: const InputDecoration(
                        labelText: "Niche (if applicable)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Schedule
              _buildCard(
                title: "Preferred Schedule",
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Preferred Date *",
                        hintText: "mm/dd/yyyy",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Date required" : null,
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedTime,
                      decoration: const InputDecoration(
                        labelText: "Preferred Time",
                        border: OutlineInputBorder(),
                      ),
                      items: times
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedTime = val;
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contact Person
              _buildCard(
                title: "Contact Person",
                child: Column(
                  children: [
                    TextFormField(
                      controller: _contactNameController,
                      decoration: const InputDecoration(
                        labelText: "Contact Person Name *",
                        hintText: "Enter contact person name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Contact person name is required"
                          : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number *",
                        hintText: "Enter phone number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Phone number is required" : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Required documents
              _buildCard(
                title: "Required Documents",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Please upload the following required documents:",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    const Text("• Burial Permit (Required)"),
                    const Text("• Death Certificate (Recommended)"),
                    const Text("• Medical Certificate (If applicable)"),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Choose Files"),
                    ),

                    const SizedBox(height: 8),

                    if (uploadedFiles.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: uploadedFiles
                            .map((file) => Text(
                                  "📄 $file",
                                  style: const TextStyle(fontSize: 13),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Notes
              _buildCard(
                title: "Additional Notes",
                child: TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        "Any special requests or additional information...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1), // DEEP BLUE
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Interment Request Submitted"),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Submit Interment Request",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
