import 'package:flutter/material.dart';
import '../screens/ordersuccess_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final dynamic product;

  const CardPaymentScreen({super.key, required this.product});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>(); // Added for Form Validation

  final nameController = TextEditingController();
  final cardController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final zipController = TextEditingController();

  void _validateAndPay(double amount) {
    if (_formKey.currentState!.validate()) {
      // Highlight: Update the product flags to show in Order History and remove from Cart
      setState(() {
        widget.product.isPurchased = true;
        widget.product.inCart = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(product: widget.product),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double calculatedTotal =
        widget.product.price * widget.product.quantity;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Pay Invoice", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey, // Wrapped fields inside a Form widget
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.credit_card, size: 40)],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Amount",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$${calculatedTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Name on Card
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name on Card",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter the name on the card";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// Card Number
                  TextFormField(
                    controller: cardController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      labelText: "Card Number",
                      border: OutlineInputBorder(),
                      counterText:
                          "", // Hides the default maxLength character counter
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter card number";
                      }
                      if (value.length < 16 || int.tryParse(value) == null) {
                        return "Enter a valid 16-digit card number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// Expiry and CVV Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: expiryController,
                          maxLength: 5,
                          decoration: const InputDecoration(
                            labelText: "MM/YY",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            // Regex pattern matching to enforce MM/YY syntax rules
                            if (!RegExp(
                              r'^(0[1-9]|1[0-2])\/?([0-9]{2})$',
                            ).hasMatch(value)) {
                              return "Use MM/YY format";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: cvvController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: const InputDecoration(
                            labelText: "CVV",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            if (value.length < 3 ||
                                int.tryParse(value) == null) {
                              return "Invalid";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  /// ZIP Code
                  TextFormField(
                    controller: zipController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: "ZIP / Postal Code",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your ZIP code";
                      }
                      if (value.length < 5) {
                        return "Enter a valid ZIP code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),

                  /// Submit Payment Button Trigger
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
                      ),
                      onPressed: () => _validateAndPay(calculatedTotal),
                      child: Text(
                        "Pay \$${calculatedTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
