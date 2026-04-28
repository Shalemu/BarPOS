import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/order_service.dart';

class AddItemsController extends GetxController {
  final OrderService _service = OrderService();

  final isLoading = false.obs;
  final selectedItems = <Map<String, dynamic>>[].obs;

  late int orderId;
  Map<String, dynamic>? order;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      order = args;
      orderId = args['orderId'] ?? 0;

      // IMPORTANT: preload existing items from order
      final items = (args['items'] ?? []) as List;

      for (var item in items) {
        selectedItems.add({
          "itemId": item['itemId'],
          "itemCategory": item['itemCategory'] ?? "product",
          "itemQty": item['itemQty'] ?? 1,
          "itemName": item['itemName'],
        });
      }
    } else {
      throw Exception("AddItemsScreen requires full order Map");
    }
  }

  void addItem(int itemId, String category, int qty) {
    final index = selectedItems.indexWhere((e) => e["itemId"] == itemId);

    if (index >= 0) {
      selectedItems[index]["itemQty"] = qty;
      selectedItems.refresh();
    } else {
      selectedItems.add({
        "itemId": itemId,
        "itemCategory": category,
        "itemQty": qty,
      });
    }
  }

  void removeItem(int itemId) {
    selectedItems.removeWhere((e) => e["itemId"] == itemId);
  }

  Future<void> submit() async {
    final auth = Get.find<AuthProvider>();

    if (selectedItems.isEmpty) {
      Get.snackbar("Error", "No items selected");
      return;
    }

    try {
      isLoading.value = true;

      await _service.addItemsToOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
        items: selectedItems,
      );

      Get.back(result: true);

      Get.snackbar("Success", "Order updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}