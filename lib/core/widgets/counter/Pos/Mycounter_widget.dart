import 'package:barpos/core/bottom_nav_controller.dart';
import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/app_search_bar.dart';
import 'package:barpos/core/widgets/dot_loader.dart';
import 'package:barpos/features/counter/Pos/counter_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterSelectionWidget extends StatelessWidget {
  const CounterSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterListController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Counter",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Choose a counter to start selling",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),

            const SizedBox(height: 18),

        
            AppSearchBar(
              hintText: "Search counters...",
              onChanged: controller.setCounterSearch,
            ),

            const SizedBox(height: 20),

    
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.10), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available Counters",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Select a counter to start POS session",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

       
            Expanded(
              child: Obx(() {
                
                if (controller.isLoadingCounters.value) {
                  return const Center(child: DotLoader());
                }

                final list = controller.filteredCounters;

             
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      "No counters found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

               
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final counter = list[index];

                    return GestureDetector(
                      onTap: () {
                        final controller = Get.find<CounterListController>();

                        debugPrint("Counter tapped: ${counter.name}");

                        controller.selectMyCounter(counter);

                        Get.find<BottomNavController>().changeTab(1);
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.point_of_sale_rounded,
                                color: AppColors.primary,
                              ),
                            ),

                            const Spacer(),

                            // ================= NAME =================
                            Text(
                              counter.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // ================= SUBTITLE =================
                            Text(
                              "Tap to open POS",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
