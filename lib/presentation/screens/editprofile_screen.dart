import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController =
      TextEditingController(); // Controller for Contact Number
  final addressController = TextEditingController(); // Controller for Address

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  // Load data from memory (Email, Name, Phone, and Address)
  Future<void> _loadCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('userEmail') ?? "user@gmail.com";
    String fallbackName = email.split('@')[0];
    fallbackName = fallbackName.isNotEmpty
        ? '${fallbackName[0].toUpperCase()}${fallbackName.substring(1)}'
        : "User";

    setState(() {
      emailController.text = email;
      nameController.text = prefs.getString('userName') ?? fallbackName;
      phoneController.text = prefs.getString('userPhone') ?? "";
      addressController.text = prefs.getString('userAddress') ?? "";
      isLoading = false;
    });
  }

  // Save changes back to SharedPreferences
  Future<void> _saveProfileChanges() async {
    final updatedName = nameController.text.trim();
    final updatedPhone = phoneController.text.trim();
    final updatedAddress = addressController.text.trim();

    if (updatedName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name cannot be empty")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', updatedName);
    await prefs.setString('userPhone', updatedPhone);
    await prefs.setString('userAddress', updatedAddress);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );

    // Pops back and tells the Profile screen to trigger a refresh
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xff111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Name Input Field
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email Input Field (Disabled profile identity key)
                  TextField(
                    controller: emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Gmail Address",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white10,
                      filled: true,
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // Contact Number Input Field
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Contact Number",
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address Input Field
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Save Changes Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveProfileChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff111111),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SAVE CHANGES",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
