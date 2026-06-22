import 'package:flutter/material.dart';
import '../screens/cardpayment_screen.dart';
import '../screens/ordersuccess_screen.dart'; // Added: Direct route for COD completion

class PaymentMethodScreen extends StatefulWidget {
  final dynamic product;

  const PaymentMethodScreen({super.key, required this.product});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectedPaymentMethod = 0;

  // Helper logic to process the final selection routing sequence
  void _handlePaymentSelection(int index) {
    setState(() {
      selectedPaymentMethod = index;
    });

    if (index == 3) {
      // Cash on Delivery direct processing sequence
      setState(() {
        widget.product.isPurchased = true;
        widget.product.inCart = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(product: widget.product),
        ),
      );
    } else {
      // Standard Online Card Checkout Flow routing logic
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentScreen(product: widget.product),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double calculatedTotal =
        widget.product.price * widget.product.quantity;

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
          "Payment Method",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Step Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _stepCircle("1", false),
                  const SizedBox(width: 6),
                  const Text(
                    "Address",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const Spacer(),
                  _stepCircle("2", false),
                  const SizedBox(width: 6),
                  const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const Spacer(),
                  _stepCircle("3", true),
                  const SizedBox(width: 6),
                  const Text(
                    "Payment",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// Amount Box
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Total Amount to Pay",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${calculatedTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// Payment Methods Selection List
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Payment Option",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _paymentTile(
                    index: 0,
                    title: "Credit / Debit Card",
                    subtitle: "Visa, Mastercard, AMEX",
                    icon: Icons.credit_card,
                  ),
                  const Divider(),
                  _paymentTile(
                    index: 1,
                    title: "PayPal",
                    subtitle: "Pay easily using your PayPal account",
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const Divider(),
                  _paymentTile(
                    index: 2,
                    title: "Apple Pay / Google Pay",
                    subtitle: "Fast checkout using secure mobile wallets",
                    icon: Icons.phone_android,
                  ),
                  const Divider(),
                  // Added: Cash on Delivery Entry Block
                  _paymentTile(
                    index: 3,
                    title: "Cash on Delivery (COD)",
                    subtitle: "Pay with cash upon package delivery arrival",
                    icon: Icons.local_shipping_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedPaymentMethod == index;

    return InkWell(
      onTap: () => _handlePaymentSelection(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade700,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: selectedPaymentMethod,
              activeColor: Colors.green.shade700,
              onChanged: (value) => _handlePaymentSelection(value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle(String text, bool active) {
    return CircleAvatar(
      radius: 11,
      backgroundColor: active ? Colors.black : Colors.grey.shade300,
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontSize: 11,
        ),
      ),
    );
  }
}
