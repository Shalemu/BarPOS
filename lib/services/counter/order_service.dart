import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barpos/core/constants/api_constant.dart';

class OrderService {
  Future<List<dynamic>> fetchCounterOrders(String token, int counterId) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.baseUrl}/counters/$counterId/orders",
      );

      print(" REQUEST URL: $url");

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(" STATUS: ${response.statusCode}");
      print(" BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        print(" ORDERS FOUND: ${data["orders"].length}");
        return data["orders"];
      }

      throw Exception(data["message"] ?? "Failed to load orders");
    } catch (e, s) {
      print(" ORDER ERROR: $e");
      print(s);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> pickOrder({
    required String token,
    required int orderId,
    double amountReceived = 0.0,
    int paymentMethod = 1,
    String paymentDesc = "paid",
  }) async {
    try {
      final url = Uri.parse(ApiConstants.pickOrder);

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "order_id": orderId,
          "amount_received": amountReceived,
          "payment_method": paymentMethod,
          "payment_desc": paymentDesc,
        }),
      );

      final data = jsonDecode(response.body);

      print("PICK ORDER RESPONSE: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      }

      throw Exception(data["message"] ?? "Failed to process order");
    } catch (e) {
      print("PICK ORDER ERROR: $e");
      rethrow;
    }
  }

  // PAYMENT METHODS
  Future<List<dynamic>> fetchPaymentMethods(String token) async {
    try {
      final url = Uri.parse(ApiConstants.paymentMethod);

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data["data"] ?? [];
      }

      throw Exception(data["message"] ?? "Failed to load payment methods");
    } catch (e) {
      print("PAYMENT METHOD ERROR: $e");
      rethrow;
    }
  }

  /// MAKE PAYMENT
  Future<Map<String, dynamic>> makePayment({
    required String token,
    required int orderId,
    required double amountReceived,
    required int paymentMethod,
    String paymentDesc = "paid",
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/orders/$orderId/pay");

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "amount_received": amountReceived,
          "payment_method": paymentMethod,
          "payment_desc": paymentDesc,
        }),
      );

      final data = jsonDecode(response.body);

      print("PAYMENT RESPONSE: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      }

      throw Exception(data["message"] ?? "Payment failed");
    } catch (e) {
      print("PAYMENT ERROR: $e");
      rethrow;
    }
  }

  /// COMPLETE ORDER
  Future<Map<String, dynamic>> completeOrder({
    required String token,
    required int orderId,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/orders/$orderId/complete");

      final response = await http.patch(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      print("COMPLETE ORDER RESPONSE: $data");

      if (response.statusCode == 200) {
        return data;
      }

      throw Exception(data["message"] ?? "Failed to complete order");
    } catch (e) {
      print("COMPLETE ORDER ERROR: $e");
      rethrow;
    }
  }
}
