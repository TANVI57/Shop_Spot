import 'package:flutter/material.dart';
import '../screens/paymentmethod_screen.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String phone;
  final dynamic product; // Added: Accepts the dynamic product being purchased

  const ConfirmOrderScreen({
    super.key,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
    required this.product,
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int selectedShipping = 0;

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate price based on product values and selected shipping choice
    double basePrice = widget.product.price * widget.product.quantity;
    double shippingFee = selectedShipping == 1 ? 10.5 : 0.0;
    double totalPrice = basePrice + shippingFee;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Confirm Your Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Step Indicator Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        _stepCircle("1", false),
                        const SizedBox(width: 8),
                        const Text(
                          "Set Address",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const Spacer(),
                  _stepCircle("2", true),
                  const SizedBox(width: 8),
                  const Text(
                    "Confirm Order",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Address Display Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.name}  (+91) ${widget.phone}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.address}, ${widget.city}, ${widget.state} - ${widget.zip}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Dynamic Item Detail Card Block
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Item Detail",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.shopping_bag,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                          ),
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
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Category : ${widget.product.category}",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text(
                              "Quantity : ${widget.product.quantity}",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${widget.product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal"),
                      Text(
                        "\$${basePrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 13, 13, 13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Shipping Options
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Shipping",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: shippingCard(
                          title: "Standard Shipping",
                          subtitle: "Delivery: Apr 21-25",
                          price: "FREE",
                          index: 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: shippingCard(
                          title: "Express Shipping",
                          subtitle: "Delivery: Apr 18",
                          price: "\$10.5",
                          index: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 15, 15, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // FIXED: Passes the updated product context directly downstream
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentMethodScreen(product: widget.product),
                ),
              );
            },
            child: Text(
              "Submit Order (\$${totalPrice.toStringAsFixed(2)})",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget shippingCard({
    required String title,
    required String subtitle,
    required String price,
    required int index,
  }) {
    bool selected = selectedShipping == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedShipping = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: selected
                ? const Color.fromARGB(255, 15, 16, 15)
                : Colors.grey.shade300,
            width: selected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedShipping,
              activeColor: const Color.fromARGB(255, 16, 17, 16),
              onChanged: (value) {
                setState(() {
                  selectedShipping = value!;
                });
              },
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Color.fromARGB(255, 35, 36, 35),
                fontWeight: FontWeight.bold,
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
          ? const Color.fromARGB(255, 19, 19, 19)
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
}
