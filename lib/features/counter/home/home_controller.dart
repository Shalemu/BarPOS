import 'package:barpos/core/utils/delay_helper.dart';
import 'package:barpos/provider/waiter/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/counter/myCounter_service.dart';
import 'package:barpos/services/counter/order_service.dart';
import 'package:barpos/services/model/counters_model.dart';

class CounterHomeController extends GetxController {
  var counters = <CounterModel>[].obs;
  var selectedMyCounter = Rxn<CounterModel>();

  var orders = <Map<String, dynamic>>[].obs;

  var paymentMethods = <Map<String, dynamic>>[].obs;
  RxInt selectedPaymentMethod = 1.obs;

  var selectedCategory = "All".obs;

  var isLoadingMyCounters = false.obs;
  var isLoadingOrders = false.obs;
  var isPaymentLoading = false.obs;

  var isButtonLoading = false.obs;
  final RxString counterSearch = "".obs;

  void setCounterSearch(String value) {
    counterSearch.value = value;
  }

  final RxString sheetMessage = "".obs;
  final RxBool showSheetMessage = false.obs;
  final Rx<Color> sheetMessageColor = Colors.green.obs;
  final Rx<IconData> sheetMessageIcon = Icons.check_circle.obs;

  final MyCounterService _counterService = MyCounterService();
  final OrderService _orderService = OrderService();

  final AuthProvider authProvider = Get.find<AuthProvider>();
  final CounterProvider counterProvider = Get.find<CounterProvider>();

  String get userName => authProvider.user.value?.firstName ?? "User";

  bool _initialized = false;
  bool _paymentLoaded = false;

  @override
  void onInit() {
    super.onInit();

    ever(authProvider.accessToken, (token) {
      if (token == null || token.isEmpty) return;
      _initApp(token);
    });

    final token = authProvider.accessToken.value;
    if (token != null && token.isNotEmpty) {
      _initApp(token);
    }
  }

  Future<void> _initApp(String token) async {
    if (_initialized) return;
    _initialized = true;

    await Future.wait([loadMyCounters(token), loadPaymentMethods()]);
  }

