import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterSelectionWidget extends StatelessWidget {
  const CounterSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //GREETING
            const Text(
              "Hi Shadrack!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: const [
                Text("Welcome back", style: TextStyle(color: Colors.grey)),
                SizedBox(width: 6),
                Icon(Icons.waving_hand, size: 18, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 20),

            /// SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.grayshade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search counters...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ADS / BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Select your counter to start selling",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.store, size: 40, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //SECTION TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Available Counters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("view all", style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 12),

            //COUNTER CARDS
            Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.counters.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final counter = controller.counters[index];

                  return GestureDetector(
                    onTap: () {
                      controller.selectCounter(counter);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ICON
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.local_bar),
                          ),

                          const Spacer(),

                          /// COUNTER NAME
                          Text(
                            counter,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          /// BAR NAME / EXTRA INFO
                          const Text(
                            "Main Bar",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
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
