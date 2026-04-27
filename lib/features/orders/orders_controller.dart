import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/order_service.dart';

class OrdersController extends GetxController {
  final isLoading = false.obs;
  final OrderService _service = OrderService();

  var orders = <Map<String, dynamic>>[].obs;

  Future<String?> submitOrder({
    required String tableRef,
    required List<Map<String, dynamic>> items,
  }) async {
    final auth = Get.find<AuthProvider>();
    final counter = auth.selectedCounter.value;

    if (counter == null) {
      return "Please select counter first";
    }

    try {
      isLoading.value = true;

      await _service.submitOrder(
        token: auth.accessToken.value!,
        counterId: counter.id,
        tableRef: tableRef,
        items: items,
      );

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
