import 'package:barpos/core/widgets/app_search_bar.dart';
import 'package:barpos/core/widgets/counter/orderList_widget/order_card_widget.dart';
import 'package:barpos/core/widgets/counter/orderList_widget/order_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/counter/home/home_controller.dart';

class CounterOrdersWidget extends StatelessWidget {
  const CounterOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterHomeController>();

    final filters = ["All", "pending", "processing", "completed", "cancelled"];

    final searchController = TextEditingController();
    final searchQuery = ''.obs;

    return Obx(() {
      final orders = controller.orders;


      final filteredOrders = orders.where((o) {
        final status = (o['order_status'] ?? '').toString().toLowerCase();
        final table = (o['table_ref'] ?? '').toString().toLowerCase();
        final ref = (o['order_ref'] ?? '').toString().toLowerCase();
        final createdBy = (o['created_by'] ?? '').toString().toLowerCase();

        final matchesCategory =
            controller.selectedCategory.value == "All" ||
            status == controller.selectedCategory.value;

        final query = searchQuery.value;

        final matchesSearch =
            query.isEmpty ||
            table.contains(query) ||
            ref.contains(query) ||
            createdBy.contains(query);

        return matchesCategory && matchesSearch;
      }).toList();

      /// SORT
      filteredOrders.sort((a, b) {
        final sa = OrderUiHelper.getStatusPriority(
          a['order_status'] ?? '',
        );
        final sb = OrderUiHelper.getStatusPriority(
          b['order_status'] ?? '',
        );
        return sa.compareTo(sb);
      });

      /// COUNTS
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
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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
                          color: selected
                              ? Colors.teal
                              : Colors.grey.shade200,
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

          
            AppSearchBar(
              hintText: "Search order, table, user...",
              controller: searchController,
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              },
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

                            return OrderCardWidget(
                              order: order,
                              controller: controller,
                            );
                          },
                        ),
            ),
          ],
        ),
      );
    });
  }

  // STATUS CARD
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
}