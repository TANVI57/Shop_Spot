import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic product; // Accepts the product clicked by the user

  const OrderDetailsScreen({super.key, required this.product});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String userName = "Loading...";
  String userPhone = "Loading...";
  String userAddress = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeliveryAddress();
  }

  // Fetch the custom information saved by the user from SharedPreferences
  Future<void> _loadDeliveryAddress() async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('userEmail') ?? "user@gmail.com";
    String fallbackName = email.split('@')[0];
    fallbackName = fallbackName.isNotEmpty
        ? '${fallbackName[0].toUpperCase()}${fallbackName.substring(1)}'
        : "User";

    setState(() {
      userName = prefs.getString('userName') ?? fallbackName;
      userPhone = prefs.getString('userPhone') ?? "No phone number provided";
      userAddress =
          prefs.getString('userAddress') ?? "No delivery address provided";
      isLoading = false;
    });
  }

  Future<void> downloadInvoice(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      "${directory.path}/invoice_${widget.product.title.replaceAll(' ', '_')}.txt",
    );

    final double calculatedTotal =
        widget.product.price * widget.product.quantity;

    await file.writeAsString('''
ORDER INVOICE

Order Number : #ORD${widget.product.hashCode.abs()}
Item: ${widget.product.title}

Customer:
$userName

Address:
$userAddress

Phone:
$userPhone

Price Details:
Grand Total: \$${calculatedTotal.toStringAsFixed(2)}

Payment Status:
Paid Successfully
''');

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invoice downloaded successfully")),
    );
  }

  Widget priceRow(
    String title,
    String value, {
    Color valueColor = Colors.black,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 20 : 17,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 20 : 17,
              color: valueColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double itemPrice = widget.product.price;
    final int itemQty = widget.product.quantity;
    final double grandTotal = itemPrice * itemQty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order Success Status Card
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Order Placed Successfully",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Purchased Product Breakdown Row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.product.imageUrl,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, size: 40),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product.category,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Price: \$${itemPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Interactive Rating Segment
                  Row(
                    children: [
                      const Text(
                        "Rate this product",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 15),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.star_border,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// Dynamic Shipping Details Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SHIPPING ADDRESS",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userAddress,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Phone: $userPhone",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Dynamic Invoice Price Structure Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Prices are inclusive of all taxes",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        priceRow(
                          "Item Base Price",
                          "\$${itemPrice.toStringAsFixed(2)}",
                        ),
                        priceRow("Quantity Selected", "x$itemQty"),
                        const Divider(thickness: 1, height: 30),
                        priceRow(
                          "Grand Total",
                          "\$${grandTotal.toStringAsFixed(2)}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Document Export Button Action
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => downloadInvoice(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Download Invoice",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
