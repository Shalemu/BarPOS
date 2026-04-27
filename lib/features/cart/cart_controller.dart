import 'package:barpos/services/model/cart_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  /// ADD TO CART
  String? addToCart(ProductModel product) {
    final index = cartItems.indexWhere((e) => e.id == product.id);

    if (product.category.toLowerCase() == "product") {
      final currentQty = index != -1 ? cartItems[index].quantity : 0;

      if (currentQty >= product.availableQty) {
        return "Only ${product.availableQty} items available";
      }
    }

    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(
        CartItem(
          id: product.id,
          name: product.name,
          category: product.category,
          logo: product.logo,
          price: product.price.toDouble(),
          volume: product.volume,
        ),
      );
    }

    cartItems.refresh();
    return null;
  }

  /// INCREASE QTY
  String? increaseQty(int productId, ProductModel product) {
    final index = cartItems.indexWhere((e) => e.id == productId);
    if (index == -1) return null;

    final item = cartItems[index];

    if (product.category.toLowerCase() == "product") {
      if (item.quantity >= product.availableQty) {
        return "Only ${product.availableQty} items available";
      }
    }

    item.quantity++;
    cartItems.refresh();
    return null;
  }

  /// DECREASE QTY
  void decreaseQty(int productId) {
    final index = cartItems.indexWhere((e) => e.id == productId);

    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
      }
      cartItems.refresh();
    }
  }

  /// TOTAL PRICE
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  /// CART COUNT
  int get cartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// CLEAR CART
  void clearCart() {
    cartItems.clear();
  }

  
}