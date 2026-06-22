import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // Dynamically filter using dummyProducts based on selectedTab
    final filteredOrders = dummyProducts.where((product) {
      if (selectedTab == 0) {
        // Completed Tab
        return product.isPurchased;
      } else if (selectedTab == 1) {
        // Pending Tab (Modify flag based on your product_model.dart if available)
        return false;
      } else {
        // Cancel Tab (Modify flag based on your product_model.dart if available)
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          /// Tabs Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _tabButton("Completed", 0),
                  _tabButton("Pending", 1),
                  _tabButton("Cancel", 2),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// Conditional UI depending on order count
          if (filteredOrders.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No Orders Found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  // Show newest items first
                  final product = filteredOrders.reversed.toList()[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        /// Product Image
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 40);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Product Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.category,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),

                        /// Quantity + Adaptive Status Layout
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Quantity: ${product.quantity}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  selectedTab,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(selectedTab),
                                style: TextStyle(
                                  color: _getStatusColor(selectedTab),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    bool selected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xff111111)
                : Colors.transparent, // Clean black accent match
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(int tabIndex) {
    if (tabIndex == 1) return "Pending";
    if (tabIndex == 2) return "Cancelled";
    return "Completed";
  }

  Color _getStatusColor(int tabIndex) {
    if (tabIndex == 1) return Colors.orange;
    if (tabIndex == 2) return Colors.red;
    return Colors.green;
  }
}
