import 'package:flutter/material.dart';
import '../screens/confirmorder_screen.dart'; // Verify this matches your file paths

class AddressScreen extends StatefulWidget {
  final dynamic
  product; // Added: Accepts the specific product from the product details/cart page

  const AddressScreen({super.key, required this.product});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>(); // Added for Form Validation

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedCountry = "India";
  bool smsOffer = false;

  // Handles navigation flow and checks validations rules
  void _navigateToConfirmScreen() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmOrderScreen(
            name: fullNameController.text.trim(),
            address: apartmentController.text.isNotEmpty
                ? "${addressController.text.trim()}, ${apartmentController.text.trim()}"
                : addressController.text.trim(),
            city: cityController.text.trim(),
            state: stateController.text.trim(),
            zip: zipController.text.trim(),
            phone: phoneController.text.trim(),
            product: widget
                .product, // FIXED: Relays the product model data structure onward
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields accurately"),
        ),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    apartmentController.dispose();
    zipController.dispose();
    cityController.dispose();
    stateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Address to Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Step Indicator Track
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  _stepCircle("1", true),
                  const SizedBox(width: 8),
                  const Text(
                    "Set Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                  const Spacer(),
                  GestureDetector(
                    onTap: _navigateToConfirmScreen,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        _stepCircle("2", false),
                        const SizedBox(width: 8),
                        const Text(
                          "Confirm Order",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey, // Wrapped input content inside a Form widget
                child: Column(
                  children: [
                    _countryDropdown(),
                    const SizedBox(height: 12),
                    _textFormField(
                      controller: fullNameController,
                      hint: "Full Name",
                      errorMessage: "Name is required",
                    ),
                    const SizedBox(height: 12),
                    _textFormField(
                      controller: addressController,
                      hint: "Street Address",
                      errorMessage: "Address is required",
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Use My Location",
                          style: TextStyle(
                            color: Color.fromARGB(255, 17, 18, 17),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Non-required field helper field entry
                    TextFormField(
                      controller: apartmentController,
                      decoration: InputDecoration(
                        hintText: "Apt/Suite/Other (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _textFormField(
                      controller: zipController,
                      hint: "ZIP Code",
                      errorMessage: "ZIP Code is required",
                      isNumber: true,
                    ),
                    const SizedBox(height: 12),
                    _textFormField(
                      controller: cityController,
                      hint: "City",
                      errorMessage: "City name is required",
                    ),
                    const SizedBox(height: 12),
                    _textFormField(
                      controller: stateController,
                      hint: "State",
                      errorMessage: "State name is required",
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "🇮🇳 +91",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        hintText: "Your phone number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.trim().length < 10) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          value: smsOffer,
                          activeColor: const Color.fromARGB(255, 26, 27, 26),
                          onChanged: (value) {
                            setState(() {
                              smsOffer = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Sign up for text to get 20% OFF",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            17,
                            18,
                            17,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _navigateToConfirmScreen,
                        child: const Text(
                          "Save and Continue",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle(String text, bool active) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: active
          ? const Color.fromARGB(255, 15, 15, 15)
          : Colors.grey.shade300,
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _countryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: const [
        DropdownMenuItem(value: "India", child: Text("India")),
        DropdownMenuItem(value: "USA", child: Text("USA")),
        DropdownMenuItem(value: "UK", child: Text("UK")),
      ],
      onChanged: (value) {
        setState(() {
          selectedCountry = value!;
        });
      },
    );
  }

  // Changed from base TextField to TextFormField to capture individual input checks
  Widget _textFormField({
    required TextEditingController controller,
    required String hint,
    required String errorMessage,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}
