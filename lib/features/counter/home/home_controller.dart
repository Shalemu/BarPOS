import 'dart:ui';

import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/provider/counter/counter_provider.dart';
import 'package:barpos/services/counter/myCounter_service.dart';
import 'package:barpos/services/counter/order_service.dart';
import 'package:barpos/services/model/counters_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterHomeController extends GetxController {
  // DATA
  var counters = <CounterModel>[].obs;

  var selectedMyCounter = Rxn<CounterModel>();

  var isLoadingMyCounters = false.obs;

  var selectedCategory = "All".obs;
  var searchQuery = "".obs;

  var orders = <Map<String, dynamic>>[].obs;
  var isLoadingOrders = false.obs;

  var debugStatus = "".obs;

  final RxString counterSearch = "".obs;

  var paymentMethods = <Map<String, dynamic>>[].obs;
  var selectedPaymentMethod = RxnInt();

  final RxString sheetMessage = "".obs;
  final RxBool showSheetMessage = false.obs;
  final Rx<Color> sheetMessageColor = Colors.green.obs;
  final Rx<IconData> sheetMessageIcon = Icons.check_circle.obs;

  var isButtonLoading = false.obs;

  // DEPENDENCIES

  final MyCounterService _counterService = MyCounterService();
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final MyCounterProvider counterProvider = Get.find<MyCounterProvider>();
  final OrderService _orderService = OrderService();

  // USER INFO

  String get userName => authProvider.user.value?.firstName ?? "User";

  // INIT

  @override
  void onInit() {
    super.onInit();

    ever(authProvider.accessToken, (token) {
      if (token != null && token.isNotEmpty) {
        loadMyCounters(token);
      }
    });

    final token = authProvider.accessToken.value;
    if (token != null && token.isNotEmpty) {
      loadMyCounters(token);
    }
  }

  void setCounterSearch(String value) {
    counterSearch.value = value;
  }

  // LOAD COUNTERS
  Future<void> loadMyCounters(String token) async {
    try {
      isLoadingMyCounters.value = true;
      debugStatus.value = "⏳ Loading counters...";

      final response = await _counterService.fetchMyCounters(token);

      debugStatus.value =
          "📡 Response received. Success: ${response.isSuccess}";

      print("RAW RESPONSE: ${response.data}");

      if (response.isSuccess) {
        final List rawCounters = response.data as List;

        debugStatus.value = "Counters received: ${rawCounters.length}";

        counters.value = rawCounters
            .map((e) => CounterModel.fromJson(e))
            .toList();

        print("PARSED COUNTERS: ${counters.length}");

        for (final c in counters) {
          print("COUNTER => ${c.name} (${c.pendingOrdersCount})");
        }
      } else {
        debugStatus.value =
            "API FAILED: ${response.message ?? 'Unknown error'}";

        print("API FAILED");
      }
    } catch (e) {
      debugStatus.value = " ERROR: $e";
      print("ERROR LOADING COUNTERS: $e");
    } finally {
      isLoadingMyCounters.value = false;
    }
  }

  Future<void> loadCounterOrders(int counterId) async {
    try {
      isLoadingOrders.value = true;

      final token = authProvider.accessToken.value;

      if (token == null || token.isEmpty) {
        print(" NO TOKEN FOUND");
        return;
      }

      print(" FETCHING ORDERS FOR COUNTER: $counterId");

      final result = await _orderService.fetchCounterOrders(token, counterId);

      orders.value = List<Map<String, dynamic>>.from(result);

      print(" ORDERS LOADED: ${orders.length}");

      for (var order in orders) {
        print(" ORDER => ${order['order_ref']} | ${order['order_status']}");
      }
    } catch (e) {
      print(" FAILED TO LOAD ORDERS: $e");
    } finally {
      isLoadingOrders.value = false;
    }
  }

  //SELECT COUNTER
  Future<void> selectCounter(CounterModel counter) async {
    selectedMyCounter.value = counter;

    counterProvider.setCounter(counter);

    print(" SELECTED COUNTER: ${counter.id} - ${counter.name}");

    await loadCounterOrders(counter.id);
  }

  Future<dynamic> pickOrder({
    required int orderId,
    double amountReceived = 0.0,
    int paymentMethod = 1,
    String paymentDesc = "paid",
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

      if (selectedMyCounter.value != null) {
        await loadCounterOrders(selectedMyCounter.value!.id);
      }

      return result;
    } catch (e) {
      print("PICK ORDER ERROR: $e");
      rethrow;
    }
  }

  Future<void> loadPaymentMethods() async {
    try {
      final token = authProvider.accessToken.value;

      if (token == null) return;

      final result = await _orderService.fetchPaymentMethods(token);

      paymentMethods.value = List<Map<String, dynamic>>.from(result);

      print("PAYMENT METHODS LOADED: ${paymentMethods.length}");
    } catch (e) {
      print("PAYMENT METHODS ERROR: $e");
    }
  }

Future<void> makePayment({
  required int orderId,
  required double amountReceived,
  required int paymentMethod,
  String paymentDesc = "paid",
}) async {
  try {
    final token = authProvider.accessToken.value;

    await _orderService.makePayment(
      token: token!,
      orderId: orderId,
      amountReceived: amountReceived,
      paymentMethod: paymentMethod,
      paymentDesc: paymentDesc,
    );

    if (selectedMyCounter.value != null) {
      await loadCounterOrders(selectedMyCounter.value!.id);
    }
  } catch (e) {
    print(e);
    rethrow;
  }
}

  Future<void> completeOrder({required int orderId}) async {
    try {
      final token = authProvider.accessToken.value;

      await _orderService.completeOrder(token: token!, orderId: orderId);

      if (selectedMyCounter.value != null) {
        await loadCounterOrders(selectedMyCounter.value!.id);
      }
    } catch (e) {
      print(e);
    }
  }

  void _notify(String msg, Color color, IconData icon) {
    sheetMessage.value = msg;
    sheetMessageColor.value = color;
    sheetMessageIcon.value = icon;
    showSheetMessage.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      showSheetMessage.value = false;
    });
  }

  void showInlineNotification(String message, Color color, IconData icon) {
    _notify(message, color, icon);
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
