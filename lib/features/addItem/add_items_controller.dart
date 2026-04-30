import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barpos/services/model/order_item.dart';
import 'package:barpos/services/order_service.dart';
import 'package:barpos/services/product_service.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/counter_provider.dart';
import 'package:barpos/core/widgets/top_notification.dart';

class AddItemsController extends GetxController {
  final OrderService _service = OrderService();
  final ProductService _productService = ProductService();

  final isLoading = false.obs;

  final selectedItems = <OrderItem>[].obs;
  final products = <OrderItem>[].obs;

  final RxString productSearch = "".obs;

  late int orderId;
  late String orderRef;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      orderId = args['orderId'] ?? 0;
      orderRef = args['orderRef'] ?? '';

      final items = (args['items'] ?? []) as List;

      selectedItems.assignAll(
        items.map((item) {
          return OrderItem(
            id: item['itemId'],
            name: item['itemName'] ?? '',
            logo: item['itemLogo'] ?? '',
            price: (item['itemPrice'] as num? ?? 0).toDouble(),
            qty: item['itemQty'] ?? 1,
            category: item['itemCategory'] ?? '',
          );
        }).toList(),
      );

      fetchProducts();
    } else {
      _notify("Invalid order data", Colors.red, Icons.error_outline);
    }
  }


  Future<void> fetchProducts() async {
    final auth = Get.find<AuthProvider>();
    final counter = Get.find<CounterProvider>();

    final counterId = counter.selectedCounterId.value;

    print("SELECTED COUNTER ID: $counterId");

    if (counterId == null) {
      _notify("No counter selected", Colors.red, Icons.warning_amber);
      return;
    }

    try {
      final result = await _productService.fetchCounterProducts(
        auth.accessToken.value!,
        counterId,
      );

      products.assignAll(
        result.map((e) {
          return OrderItem(
            id: e.id,
            name: e.name,
            logo: e.logo,
            price: (e.price as num).toDouble(),
            qty: 1,
            category: e.category,
          );
        }).toList(),
      );

      print("PRODUCTS LOADED: ${products.length}");

      _notify("Products loaded", Colors.green, Icons.check_circle);
    } catch (e) {
      _notify("Failed to load products", Colors.red, Icons.error_outline);
    }
  }

  
  void setProductSearch(String value) {
    productSearch.value = value;
  }

  List<OrderItem> get filteredProducts {
    final q = productSearch.value.toLowerCase();

    if (q.isEmpty) return products;

    return products.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q);
    }).toList();
  }


void addItem(OrderItem item, int qty) {
  final index = selectedItems.indexWhere(
    (e) => e.uniqueId == item.uniqueId, 
  );

  if (index != -1) {
    selectedItems[index] =
        selectedItems[index].copyWith(qty: qty);
  } else {
    selectedItems.add(item.copyWith(qty: qty));
  }

  selectedItems.refresh();

  _notify("${item.name} added", Colors.green, Icons.add_circle);
}

  void removeItem(OrderItem item) {
    selectedItems.removeWhere(
       (e) => e.uniqueId == item.uniqueId, 
      );

    _notify("Item removed", Colors.orange, Icons.remove_circle);
  }

 
  Future<void> submit() async {
    final auth = Get.find<AuthProvider>();

    if (selectedItems.isEmpty) {
      _notify("No items selected", Colors.red, Icons.warning_amber);
      return;
    }

    try {
      isLoading.value = true;

      await _service.addItemsToOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
        items: selectedItems.map((e) => e.toJson()).toList(),
      );

      Get.back(result: true);

      _notify("Order updated successfully", Colors.green,
          Icons.check_circle);
    } catch (e) {
      _notify("Update failed", Colors.red, Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }


  void _notify(String message, Color color, IconData icon) {
    final context = Get.context;
    if (context == null) return;

    TopNotification.show(
      context,
      message: message,
      color: color,
      icon: icon,
      seconds: 5,
    );
  }
}