import 'package:get/get.dart';
import 'package:barpos/features/waiter/orders/orders_controller.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final List<String> permissions;

  BottomNavController({required this.permissions});

  bool get isCounter => permissions.contains('order.pick');

  bool get isWaiter =>
      permissions.contains('order.create') ||
      permissions.contains('pos');

  void changeTab(int index) {
    currentIndex.value = index;

    /// HISTORY TAB
    if (index == 1) {
      print("========== HISTORY TAB ==========");
      return;
    }

    /// POS TAB
    if (index == 2) {
      print("========== POS TAB ==========");

      final controller = Get.isRegistered<OrdersController>()
          ? Get.find<OrdersController>()
          : null;

      if (controller == null) {
        print("OrdersController NOT REGISTERED");
        return;
      }

      controller.fetchOrders(isRefresh: true).then((_) {
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
            print("---------- ITEM ----------");
            print("Name: ${item['itemName']}");
            print("ID: ${item['itemId']}");
            print("Qty Ordered: ${item['itemQty']}");
          }
        }
      }).catchError((e) {
        print("ORDERS FETCH FAILED");
        print("Reason: $e");
      });
    }
  }
}