import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/app_search_bar.dart';
import 'package:barpos/core/widgets/dot_loader.dart';
import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCounterSelectionWidget extends StatelessWidget {
  const MyCounterSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterHomeController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GREETING
            Text(
              "Hi! ${controller.userName}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              "Welcome back... ",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            /// SEARCH
            AppSearchBar(
              hintText: "Search counters...",
              onChanged: controller.setCounterSearch,
            ),

            const SizedBox(height: 20),

            /// INFO CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Counter",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Choose a counter to Pick Order",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

           
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Counters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("View all", style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 12),

            /// GRID
            Obx(() {
              if (controller.isLoadingMyCounters.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: DotLoader()),
                );
              }

              if (controller.counters.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text("No counters available")),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.counters.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final counter = controller.counters[index];

                  return GestureDetector(
                    onTap: () async {
                      print(" COUNTER CLICKED: ${counter.name}");

                      await controller.selectCounter(counter);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.point_of_sale_rounded,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),

                              // BADGE
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "${counter.pendingOrdersCount}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // COUNTER NAME
                          Text(
                            counter.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // SUBTITLE
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                size: 15,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${counter.pendingOrdersCount} Pending Orders",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
