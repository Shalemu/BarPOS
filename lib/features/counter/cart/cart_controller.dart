import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/waiter/counter_provider.dart';
import 'package:barpos/services/counter/cart_service.dart';
import 'package:barpos/services/model/cart_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final CounterProvider counterProvider = Get.find<CounterProvider>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
    final CartService _service = CartService();

  // ADD TO CART
  String? addToCart(BuildContext context, ProductModel product) {
    final counterId = counterProvider.selectedCounterId.value;

    if (counterId == null) {
      TopNotification.show(
        context,
        message: "No counter selected",
        color: Colors.red,
        icon: Icons.error,
        seconds: 4,
      );
      return "No counter selected";
    }

    final index = cartItems.indexWhere(
      (e) => e.uniqueId == product.uniqueId && e.counterId == counterId,
    );

    final isStockLimited = product.category.toLowerCase() == "product";

    if (isStockLimited) {
      final currentQty = index != -1 ? cartItems[index].quantity : 0;

      if (currentQty >= product.availableQty) {
        TopNotification.show(
          context,
          message: "Only ${product.availableQty} items available",
          color: Colors.red,
          icon: Icons.warning,
          seconds: 4,
        );
        return "Stock limit reached";
      }
    }

    if (index != -1) {
      final item = cartItems[index];

      if (product.category.toLowerCase() == "product") {
        if (item.quantity >= product.availableQty) {
          TopNotification.show(
            context,
            message: "Only ${product.availableQty} items available",
            color: Colors.red,
            icon: Icons.warning,
            seconds: 4,
          );
          return "Stock limit reached";
        }
      }

      item.quantity++;
      item.remainingQty = product.availableQty - item.quantity;
    } else {
      cartItems.add(
        CartItem(
          uniqueId: product.uniqueId,
          id: product.id,
          name: product.name,
          category: product.category,
          logo: product.logo,
          price: product.price.toDouble(),
          volume: product.volume,
          counterId: counterId,

          quantity: 1,
          remainingQty: product.availableQty - 1,
        ),
      );
    }
    cartItems.refresh();

    TopNotification.show(
      context,
      message: "${product.name} added to cart",
      color: Colors.green,
      icon: Icons.check_circle,
      seconds: 4,
    );

    return null;
  }

  // INCREASE
  String? increaseQty(BuildContext context, String uniqueId) {
  final index = cartItems.indexWhere((e) => e.uniqueId == uniqueId);

  if (index == -1) return null;

  final item = cartItems[index];

  final isStockLimited = item.category.toLowerCase() == "product";

  //  product validation
  if (isStockLimited) {
    if (item.remainingQty <= 0) {
      TopNotification.show(
        context,
        message: "Stock limit reached",
        color: Colors.red,
        icon: Icons.warning,
        seconds: 4,
      );
      return "Stock limit";
    }

    item.remainingQty = item.remainingQty - 1;
  }


  item.quantity++;

  cartItems.refresh();
  return null;
}
  // DECREASE
  void decreaseQty(BuildContext context, String uniqueId) {
    final index = cartItems.indexWhere((e) => e.uniqueId == uniqueId);

    if (index == -1) return;

    final item = cartItems[index];

    if (item.quantity > 1) {
      item.quantity++;
      item.remainingQty = item.remainingQty + 1;
    } else {
      cartItems.removeAt(index);

      TopNotification.show(
        context,
        message: "${item.name} removed",
        color: Colors.orange,
        icon: Icons.remove_circle,
        seconds: 4,
      );
    }

    cartItems.refresh();
  }

  // TOTAL
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    cartItems.clear();
  }

 Future<String?> submitOrder({
  String? tableRef,
  required List<Map<String, dynamic>> items,
  Map<String, dynamic>? payments, 
}) async {
  final auth = Get.find<AuthProvider>();
  final counterId = counterProvider.selectedCounterId.value;

  if (counterId == null) {
    return "Please select counter first";
  }

  try {
    isLoading.value = true;

    final cleanedTable =
        (tableRef == null || tableRef.trim().isEmpty)
            ? null
            : tableRef.trim();

    final response = await _service.submitOrder(
      token: auth.accessToken.value!,
      counterId: counterId,
      tableRef: cleanedTable,
      items: items,
      payments: payments, 
    );


    if (response.isSuccess) {
      return null; // success
    } else {
      return response.message; // error message
    }
  } catch (e) {
    print("SUBMIT ERROR: $e");
    return e.toString();
  } finally {
    isLoading.value = false;
  }
}
}
