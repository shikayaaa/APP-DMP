import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@example.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "+63 912 345 6789");
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController =
      TextEditingController(text: "Enter your occupation");
  final TextEditingController _addressController =
      TextEditingController(text: "Dumaguete City, Negros Oriental");
  final TextEditingController _emergencyNameController =
      TextEditingController(text: "Enter emergency contact name");
  final TextEditingController _emergencyPhoneController =
      TextEditingController(text: "+63 912 345 6789");
  final TextEditingController _bioController =
      TextEditingController(text: "Tell us about yourself (optional)");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
     appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 18, 186, 153),
  elevation: 0,
  title: const Text(
    "Edit Profile",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold, // ✅ made bold
    ),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
  bottom: const PreferredSize(
    preferredSize: Size.fromHeight(28),
    child: Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        "Update your personal information",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold, // ✅ made bold
        ),
      ),
    ),
  ),
     ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Profile Picture Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal.shade700,
                    child: const Text(
                      "JD",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: image picker
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Tap to change profile picture"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Personal Information
            _sectionCard("Personal Information", [
              _buildTextField("Full Name", _nameController),
              _buildTextField("Email Address", _emailController,
                  keyboard: TextInputType.emailAddress),
              _buildTextField("Phone Number", _phoneController,
                  keyboard: TextInputType.phone),
              _buildDateField("Date of Birth", _dobController),
              _buildTextField("Occupation", _occupationController),
            ]),

            const SizedBox(height: 16),

            // 🔹 Contact Information
            _sectionCard("Contact Information", [
              _buildTextField("Address", _addressController),
              _buildTextField("Emergency Contact Name", _emergencyNameController),
              _buildTextField("Emergency Contact Phone", _emergencyPhoneController,
                  keyboard: TextInputType.phone),
            ]),

            const SizedBox(height: 16),

            // 🔹 About Me
            _sectionCard("About Me", [
              _buildTextField("Bio/Notes", _bioController, maxLines: 3),
            ]),

            const SizedBox(height: 20),

            // 🔹 Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Cancel"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 237, 235),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // 👉 Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Changes Saved!")),
                    );

                    // 👉 Return to ProfileScreen with updated data
                    Navigator.pop(context, {
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "phone": _phoneController.text,
                      "dob": _dobController.text,
                      "occupation": _occupationController.text,
                      "address": _addressController.text,
                      "emergencyName": _emergencyNameController.text,
                      "emergencyPhone": _emergencyPhoneController.text,
                      "bio": _bioController.text,
                    });
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔹 Section Container
  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // 🔹 Input Field
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // 🔹 Date Field (with calendar picker)
  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text =
                "${picked.month}/${picked.day}/${picked.year}";
          }
        },
      ),
    );
  }
}
