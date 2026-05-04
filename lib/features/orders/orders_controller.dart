import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/counter_provider.dart';
import 'package:barpos/services/order_service.dart';

class OrdersController extends GetxController {
  final OrderService _service = OrderService();
  final CounterProvider counterProvider = Get.find<CounterProvider>();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final RxString searchQuery = "".obs;
  final RxString statusFilter = "all".obs;

  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();

  final orders = <Map<String, dynamic>>[].obs;

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        loadMoreOrders();
      }
    });

    fetchOrders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }


  // FETCH ORDERS

  Future<void> fetchOrders({bool isRefresh = false}) async {
    final auth = Get.find<AuthProvider>();

    try {
      if (isRefresh) {
        currentPage = 1;
        hasMore = true;
        orders.clear();

        searchQuery.value = "";
        statusFilter.value = "all";
      }

      isLoading.value = true;

      final hasDateFilter = fromDate.value != null || toDate.value != null;

      final result = await _service.fetchOrder(
        token: auth.accessToken.value!,
        page: currentPage,
        fromDate: hasDateFilter
            ? fromDate.value?.toIso8601String().split("T").first
            : null,
        toDate: hasDateFilter
            ? toDate.value?.toIso8601String().split("T").first
            : null,
      );

      orders.assignAll(result);

      print("========== ORDERS LOADED ==========");
      print("Total Orders: ${result.length}");

      for (final order in result) {
        print("ORDER #${order['orderRef']}");
        final items = order['items'] ?? [];

        for (final item in items) {
          print("  Item: ${item['itemName']}");
          print("  Qty: ${item['itemQty']}");
          print("  Category: ${item['itemCategory']}");
        }
      }

      if (result.length < 5) hasMore = false;
    } catch (e) {
      print("FETCH ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // LOAD MORE

  Future<void> loadMoreOrders() async {
    if (!hasMore || isLoadingMore.value) return;

    final auth = Get.find<AuthProvider>();

    try {
      isLoadingMore.value = true;
      currentPage++;

      final hasDateFilter = fromDate.value != null || toDate.value != null;

      final result = await _service.fetchOrder(
        token: auth.accessToken.value!,
        page: currentPage,
        fromDate: hasDateFilter
            ? fromDate.value?.toIso8601String().split("T").first
            : null,
        toDate: hasDateFilter
            ? toDate.value?.toIso8601String().split("T").first
            : null,
      );

      if (result.isEmpty) {
        hasMore = false;
      } else {
        orders.addAll(result);
      }
    } catch (e) {
      print("LOAD MORE ERROR: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

 
  // FILTER
 
  void clearDateFilter() {
    fromDate.value = null;
    toDate.value = null;
    fetchOrders(isRefresh: true);
  }

  void setSearch(String value) {
    searchQuery.value = value;
  }

  void setStatus(String status) {
    statusFilter.value = status;
    fetchOrders(isRefresh: true);
  }

  List<Map<String, dynamic>> get filteredOrders {
    final query = searchQuery.value.toLowerCase();
    final status = statusFilter.value.toLowerCase();

    return orders.where((order) {
      final orderStatus =
          (order['orderStatus'] ?? '').toString().toLowerCase();
      final table = (order['tableRef'] ?? '').toString().toLowerCase();
      final orderRef = (order['orderRef'] ?? '').toString().toLowerCase();

      final matchesStatus = status == "all" || orderStatus == status;

      final matchesSearch =
          query.isEmpty || table.contains(query) || orderRef.contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

 
  // SUBMIT ORDER

  Future<String?> submitOrder({
    String? tableRef,
    required List<Map<String, dynamic>> items,
  }) async {
    final auth = Get.find<AuthProvider>();
    final counterId = counterProvider.selectedCounterId.value;

    if (counterId == null) {
      print("No counter selected");
      return "Please select counter first";
    }

    try {
      isLoading.value = true;

      final cleanedTable =
          (tableRef == null || tableRef.trim().isEmpty)
              ? null
              : tableRef.trim();

      print("========== SUBMIT ORDER ==========");
      print("Table: $cleanedTable");
      print("Counter ID: $counterId");
      print("Items Count: ${items.length}");

      for (final item in items) {
        print("Item ID: ${item['itemId']}");
        print("Category: ${item['itemCategory']}");
        print("Qty: ${item['itemQty']}");
        print("Remaining Stock: ${item['stock']?['remaining']}");
        print("Initial Stock: ${item['stock']?['initial']}");
      }

      await _service.submitOrder(
        token: auth.accessToken.value!,
        counterId: counterId,
        tableRef: cleanedTable,
        items: items,
      );

      await fetchOrders(isRefresh: true);

      return null;
    } catch (e) {
      print("SUBMIT ERROR: $e");
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  // CANCEL ORDER

  Future<void> cancelOrder(int orderId) async {
    final auth = Get.find<AuthProvider>();

    try {
      isLoading.value = true;

      await _service.cancelOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
      );

      await fetchOrders(isRefresh: true);
    } catch (e) {
      print("CANCEL ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

 
  // ADD ITEMS

  Future<void> addItems({
    required int orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final auth = Get.find<AuthProvider>();

    try {
      isLoading.value = true;

      print("========== ADD ITEMS ==========");
      print("Order ID: $orderId");

      for (final item in items) {
        print("Item: ${item['itemName']}");
        print("Qty: ${item['itemQty']}");
      }

      await _service.addItemsToOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
        items: items,
      );

      await fetchOrders(isRefresh: true);
    } catch (e) {
      print("ADD ITEMS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}