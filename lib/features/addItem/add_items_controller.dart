import 'package:barpos/features/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barpos/services/model/order_item.dart';
import 'package:barpos/services/order_service.dart';
import 'package:barpos/services/product_service.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/counter_provider.dart';

class AddItemsController extends GetxController {
  final OrderService _service = OrderService();
  final ProductService _productService = ProductService();
  final HomeController homeController = Get.find<HomeController>();

  final isLoading = false.obs;

  final selectedItems = <OrderItem>[].obs;
  final products = <OrderItem>[].obs;

  final RxString productSearch = "".obs;

  final isFetchingProducts = false.obs;
  final isSubmitting = false.obs;

  // UI NOTIFICATION
  final RxString sheetMessage = "".obs;
  final RxBool showSheetMessage = false.obs;
  final Rx<Color> sheetMessageColor = Colors.green.obs;
  final Rx<IconData> sheetMessageIcon = Icons.check_circle.obs;

  late int orderId;
  late String orderRef;

  //  INIT
  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments;

    if (args is! Map<String, dynamic>) {
      _notify("Invalid order data", Colors.red, Icons.error);
      return;
    }

    orderId = args['orderId'] ?? 0;
    orderRef = args['orderRef'] ?? '';

    final counterProvider = Get.find<CounterProvider>();
    final counterId = counterProvider.selectedCounterId.value;

    if (counterId == null) {
      _notify("No counter selected", Colors.red, Icons.warning);
      return;
    }

    try {
     isFetchingProducts.value = true;


      if (homeController.products.isEmpty) {
        print("Loading products from HomeController...");
        await homeController.loadProducts(counterId);
      }

      await fetchProducts();

      final items = (args['items'] ?? []) as List<dynamic>;

      selectedItems.assignAll(
        items.map((item) {
          final product = homeController.products.firstWhereOrNull(
            (p) => p.id == item['itemId'],
          );

          final stock = product?.availableQty ?? 0;

          print("MAP ITEM: ${item['itemName']} → STOCK: $stock");

          return OrderItem(
            id: item['itemId'],
            name: item['itemName'] ?? '',
            logo: item['itemLogo'] ?? '',
            price: (item['itemPrice'] as num? ?? 0).toDouble(),
            qty: item['itemQty'] ?? 1,
            category: item['itemCategory'] ?? '',
            remainingQty: stock,
            volume: item['itemVolume'] ?? item['volume'] ?? '',
            
          );
        }).toList(),
      );
    } catch (e) {
      _notify("Initialization failed", Colors.red, Icons.error);
    } finally {
      isFetchingProducts.value = false;
    }
  }

  // FETCH PRODUCTS
  Future<void> fetchProducts() async {
    final auth = Get.find<AuthProvider>();
    final counter = Get.find<CounterProvider>();

    final counterId = counter.selectedCounterId.value;

    if (counterId == null) {
      _notify("No counter selected", Colors.red, Icons.warning);
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
            remainingQty: e.availableQty,
            volume: e.volume,
          );
        }).toList(),
      );

      _notify("Products loaded", Colors.green, Icons.check_circle);
    } catch (e) {
      _notify("Failed to load products", Colors.red, Icons.error);
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

  bool addItem(OrderItem item) {
    final index = selectedItems.indexWhere((e) => e.uniqueId == item.uniqueId);

    final existingQty = index != -1 ? selectedItems[index].qty : 0;
    final newQty = existingQty + 1;

    print("Item: ${item.name}");
    print("Category: ${item.category}");
    print("Current Qty: $existingQty");
    print("Trying Qty: $newQty");

    if (item.category.toLowerCase() == "product") {
      final product = homeController.products.firstWhereOrNull(
        (p) => p.id == item.id,
      );

      final stock = product?.availableQty ?? 0;

      print("Stock Available: $stock");

      if (stock <= 0) {
        print("OUT OF STOCK");
        _notify("Out of stock", Colors.red, Icons.warning_amber);
        return false;
      }

      if (newQty > stock) {
        print("LIMIT EXCEEDED");
        _notify(
          "Only $stock ${item.name} available",
          Colors.red,
          Icons.warning_amber,
        );
        return false;
      }
    }

    if (index != -1) {
      selectedItems[index] = selectedItems[index].copyWith(qty: newQty);
    } else {
      selectedItems.add(item.copyWith(qty: 1));
    }

    selectedItems.refresh();

    print("ITEM ADDED SUCCESS");

    _notify("${item.name} added", Colors.green, Icons.check_circle);

    return true;
  }

  void decreaseItem(OrderItem item) {
    final index = selectedItems.indexWhere((e) => e.uniqueId == item.uniqueId);

    if (index == -1) return;

    final qty = selectedItems[index].qty;

    if (qty <= 1) {
      selectedItems.removeAt(index);
    } else {
      selectedItems[index] = selectedItems[index].copyWith(qty: qty - 1);
    }

    selectedItems.refresh();
  }

  //REMOVE
  void removeItem(OrderItem item) {
    selectedItems.removeWhere((e) => e.uniqueId == item.uniqueId);

    selectedItems.refresh();

    _notify("Item removed", Colors.orange, Icons.remove_circle);
  }

  // SUBMIT
  Future<void> submit() async {
    final auth = Get.find<AuthProvider>();

    if (selectedItems.isEmpty) {
      _notify("No items selected", Colors.red, Icons.warning);
      return;
    }

    try {
      isSubmitting.value = true;

      final payload = selectedItems.map((e) {
        return {
          "itemId": e.id,
          "itemName": e.name,
          "itemCategory": e.category,
          "itemQty": e.qty,
          "itemPrice": e.price,
          "remainingQty": e.remainingQty,
        };
      }).toList();

      for (var i in payload) {
        print(i);
      }

      await _service.addItemsToOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
        items: payload,
      );

      Get.back(result: true);

      _notify("Order updated successfully", Colors.green, Icons.check_circle);
    } catch (e) {
      _notify("Update failed", Colors.red, Icons.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  // NOTIFICATION
  void _notify(String msg, Color color, IconData icon) {
    sheetMessage.value = msg;
    sheetMessageColor.value = color;
    sheetMessageIcon.value = icon;
    showSheetMessage.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      showSheetMessage.value = false;
    });
  }

  void showInlineNotification(String message, Color color, IconData icon) {
    _notify(message, color, icon);
  }
}
