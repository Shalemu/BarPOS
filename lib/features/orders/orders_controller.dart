import 'package:get/get.dart';

class OrdersController extends GetxController {
  var isLoading = false.obs;

  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      isLoading.value = true;

      // TODO: replace with API call later
      await Future.delayed(const Duration(seconds: 1));

      orders.value = [
        {
          "id": 1,
          "name": "Order #1001",
          "status": "Pending",
        },
        {
          "id": 2,
          "name": "Order #1002",
          "status": "Completed",
        },
      ];
    } finally {
      isLoading.value = false;
    }
  }
}