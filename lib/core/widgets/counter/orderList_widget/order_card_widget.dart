import 'package:barpos/core/widgets/counter/dialog_widget/order_dialog.dart';
import 'package:barpos/core/widgets/counter/orderList_widget/order_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/core/widgets/counter/progress_status.dart';

class OrderCardWidget extends StatelessWidget {
  final Map order;
  final CounterHomeController controller;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final orderStatus = order['order_status'] ?? '';
    final paymentStatus = order['payment_status'] ?? '';

    return GestureDetector(
      onTap: () {
        OrderDialog.show(context, order: order, controller: controller);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    color: OrderUiHelper.getStatusColor(
                      orderStatus,
                      paymentStatus,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orderStatus.toString().toUpperCase(),
                    style: TextStyle(
                      color: OrderUiHelper.getStatusColor(
                        orderStatus,
                        paymentStatus,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // 🔹 ROW 1
                    Row(
                      children: [
                        Expanded(
                          child: _infoChip(
                            icon: Icons.table_restaurant_rounded,
                            value: order['table_ref'],
                          ),
                        ),
                        const SizedBox(width: 6),

                        Expanded(
                          child: _infoChip(
                            icon: Icons.payment_rounded,
                            value: paymentStatus,
                          ),
                        ),
                        const SizedBox(width: 6),

                        Expanded(
                          child: _infoChip(
                            icon: Icons.access_time_rounded,
                            value: _formatTime(order['created_at']),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔹 ROW 2
                    Row(
                      children: [
                        Expanded(
                          child: _infoChip(
                            icon: Icons.person_rounded,
                            label: "Staff",
                            showLabel: true,
                            value: order['created_by'],
                          ),
                        ),
                        const SizedBox(width: 6),

                        Expanded(
                          child: _infoChip(
                            icon: Icons.calendar_month_rounded,
                            value: _formatDate(order['created_at']),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            ProgressTracker(status: orderStatus),

            // ACTION BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => OrderDialog.show(
                  context,
                  order: order,
                  controller: controller,
                ),
                icon: Icon(
                  OrderUiHelper.getButtonIcon(orderStatus, paymentStatus),
                  size: 18,
                ),
                label: Text(
                  OrderUiHelper.getButtonText(orderStatus, paymentStatus),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: OrderUiHelper.getButtonColor(
                    orderStatus,
                    paymentStatus,
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required dynamic value,
    String? label,
    bool showLabel = false,
  }) {
    final v = _safe(value);
    if (v.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade700),

          const SizedBox(width: 6),

          if (showLabel && label != null) ...[
            Text(
              "$label",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
          ],

          Container(width: 1, height: 12, color: Colors.grey.shade300),

          const SizedBox(width: 6),

          Flexible(
            child: Text(
              v,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "-";

    try {
      final dt = DateTime.parse(dateTime);

      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');

      return "$hour:$min";
    } catch (e) {
      return dateTime;
    }
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "-";

    try {
      final dt = DateTime.parse(dateTime);

      final months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      final day = dt.day;
      final month = months[dt.month - 1];
      final year = dt.year;

      return "$day $month $year";
    } catch (e) {
      return dateTime;
    }
  }

  String _safe(dynamic value) {
    if (value == null) return '';
    final v = value.toString().trim();
    if (v.isEmpty || v.toLowerCase() == 'null') return '';
    return v;
  }
}