  Future<void> loadMyCounters(String token) async {
    try {
      isLoadingMyCounters.value = true;

      final response = await _counterService.fetchMyCounters(token);

      if (response.isSuccess) {
        final List raw = response.data as List;

        counters.value = raw.map((e) => CounterModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Counter error: $e");
    } finally {
      isLoadingMyCounters.value = false;
    }
  }

  Future<void> loadCounterOrders(int counterId) async {
    try {
      isLoadingOrders.value = true;

      final token = authProvider.accessToken.value;
      if (token == null || token.isEmpty) return;

      final result = await _orderService.fetchCounterOrders(token, counterId);

      orders.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      debugPrint("Orders error: $e");
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> selectCounter(CounterModel counter) async {
    selectedMyCounter.value = counter;
    counterProvider.setCounter(counter);

    await loadCounterOrders(counter.id);
  }

  Future<void> loadPaymentMethods() async {
    if (_paymentLoaded) return;

    try {
      isPaymentLoading.value = true;

      final token = authProvider.accessToken.value;
      if (token == null || token.isEmpty) return;

      final result = await _orderService.fetchPaymentMethods(token);

      paymentMethods.value = List<Map<String, dynamic>>.from(result);

      _paymentLoaded = true;
    } catch (e) {
      debugPrint("Payment error: $e");
    } finally {
      isPaymentLoading.value = false;
    }
  }

  Future<bool> pickOrder({
    required int orderId,
    double amountReceived = 0.0,
    int paymentMethod = 1,
    String paymentDesc = "paid",
    VoidCallback? onClose,
  }) async {
    try {
      final token = authProvider.accessToken.value;

      final result = await _orderService.pickOrder(
        token: token!,
        orderId: orderId,
        amountReceived: amountReceived,
        paymentMethod: paymentMethod,
        paymentDesc: paymentDesc,
      );

      if (result['status'] == 'success') {
        showInlineNotification(
          result['message'] ?? "Order picked successfully",
          Colors.green,
          Icons.check_circle,
          autoCloseSheet: true,
        );
        await DelayHelper.wait(AppDelay.medium);
        onClose?.call();

        if (selectedMyCounter.value != null) {
          await loadCounterOrders(selectedMyCounter.value!.id);
        }

        return true;
      }

      showInlineNotification(
        result['message'] ?? "Failed to pick order",
        Colors.red,
        Icons.error,
      );

      return false;
    } catch (e) {
      showInlineNotification(e.toString(), Colors.red, Icons.error);
      return false;
    }
  }

  Future<void> makePayment({
    required int orderId,
    required double amountReceived,
    required int paymentMethod,
    String paymentDesc = "paid",
    VoidCallback? onClose,
  }) async {
    final token = authProvider.accessToken.value;

    try {
      isButtonLoading.value = true;

      final response = await _orderService.makePayment(
        token: token!,
        orderId: orderId,
        amountReceived: amountReceived,
        paymentMethod: paymentMethod,
        paymentDesc: paymentDesc,
      );

      if (response['status'] == 'success') {
        // 1. show message
        showInlineNotification(
          response['message'] ?? "Payment successful",
          Colors.green,
          Icons.check_circle,
        );

        // 2. update local state
        final index = orders.indexWhere((o) => o['id'] == orderId);

        if (index != -1) {
          final updated = Map<String, dynamic>.from(orders[index]);
          updated['payment_status'] = 'paid';
          updated['order_status'] = 'processing';
          orders[index] = updated;
        }

        // 3. refresh data
        if (selectedMyCounter.value != null) {
          await loadCounterOrders(selectedMyCounter.value!.id);
        }

        // 4. WAIT (IMPORTANT - SEQUENTIAL)
        await DelayHelper.wait(AppDelay.medium);
        onClose?.call();

        // 5. CLOSE SHEET (SAFE)
        if (Get.isBottomSheetOpen ?? false) {}
      } else {
        showInlineNotification(
          response['message'] ?? "Payment failed",
          Colors.red,
          Icons.error,
        );
      }
    } catch (e) {
      showInlineNotification(e.toString(), Colors.red, Icons.error);
    } finally {
      isButtonLoading.value = false;
    }
  }

  Future<bool> completeOrder({
    required int orderId,
    VoidCallback? onClose,
  }) async {
    try {
      isButtonLoading.value = true;

      final token = authProvider.accessToken.value;

      final result = await _orderService.completeOrder(
        token: token!,
        orderId: orderId,
      );

      if (result['status'] == 'success') {
        // 1. update local state
        final index = orders.indexWhere((o) => o['id'] == orderId);

        if (index != -1) {
          final updated = Map<String, dynamic>.from(orders[index]);
          updated['order_status'] = 'completed';
          orders[index] = updated;
        }

    
        showInlineNotification(
          result['message'] ?? "Order completed",
          Colors.green,
          Icons.check_circle,
        );


      await DelayHelper.wait(AppDelay.medium);
        onClose?.call();

      

        return true;
      }

      showInlineNotification(
        result['message'] ?? "Failed to complete order",
        Colors.red,
        Icons.error,
      );

      return false;
    } catch (e) {
      showInlineNotification(e.toString(), Colors.red, Icons.error);
      return false;
    } finally {
      isButtonLoading.value = false;
    }
  }

  Future<void> showInlineNotification(
    String message,
    Color color,
    IconData icon, {
    bool autoCloseSheet = false,
  }) async {
    sheetMessage.value = message;
    sheetMessageColor.value = color;
    sheetMessageIcon.value = icon;
    showSheetMessage.value = true;

    await DelayHelper.wait(AppDelay.medium);
    onClose?.call();

    showSheetMessage.value = false;

    if (autoCloseSheet) {
      await Future.delayed(const Duration(milliseconds: 300));

      if (Get.isBottomSheetOpen ?? false) {}
    }
  }

  Future<T> runAction<T>(Future<T> Function() action) async {
    try {
      isButtonLoading.value = true;
      return await action();
    } finally {
      isButtonLoading.value = false;
    }
  }
}
