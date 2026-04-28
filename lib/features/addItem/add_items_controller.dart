import 'package:barpos/services/model/order_item.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/order_service.dart';

class AddItemsController extends GetxController {
  final OrderService _service = OrderService();

  final isLoading = false.obs;
  final selectedItems = <OrderItem>[].obs;

  late int orderId;
  Map<String, dynamic>? order;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      order = args;
      orderId = args['orderId'] ?? 0;

      /// PRELOAD EXISTING ITEMS
      final items = (args['items'] ?? []) as List;

      for (var item in items) {
        selectedItems.add(
          OrderItem(
            id: item['itemId'],
            name: item['itemName'] ?? '',
            logo: item['itemLogo'] ?? '',
            price: (item['itemPrice'] ?? 0).toDouble(),
            qty: item['itemQty'] ?? 1,
            category: item['itemCategory'] ?? 'product',
          ),
        );
      }
    } else {
      throw Exception("AddItemsScreen requires full order Map");
    }
  }

  /// ADD / UPDATE ITEM
  void addItem(OrderItem item, int qty) {
    final index = selectedItems.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      selectedItems[index] = selectedItems[index].copyWith(qty: qty);
    } else {
      selectedItems.add(item.copyWith(qty: qty));
    }

    selectedItems.refresh();
  }

  /// REMOVE ITEM
  void removeItem(int itemId) {
    selectedItems.removeWhere((e) => e.id == itemId);
  }

  /// SUBMIT ORDER
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

        /// IMPORTANT: convert model -> JSON
        items: selectedItems.map((e) => e.toJson()).toList(),
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
