import 'package:barpos/features/cart/cart_controller.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/counter_service.dart';
import 'package:barpos/services/model/counters_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:barpos/services/product_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var counters = <CounterModel>[].obs;
  var selectedCounter = Rxn<CounterModel>();
  var selectedCategory = 0.obs;
  var products = <ProductModel>[].obs;
  var isLoadingProducts = false.obs;
  var isLoadingCounters = false.obs;

  final CounterService _counterService = CounterService();
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();

    ever(authProvider.accessToken, (token) {
      if (token != null && token.isNotEmpty) {
        print("Token available → loading counters");
        loadCounters(token);
      }
    });

    final existingToken = authProvider.accessToken.value;
    if (existingToken != null && existingToken.isNotEmpty) {
      loadCounters(existingToken);
    }
  }

  Future<void> loadCounters(String token) async {
  try {
    isLoadingCounters.value = true;

    print("========== LOAD COUNTERS START ==========");

    final response = await _counterService.fetchCounters(token);

    if (response.isSuccess) {
      counters.value = (response.data as List)
          .map((e) => CounterModel.fromJson(e))
          .toList();
    }

    print("========== LOAD COUNTERS END ==========");
  } catch (e) {
    _safeSnackbar("Error", e.toString());
  } finally {
    isLoadingCounters.value = false;
  }
}

 Future<void> loadProducts(int counterId) async {
  try {
    isLoadingProducts.value = true;

    final token = authProvider.accessToken.value;

    if (token == null) return;

    final result = await ProductService()
        .fetchCounterProducts(token, counterId);

    products.value = result;
  } catch (e) {
    _safeSnackbar("Error", e.toString());
  } finally {
    isLoadingProducts.value = false;
  }
}

  void _safeSnackbar(String title, String message) {
    if (Get.context != null) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(title, message);
      });
    }
  }

  void selectCounter(CounterModel counter) {
    selectedCounter.value = counter;
  }

  var quantities = <int, int>{}.obs;

  int getQty(int index) => quantities[index] ?? 0;

  void increaseQty(int index) {
    quantities[index] = getQty(index) + 1;
  }

  void decreaseQty(int index) {
    final current = getQty(index);
    if (current > 0) {
      quantities[index] = current - 1;
    }
  }

  void setQty(int index, int value) {
    quantities[index] = value < 0 ? 0 : value;
  }
}
