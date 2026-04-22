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

    /// 🔹 Pages
    final pages = [
      /// HOME TAB
      Obx(() {
        return homeController.selectedCounter.value == null
            ? CounterSelectionWidget()
            : CounterItemsWidget();
      }),

      /// CART TAB
      CartScreen(),

      /// ORDERS TAB
      const OrdersScreen(),

      /// PROFILE TAB
      const ProfileScreen(),
    ];

    return Scaffold(
appBar: AppBar(
  backgroundColor: AppColors.primary,
  elevation: 0,
  centerTitle: true,

  iconTheme: const IconThemeData(
    color: AppColors.white, // icons color
  ),

  title: Obx(() {
    final index = navController.currentIndex.value;

    String title;

    if (index == 0) {
      final counter = homeController.selectedCounter.value;
      title = counter == null
          ? "Select Counter"
          : "Counter: $counter";
    } else if (index == 1) {
      title = "Cart";
    } else if (index == 2) {
      title = "Orders";
    } else {
      title = "Profile";
    }

    return Text(
      title,
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

      ///  BODY
      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        );
      }),

      /// BOTTOM NAV
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Orders",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
