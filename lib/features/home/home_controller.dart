import 'package:barpos/features/cart/cart_controller.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/counter_provider.dart';
import 'package:barpos/services/counter_service.dart';
import 'package:barpos/services/model/counters_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:barpos/services/product_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  // DATA

  var counters = <CounterModel>[].obs;
  var products = <ProductModel>[].obs;

  var selectedCounter = Rxn<CounterModel>();

  var isLoadingProducts = false.obs;
  var isLoadingCounters = false.obs;

  var selectedCategory = "All".obs;
  var searchQuery = "".obs;

  var orders = <Map<String, dynamic>>[].obs;
  var isLoadingOrders = false.obs;

  // DEPENDENCIES

  final CounterService _counterService = CounterService();
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final CartController cartController = Get.find<CartController>();
  final CounterProvider counterProvider = Get.find<CounterProvider>();


  // USER INFO

  String get userName =>
      authProvider.user.value?.firstName ?? "User";

 
  // INIT
 
  @override
  void onInit() {
    super.onInit();

    ever(authProvider.accessToken, (token) {
      if (token != null && token.isNotEmpty) {
        loadCounters(token);
      }
    });

    final token = authProvider.accessToken.value;
    if (token != null && token.isNotEmpty) {
      loadCounters(token);
    }
  }


  // LOAD COUNTERS

  Future<void> loadCounters(String token) async {
    try {
      isLoadingCounters.value = true;

      final response = await _counterService.fetchCounters(token);

      if (response.isSuccess) {
        counters.value = (response.data as List)
            .map((e) => CounterModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      _safeSnackbar("Error", e.toString());
    } finally {
      isLoadingCounters.value = false;
    }
  }

  
  // LOAD PRODUCTS
 
Future<void> loadProducts([int? counterId]) async {
  try {
    isLoadingProducts.value = true;

    final token = authProvider.accessToken.value;
    if (token == null || token.isEmpty) return;

    final id = counterId ?? counterProvider.selectedCounterId.value;

   
    print("PARAM COUNTER ID: $counterId");
    print("PROVIDER COUNTER ID: ${counterProvider.selectedCounterId.value}");
    print("FINAL USED ID: $id");

    if (id == null) {
      _safeSnackbar("Error", "No counter selected");
      return;
    }

    final result = await ProductService().fetchCounterProducts(
      token,
      id,
    );

    products.value = result;

    selectedCategory.value = "All";
    searchQuery.value = "";
  } catch (e) {
    _safeSnackbar("Error", e.toString());
  } finally {
    isLoadingProducts.value = false;
  }
}

 
  // CATEGORIES (DYNAMIC)
 
  List<String> get categories {
    final set = products.map((e) => e.category).toSet().toList();
    return ["All", ...set];
  }

  
  // FILTERED PRODUCTS
  
  List<ProductModel> get filteredProducts {
    return products.where((product) {
      
      final matchCategory = selectedCategory.value == "All"
          ? true
          : product.category.toLowerCase().trim() ==
              selectedCategory.value.toLowerCase().trim();

      
      final query = searchQuery.value.toLowerCase().trim();
      final name = product.name.toLowerCase();

      final matchSearch = query.isEmpty
          ? true
          : name.contains(query) || name.startsWith(query);

      return matchCategory && matchSearch;
    }).toList();
  }

  void changeCategory(String category) {
  selectedCategory.value = category;
  products.refresh(); 
}

 
  //SELECT COUNTER
  
  void selectCounter(CounterModel counter) {
    selectedCounter.value = counter;

     counterProvider.setCounter(counter);
  }

 
  // SNACKBAR SAFE
 
  void _safeSnackbar(String title, String message) {
    if (Get.context != null) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(title, message);
      });
    }
  }

  
  // CART QUANTITY SYSTEM

  var quantities = <int, int>{}.obs;

  int getQty(int id) => quantities[id] ?? 0;

  void increaseQty(int id) {
    quantities[id] = getQty(id) + 1;
  }

  void decreaseQty(int id) {
    final current = getQty(id);
    if (current > 0) {
      quantities[id] = current - 1;
    }
  }

  void setQty(int id, int value) {
    quantities[id] = value < 0 ? 0 : value;
  }
}