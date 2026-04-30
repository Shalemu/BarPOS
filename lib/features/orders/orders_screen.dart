import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/app_search_bar.dart';
import 'package:barpos/core/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'orders_controller.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.filteredOrders;
        return Column(
          children: [
            _buildSearchBar(),
            _buildDateFilter(context),
            _buildFilterRow(),

            Expanded(
              child: orders.isEmpty
                  ? const Center(
                      child: Text(
                        "No orders found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: orders.length + 1,
                      itemBuilder: (context, index) {
                        if (index < orders.length) {
                          final order = orders[index];
                          return OrderCard(order: order);
                        }

                        // loader at bottom
                        return Obx(
                          () => controller.isLoadingMore.value
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox(),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AppSearchBar(
        hintText: "Search by table, order ref...",
        onChanged: controller.setSearch,
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Obx(() {
      final from = controller.fromDate.value;
      final to = controller.toDate.value;

      final hasFilter = from != null && to != null;

      String label = "Select Date Range";
      if (hasFilter) {
        label =
            "${from.toLocal().toString().split(" ")[0]} → ${to.toLocal().toString().split(" ")[0]}";
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                      initialDateRange: hasFilter
                          ? DateTimeRange(start: from!, end: to!)
                          : null,
                    );

                    if (picked != null) {
                      controller.fromDate.value = picked.start;
                      controller.toDate.value = picked.end;

                      controller.fetchOrders();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: hasFilter
                          ? AppColors.primary.withOpacity(0.08)
                          : const Color(0xFFF6F7FB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 18,
                          color: hasFilter
                              ? AppColors.primary
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: hasFilter
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (hasFilter) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.clearDateFilter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterRow() {
    return Obx(() {
      final current = controller.statusFilter.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _filterChip("All", current),
            _filterChip("Pending", current),
            _filterChip("Processing", current),
            _filterChip("Completed", current),
            _filterChip("Cancelled", current),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String label, String current) {
    final isSelected =
        current.toLowerCase() == label.toLowerCase() ||
        (current == "all" && label == "All");

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey.shade200,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        onSelected: (_) {
          controller.setStatus(label == "All" ? "all" : label.toLowerCase());
        },
      ),
    );
  }
}
