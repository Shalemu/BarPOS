import 'package:barpos/provider/counter_provider.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/order_service.dart';

class OrdersController extends GetxController {
  final isLoading = false.obs;
  final OrderService _service = OrderService();
  final CounterProvider counterProvider = Get.find<CounterProvider>();

  final RxString searchQuery = "".obs;
  final RxString statusFilter = "all".obs;
  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();

  var orders = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void clearDateFilter() {
    fromDate.value = null;
    toDate.value = null;
    fetchOrders();
  }

  Future<String?> submitOrder({
  String? tableRef,
  required List<Map<String, dynamic>> items,
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

    await _service.submitOrder(
      token: auth.accessToken.value!,
      counterId: counterId,
      tableRef: cleanedTable, // now nullable
      items: items,
    );

    return null;
  } catch (e) {
    return e.toString();
  } finally {
    isLoading.value = false;
  }
}
  Future<void> fetchOrders() async {
    final auth = Get.find<AuthProvider>();

    try {
      isLoading.value = true;

      final hasDateFilter = fromDate.value != null || toDate.value != null;

      final result = await _service.fetchOrder(
        token: auth.accessToken.value!,
        fromDate: hasDateFilter
            ? fromDate.value?.toIso8601String().split("T").first
            : null,
        toDate: hasDateFilter
            ? toDate.value?.toIso8601String().split("T").first
            : null,
      );

      orders.assignAll(result);
    } catch (e) {
      print("FETCH ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(int orderId) async {
    final auth = Get.find<AuthProvider>();

    try {
      isLoading.value = true;

      print("CANCELING ORDER: $orderId");

      await _service.cancelOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
      );

      print("ORDER CANCELED SUCCESSFULLY");

      // refresh orders after cancel
      await fetchOrders();
    } catch (e) {
      print("CANCEL CONTROLLER ERROR");
      print("Reason: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItems({
    required int orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final auth = Get.find<AuthProvider>();

    try {
      isLoading.value = true;

      print("ADDING ITEMS TO ORDER: $orderId");
      print("ITEMS: $items");

      await _service.addItemsToOrder(
        token: auth.accessToken.value!,
        orderId: orderId,
        items: items,
      );

      print("ITEMS ADDED SUCCESSFULLY");

      await fetchOrders(); // refresh UI
    } catch (e) {
      print("ADD ITEMS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredOrders {
    final query = searchQuery.value.toLowerCase();
    final status = statusFilter.value.toLowerCase();

    return orders.where((order) {
      final orderStatus = (order['orderStatus'] ?? '').toString().toLowerCase();

      final table = (order['tableRef'] ?? '').toString().toLowerCase();
      final orderRef = (order['orderRef'] ?? '').toString().toLowerCase();

      final matchesStatus = status == "all" || orderStatus == status;

      final matchesSearch =
          query.isEmpty || table.contains(query) || orderRef.contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  void setSearch(String value) {
    searchQuery.value = value;
  }

  void setStatus(String status) {
    statusFilter.value = status;
  }
}
