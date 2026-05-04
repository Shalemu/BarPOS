import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/orders/orders_controller.dart';
import 'package:barpos/services/model/order_item.dart';
import 'package:flutter/material.dart';
import 'package:barpos/core/widgets/progress.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

Color getCounterColor(String name) {
  final colors = [
    AppColors.primary,
    AppColors.blue,
    AppColors.blackshade,
    AppColors.lightblueshade,
    AppColors.grayshade,
  ];

  final index = name.hashCode % colors.length;
  return colors[index.abs()];
}

String formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "-";

  final date = DateTime.tryParse(dateStr);
  if (date == null) return "-";

  return DateFormat("dd MMM yyyy  [HH:mm]").format(date.toLocal());
}

class _OrderCardState extends State<OrderCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final counter = order['counter'] as Map<String, dynamic>?;
    final counterName = counter?['counterName'] ?? 'N/A';

    final orderId = order['orderRef'] ?? order['orderId'];
    final status = (order['orderStatus'] ?? "pending").toString().toLowerCase();
    final List<OrderItem> items = (order['items'] ?? []).map<OrderItem>((e) {
      return OrderItem.fromJson(e);
    }).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ORDER ID
              Text(
                "Order #$orderId",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                counterName,
                style: TextStyle(
                  color: getCounterColor(counterName),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Table: ${order['tableRef'] ?? '-'}",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),

          const SizedBox(height: 12),

          ProgressTracker(status: status),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                "AMOUNT: TZS ${NumberFormat("#,##0").format(_calculateTotal(items))}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (status == "pending") ...[
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      final orderId = order['orderId'];
                      await Get.find<OrdersController>().cancelOrder(orderId);
                    },
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final orderId = order['orderId'];

                      print("\n========== ADD ITEMS DEBUG ==========");
                      print("Order ID: $orderId");
                      print("Order Ref: ${order['orderRef']}");
                      print("Table Ref: ${order['tableRef']}");
                      print("Status: ${order['orderStatus']}");
                      print("Created At: ${order['createdAt']}");

                      print("\n------ ITEMS INSIDE ORDER ------");

                      final items = order['items'] ?? [];

                      for (var item in items) {
                        print("Item Name: ${item['itemName'] ?? item['name']}");
                        print("  ID: ${item['itemId']}");
                        print("  Category: ${item['itemCategory']}");
                        print("  Qty Ordered: ${item['itemQty']}");

                        // 🔥 STOCK INFO (from API or stored response)
                        print(
                          "  Remaining Stock: ${item['remainingQty'] ?? 'N/A'}",
                        );
                        print(
                          "  Initial Stock: ${item['stock']?['initial'] ?? 'N/A'}",
                        );
                        print("-----------------------------------");
                      }

                      print("====================================\n");

                      Get.toNamed('/add-items', arguments: order)?.then((
                        result,
                      ) {
                        if (result == true) {
                          Get.find<OrdersController>().fetchOrders();
                        }
                      });

                      print("Opening Add Items for Order: $orderId");
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      "Add Items",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style:
                        OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.8,
                          ),
                          // padding: const EdgeInsets.symmetric(vertical: 14),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(14),
                          // ),
                        ).copyWith(
                          overlayColor: WidgetStatePropertyAll(
                            AppColors.primary.withOpacity(0.08),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "View Order Details",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),

          if (expanded) ...[
            const SizedBox(height: 10),

            _info("Order Ref", order['orderRef'] ?? '-'),
            _info("Table", order['tableRef'] ?? '-'),
            _info("Payment", order['paymentStatus'] ?? '-'),
            _info("Created", formatDate(order['createdAt'])),

            const SizedBox(height: 10),

            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.name} x${item.qty}"),
                    Text("TZS ${NumberFormat("#,##0").format(item.price)}"),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(List<OrderItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.price * item.qty;
    }
    return total;
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "ready":
        return Colors.purple;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
