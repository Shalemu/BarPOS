import 'package:barpos/core/bottom_nav_controller.dart';
import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/counter/CounterOrders_widget.dart';
import 'package:barpos/core/widgets/counter/myCounter_widget.dart';
import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterHomeScreen extends StatelessWidget {
  const CounterHomeScreen({super.key});

  String _getTitle(int index, CounterHomeController homeController) {
    switch (index) {
      case 0:
        final counter = homeController.selectedMyCounter.value;

        return counter == null ? "My Counters" : "Counter: ${counter.name}";

      case 1:
        return "History";

      case 2:
        return "POS";

      case 3:
        return "Cart";

      case 4:
        return "Profile";

      default:
        return "Counter POS";
    }
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();
    final homeController = Get.find<CounterHomeController>();

    final pages = [
  /// HOME (DYNAMIC)
  Obx(() {
    final controller = Get.find<CounterHomeController>();

    if (controller.selectedMyCounter.value == null) {
      return const MyCounterSelectionWidget();
    } else {
      return CounterOrdersWidget(); 
    }
  }),

  /// HISTORY
  const Center(child: Text("History (No data yet)")),

  /// POS
  const Center(child: Text("POS (Coming soon)")),

  /// CART
  const Center(child: Text("Cart (No data yet)")),

  /// PROFILE
  const ProfileScreen(),
];

    return Scaffold(
      /// APP BAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        child: Obx(() {
          final index = navController.currentIndex.value;

          return AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.primary,

            title: Text(
              _getTitle(index, homeController),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            actions: [
              /// RESET COUNTER
              if (index == 0 && homeController.selectedMyCounter.value != null)
                IconButton(
                  onPressed: () {
                    homeController.selectedMyCounter.value = null;
                  },
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                ),
            ],
          );
        }),
      ),

      /// BODY
      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        );
      }),

      /// PREMIUM BOTTOM NAV
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),

            child: BottomNavigationBar(
              currentIndex: navController.currentIndex.value,
              onTap: (index) {
                navController.changeTab(index);

                if (index == 0) {
                  final token = homeController.authProvider.accessToken.value;

                  if (token != null && token.isNotEmpty) {
                    homeController.loadMyCounters(token);
                  } else {
                    homeController.debugStatus.value = " No token found";
                    print(" NO TOKEN");
                  }
                }
              },

              type: BottomNavigationBarType.fixed,
              elevation: 0,

              backgroundColor: Colors.white,

              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey.shade500,

              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),

              unselectedLabelStyle: const TextStyle(fontSize: 11),

              items: const [
                /// HOME
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize_rounded),
                  label: "Home",
                ),

                /// HISTORY
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded),
                  label: "History",
                ),

                /// POS
                BottomNavigationBarItem(
                  icon: Icon(Icons.point_of_sale_rounded),
                  label: "POS",
                ),

                /// CART
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_checkout_rounded),
                  label: "Cart",
                ),

                /// PROFILE
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Profile",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
