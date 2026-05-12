import 'package:barpos/core/widgets/counter/Progress_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/counter/home/home_controller.dart';

class CounterOrdersWidget extends StatelessWidget {
  const CounterOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterHomeController>();

    final filters = ["All", "pending", "processing", "cancelled", "completed"];

    return Obx(() {
      final orders = controller.orders;

      final filteredOrders = controller.selectedCategory.value == "All"
          ? orders
          : orders
                .where(
                  (o) => o['order_status'] == controller.selectedCategory.value,
                )
                .toList();

      // counts
      int count(String status) =>
          orders.where((o) => o['order_status'] == status).length;

      final total = orders.length;
      final pending = count("pending");
      final processing = count("processing");
      final completed = count("completed");
      final cancelled = count("cancelled");

      return RefreshIndicator(
        onRefresh: () async {
          final token = controller.authProvider.accessToken.value;
          final counter = controller.selectedMyCounter.value;

          if (token != null && counter != null) {
            await controller.loadCounterOrders(counter.id);
          }
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF14B8A6), Color(0xFF0EA5E9)],
                ),
              ),
              child: Row(
                children: [
                  /// PROGRESS RING
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(
                          value: total == 0 ? 0 : completed / total,
                          strokeWidth: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "$total",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // TEXT INFO
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Counter Orders",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Live order tracking overview",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _statusCard("Pending", pending, Colors.orange),
                  _statusCard("Processing", processing, Colors.blue),
                  _statusCard("Completed", completed, Colors.green),
                  _statusCard("Cancelled", cancelled, Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final status = filters[index];

                  return Obx(() {
                    final selected =
                        controller.selectedCategory.value == status;

                    return GestureDetector(
                      onTap: () {
                        controller.selectedCategory.value = status;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: selected ? Colors.teal : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: controller.isLoadingOrders.value
                  ? const Center(child: CircularProgressIndicator())
                  : filteredOrders.isEmpty
                  ? const Center(child: Text("No orders found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];

                        return GestureDetector(
                          onTap: () =>
                              _openOrderDialog(context, order, controller),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TOP ROW
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Order #${order['order_ref']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    // STATUS CHIP
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(
                                          order['order_status'],
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        order['order_status']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: _statusColor(
                                            order['order_status'],
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                                Text("Table: ${order['table_ref'] ?? '-'}"),
                                Text(
                                  "Payment Status: ${order['payment_status'] ?? '-'}",
                                ),
                                Text("Created: ${order['created_at'] ?? '-'}"),

                                const SizedBox(height: 10),

                                ProgressTracker(status: order['order_status']),

                                const SizedBox(height: 10),

                                // ACTION BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openOrderDialog(
                                      context,
                                      order,
                                      controller,
                                    ),
                                    icon: const Icon(
                                      Icons.receipt_long_rounded,
                                      size: 18,
                                    ),
                                    label: const Text("Process Order"),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "ready":
        return Colors.purple;
      case "completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // STATUS CARD WIDGET
  Widget _statusCard(String title, int count, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _openOrderDialog(BuildContext context, Map order, controller) {
    final List items = order['items'] ?? [];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Order #${order['order_ref']}"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Table: ${order['table_ref'] ?? '-'}"),
                Text("Payment Status: ${order['payment_status'] ?? '-'}"),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTotalItems(items)} item(s)",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "TZS ${getTotalAmount(items).toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ITEM LIST
                ...items.map((item) {
                  return ListTile(
                    dense: true,
                    leading: Image.network(
                      item['logo'] ?? '',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['itemName'] ?? ''),
                    subtitle: Text(
                      "Qty: ${item['itemQty']} x ${item['itemPrice']}",
                    ),
                    trailing: Text(
                      "TZS ${(item['itemQty'] * item['itemPrice'])}",
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  int getTotalItems(List items) {
    return items.fold<int>(
      0,
      (sum, item) => sum + (item['itemQty'] ?? 0) as int,
    );
  }

  double getTotalAmount(List items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + ((item['itemQty'] ?? 0) * (item['itemPrice'] ?? 0)),
    );
  }
}
