import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'orders_controller.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),

      body: Obx(() {
        /// LOADING
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// EMPTY STATE
        if (controller.orders.isEmpty) {
          return const Center(
            child: Text(
              "No orders found",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        /// LIST
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${order['id'] ?? '-'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "Table: ${order['tableRef'] ?? '-'}",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// TOTAL
                    Text(
                      "Total: TZS ${order['total'] ?? 0}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// STATUS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(order['status'])
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (order['status'] ?? "pending").toString(),
                        style: TextStyle(
                          color: _statusColor(order['status']),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// STATUS COLOR HELPER
  Color _statusColor(dynamic status) {
    switch (status?.toString().toLowerCase()) {
      case "paid":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "processing":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}