import 'package:barpos/provider/counter_provider.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/order_service.dart';

class OrdersController extends GetxController {
  final isLoading = false.obs;
  final OrderService _service = OrderService();
  final CounterProvider counterProvider = Get.find<CounterProvider>();

  var orders = <Map<String, dynamic>>[].obs;
 @override
void onInit() {
  super.onInit();
  fetchOrders();
}

 Future<String?> submitOrder({
  required String tableRef,
  required List<Map<String, dynamic>> items,
}) async {
  final auth = Get.find<AuthProvider>();


  final counterId = counterProvider.selectedCounterId.value;

  if (counterId == null) {
    print("No counter selected at order time");
    return "Please select counter first";
  }

  try {
    isLoading.value = true;


    print("SUBMITTING ORDER");
    print("Counter ID: $counterId");
    print("Table: $tableRef");
    print("Items: $items");

    await _service.submitOrder(
      token: auth.accessToken.value!,
      counterId: counterId, 
      tableRef: tableRef,
      items: items,
    );

    return null;
  } catch (e) {
    print("ORDER ERROR: $e");
    return e.toString();
  } finally {
    isLoading.value = false;
  }
}

Future<void> fetchOrders() async {
  final auth = Get.find<AuthProvider>();

  print("FETCH ORDERS STARTED");

  try {
    isLoading.value = true;

    final result = await _service.fetchOrder(
      token: auth.accessToken.value!,
    );

    print("API SUCCESS");
    print(" RESULT: $result");

    orders.assignAll(result);

    print(" ORDERS COUNT: ${orders.length}");
  } catch (e) {
    print("FETCH ERROR");
    print("Reason: $e");
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
}
