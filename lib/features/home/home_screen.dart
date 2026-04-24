import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/counter_items.dart';
import 'package:barpos/core/widgets/counter_select.dart';
import 'package:barpos/features/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barpos/features/home/bottom_nav_controller.dart';
import 'package:barpos/features/home/home_controller.dart';
import 'package:barpos/features/orders/orders_screen.dart';
import 'package:barpos/features/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();
    final homeController = Get.find<HomeController>();
    final cartController = homeController.cartController;

    final pages = [
      Obx(() {
        return homeController.selectedCounter.value == null
            ? CounterSelectionWidget()
            : CounterItemsWidget();
      }),

      CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      /// APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),

        title: Obx(() {
          final index = navController.currentIndex.value;

          if (index == 0) {
            final counter = homeController.selectedCounter.value;
            return Text(
              counter == null ? "Select Counter" : "Counter: $counter",
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            );
          }

          const titles = ["Home", "Cart", "Orders", "Profile"];

          return Text(
            titles[index],
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          );
        }),

        actions: [
          Obx(() {
            final index = navController.currentIndex.value;
            final counter = homeController.selectedCounter.value;

            if (index == 0 && counter != null) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                color: AppColors.white,
                onPressed: () {
                  homeController.selectedCounter.value = null;
                },
              );
            }

            return const SizedBox();
          }),
        ],
      ),

      /// BODY
      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        );
      }),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Obx(() {
        final count = cartController.cartCount;

        return BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,

          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            /// CART WITH BADGE
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),

                  if (count > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$count",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: "Cart",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Orders",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        );
      }),
    );
  }
}