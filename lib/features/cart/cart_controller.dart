import 'package:get/get.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  // Observable cart list
  final cartItems = <CartItem>[].obs;

  // Add item
  void addToCart(CartItem item) {
    final index = cartItems.indexWhere((e) => e.name == item.name);

    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  // Remove item
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  // Increase quantity
  void increaseQty(CartItem item) {
    item.quantity++;
    cartItems.refresh();
  }

  // Decrease quantity
  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      cartItems.remove(item);
    }
    cartItems.refresh();
  }

  // Total price
  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}