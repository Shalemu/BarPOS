import 'package:barpos/core/bottom_nav_controller.dart';
import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/counter/Pos/Mycounter_widget.dart';
import 'package:barpos/core/widgets/counter/Pos/item_list_widget.dart';
import 'package:barpos/core/widgets/counter/myCounter_widget.dart';
import 'package:barpos/core/widgets/counter/orderList_widget/CounterOrders_widget.dart';
import 'package:barpos/features/counter/Pos/counter_list_controller.dart';
import 'package:barpos/features/counter/cart/cart_controller.dart';
import 'package:barpos/features/counter/cart/cart_screen.dart' show CartScreen;
import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterHomeScreen extends StatefulWidget {
  const CounterHomeScreen({super.key});

  @override
  State<CounterHomeScreen> createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  final navController = Get.find<BottomNavController>();
  final homeController = Get.find<CounterHomeController>();
  final counterController = Get.find<CounterListController>();
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();

    final token = homeController.authProvider.accessToken.value ?? '';

    if (token.isNotEmpty) {
      counterController.init(token);
    }

    ever(navController.currentIndex, (index) {
      debugPrint("TAB CHANGED → $index");

      if (index == 1) {
        debugPrint(" POS TAB OPENED");

        debugPrint(
          " Selected Counter: ${counterController.selectedCounter.value?.name}",
        );

        debugPrint("➡ Products Count: ${counterController.products.length}");
      }
    });
  }

  String _getTitle(int index, CounterHomeController homeController) {
    switch (index) {
      case 0:
        final counter = homeController.selectedMyCounter.value;
        return counter == null ? "My Counters" : counter.name;

      case 1:
        return "POS";

      case 2:
        return "Cart";

      case 3:
        return "Profile";

      default:
        return "Counter POS";
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Obx(() {
        if (homeController.selectedMyCounter.value == null) {
          return MyCounterSelectionWidget();
        } else {
          return CounterOrdersWidget();
        }
      }),

      Obx(() {
        final controller = Get.find<CounterListController>();

        debugPrint(
          "POS UI → selectedCounter = ${controller.selectedCounter.value?.name}",
        );

        if (controller.selectedCounter.value == null) {
          debugPrint("SHOW COUNTER LIST");
          return CounterSelectionWidget();
        }

        debugPrint("SHOW PRODUCTS SCREEN");
        return CounterItemsWidget();
      }),

     CartScreen(),

      const ProfileScreen(),
    ];

    return Scaffold(
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
          );
        }),
      ),

      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        );
      }),

      bottomNavigationBar: Obx(() {
        final count = cartController.cartCount;
        return BottomNavigationBar(
          currentIndex: navController.currentIndex.value,

          onTap: (index) {
            debugPrint(" BottomNav clicked: $index");

            navController.changeTab(index);

            /// POS TAB
            if (index == 1) {
              debugPrint(" POS TAB CLICKED");
            }

            /// HOME TAB (reload counters)
            if (index == 0) {
              final token = homeController.authProvider.accessToken.value ?? '';

              if (token.isEmpty) {
                debugPrint(" NO TOKEN");
                return;
              }

              homeController.loadMyCounters(token);
            }
          },

          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_rounded),
              label: "POS",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart),

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
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        );
      }),
    );
  }
}
