import 'package:barpos/features/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:barpos/features/orders/orders_controller.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;
  final home = Get.find<HomeController>();

  void changeTab(int index) {
    currentIndex.value = index;

    if (index == 2) {
      print("========== ORDERS TAB CLICKED ==========");

      final controller = Get.find<OrdersController>();

      controller
          .fetchOrders(isRefresh: true)
          .then((_) {
            if (controller.orders.isEmpty) {
              print("NO ORDERS FOUND");
              return;
            }

            print("ORDERS LOADED: ${controller.orders.length}");

            for (final order in controller.orders) {
              print("\n========== ORDER ==========");
              print("Order Ref: ${order['orderRef']}");
              print("Order ID: ${order['orderId']}");

              final items = order['items'] ?? [];

              for (final item in items) {
                final productId = item['itemId'];
                final availableQty = home.getAvailableStock(productId);

                print("---------- ITEM ----------");
                print("Name: ${item['itemName']}");
                print("ID: $productId");
                print("Qty Ordered: ${item['itemQty']}");
                print("Available Stock: $availableQty");
              }
            }
          })
          .catchError((e) {
            print("ORDERS FETCH FAILED");
            print("Reason: $e");
          });
    }
  }
}
