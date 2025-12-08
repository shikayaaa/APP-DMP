import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNameController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        _userId = currentUser.uid;
        final dbService = DatabaseService();
        final userProfile = await dbService.getUserProfile(currentUser.uid);

        if (userProfile != null) {
          setState(() {
            _nameController.text = userProfile.displayName ?? "";
            _emailController.text = userProfile.email;
            _phoneController.text = userProfile.phoneNumber ?? "+63 912 345 6789";
            _dobController.text = userProfile.dateOfBirth ?? "";
            _occupationController.text = userProfile.occupation ?? "Enter your occupation";
            _addressController.text = userProfile.address ?? "Dumaguete City, Negros Oriental";
            _emergencyNameController.text = userProfile.emergencyContactName ?? "Enter emergency contact name";
            _emergencyPhoneController.text = userProfile.emergencyContactPhone ?? "+63 912 345 6789";
            _bioController.text = userProfile.bio ?? "Tell us about yourself (optional)";
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading profile: $e")),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dbService = DatabaseService();
      
      // Prepare update data
      Map<String, dynamic> updateData = {
        'displayName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'address': _addressController.text.trim(),
        'emergencyContactName': _emergencyNameController.text.trim(),
        'emergencyContactPhone': _emergencyPhoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'updatedAt': DateTime.now(),
      };

      // Update user profile in Firestore
      await dbService.updateUserProfile(_userId!, updateData);

      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Changes Saved Successfully!")),
        );

        // Return updated data to previous screen
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
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving profile: $e")),
        );
      }
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "JD";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFEFF6F5),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 18, 46, 186),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 18, 46, 186),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 46, 186),
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Update your personal information",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                    backgroundColor: const Color.fromARGB(255, 0, 20, 121),
                    child: Text(
                      _getInitials(_nameController.text),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Personal Information
            _sectionCard("Personal Information", [
              _buildTextField("Full Name", _nameController),
              _buildTextField("Email Address", _emailController,
                  keyboard: TextInputType.emailAddress, enabled: false),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black),
                  label: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 237, 235),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save, color: Colors.black),
                  label: Text(
                    _isSaving ? "Saving..." : "Save Changes",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _bioController.dispose();
    super.dispose();
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
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // 🔹 Input Field
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? Colors.black : Colors.black54,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
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
            controller.text = "${picked.month}/${picked.day}/${picked.year}";
          }
        },
      ),
    );
  }
}