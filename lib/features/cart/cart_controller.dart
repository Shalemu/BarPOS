import 'package:barpos/provider/counter_provider.dart';
import 'package:barpos/services/model/cart_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final CounterProvider counterProvider = Get.find<CounterProvider>();

  /// ADD TO CART
  String? addToCart(ProductModel product) {
  final counterId = counterProvider.selectedCounterId.value;

 
  if (counterId == null) {
    print("No counter selected");
    return "No counter selected";
  }

 
  final index = cartItems.indexWhere(
    (e) => e.id == product.id && e.counterId == counterId,
  );

  if (product.category.toLowerCase() == "product") {
    final currentQty = index != -1 ? cartItems[index].quantity : 0;

    if (currentQty >= product.availableQty) {
      print("Stock limit reached for ${product.name}");
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

    
        counterId: counterId,
      ),
    );
  }

  cartItems.refresh();

 
  print("ADDED TO CART:");
  print("Product: ${product.name}");
  print("Product ID: ${product.id}");
  print("Counter ID: $counterId");

  print("CURRENT CART:");
  for (var item in cartItems) {
    print(
      "Item -> ${item.name} | Qty: ${item.quantity} | Counter: ${item.counterId}",
    );
  }

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