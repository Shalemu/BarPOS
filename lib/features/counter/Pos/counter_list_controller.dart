import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/services/model/counters_model.dart';
import 'package:barpos/services/model/product_model.dart';
import 'package:barpos/services/counter/myCounter_service.dart';
import 'package:barpos/services/counter/product_service.dart';

class CounterListController extends GetxController {
  final MyCounterService _counterService = MyCounterService();
  final ProductService _productService = ProductService();

  late String token;


  var isLoadingCounters = false.obs;
  var counters = <CounterModel>[].obs;
  var searchCounter = ''.obs;
  var selectedCounter = Rxn<CounterModel>();

 
  var isLoadingProducts = false.obs;
  var products = <ProductModel>[].obs;

  var productSearch = ''.obs;
  var selectedCategory = 'All'.obs;
  var categories = <String>[].obs;

  var errorMessage = ''.obs;

 
  void init(String t) {
    token = t;
    loadCounters();
  }


  Future<void> loadCounters() async {
    try {
      isLoadingCounters.value = true;
      errorMessage.value = '';

      debugPrint("Loading counters...");

      final result = await _counterService.fetchMyCounters(token);

      final data = result.data ?? [];

      counters.assignAll(
        data.map((e) => CounterModel.fromJson(e)).toList(),
      );

      debugPrint("Counters loaded: ${counters.length}");
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("loadCounters error: $e");
    } finally {
      isLoadingCounters.value = false;
    }
  }

  
  void setCounterSearch(String value) {
    searchCounter.value = value;
  }

  List<CounterModel> get filteredCounters {
    final q = searchCounter.value.toLowerCase();

    if (q.isEmpty) return counters;

    return counters
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }


  void selectMyCounter(CounterModel counter) {
    debugPrint(" Counter selected: ${counter.name} (ID: ${counter.id})");

    selectedCounter.value = counter;

    debugPrint("selectedCounter updated → ${selectedCounter.value?.name}");

    loadProducts(counter.id);
  }

  
  Future<void> loadProducts(int counterId) async {
  try {
    isLoadingProducts.value = true;

    final result = await _productService.fetchCounterProducts(
      token,
      counterId,
    );

    products.assignAll(result);

    _generateCategories();

    _validateSelectedCategory(); 
  } catch (e, s) {
    errorMessage.value = e.toString();
  } finally {
    isLoadingProducts.value = false;
  }
}
void _validateSelectedCategory() {
  if (!categories.contains(selectedCategory.value)) {
    selectedCategory.value = 'All';
  }
}


  void _generateCategories() {
    final set = <String>{};

    for (var p in products) {
      if (p.category.isNotEmpty) {
        set.add(p.category);
      }
    }

    categories.assignAll(['All', ...set]);

    debugPrint("Categories: $categories");
  }

  void setProductSearch(String value) {
    productSearch.value = value;
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
  }

  List<ProductModel> get filteredProducts {
    final q = productSearch.value.toLowerCase();
    final cat = selectedCategory.value;

    return products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(q);
      final matchCategory = cat == 'All' || p.category == cat;

      return matchSearch && matchCategory;
    }).toList();
  }
}