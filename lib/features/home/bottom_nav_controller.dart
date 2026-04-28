import 'package:get/get.dart';
import 'package:barpos/features/orders/orders_controller.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  currentIndex.value = index;

  if (index == 2) {
    print("ORDERS TAB CLICKED");

    final controller = Get.find<OrdersController>();

    controller.fetchOrders().then((_) {
      if (controller.orders.isEmpty) {
        print("NO ORDERS FOUND");
      } else {
        print("ORDERS LOADED");
        print("COUNT: ${controller.orders.length}");
      }
    }).catchError((e) {
      print("ORDERS FETCH FAILED");
      print("Reason: $e");
    });
  }
}
  }
