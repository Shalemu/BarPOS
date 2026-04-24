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

      await Future.delayed(const Duration(seconds: 1));

      // EMPTY by default (no fake data)
      orders.clear();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}