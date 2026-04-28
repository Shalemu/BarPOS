import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:barpos/core/constants/api_constant.dart';

class OrderService {
  Future<void> submitOrder({
    required String token,
    required int counterId,
    required String tableRef,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse(ApiConstants.submitOrder);

    final body = {"counterId": counterId, "tableRef": tableRef, "items": items};

    try {
      print("REQUEST URL: $url");
      print("REQUEST BODY: ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["status"] == "success") {
          return;
        }
      }

      final message = data["message"] ?? "Failed to submit order";
      throw message;
    } catch (e, s) {
      print("ORDER ERROR: $e");
      print(s);

      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrder({required String token}) async {
    final url = Uri.parse(ApiConstants.fetchOrder);

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",

          "Content-Type": "application/json",
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        final List raw = data["data"] ?? [];

        return raw.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      throw data["message"] ?? "Failed to fetch orders";
    } catch (e, s) {
      print("FETCH ORDER ERROR: $e");
      print(s);
      rethrow;
    }
  }

 Future<void> cancelOrder({
  required String token,
  required int orderId,
}) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}/orders/$orderId/cancel",
  );

  try {
    final response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["status"] == "success") {
      return;
    }

    throw data["message"] ?? "Failed to cancel order";
  } catch (e, s) {
    print("CANCEL ORDER ERROR: $e");
    print(s);
    rethrow;
  }
}

Future<void> addItemsToOrder({
  required String token,
  required int orderId,
  required List<Map<String, dynamic>> items,
}) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}/orders/$orderId/items/add",
  );

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"items": items}),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["status"] == "success") {
      return;
    }

    throw data["message"] ?? "Failed to add items";
  } catch (e, s) {
    print("ADD ITEMS ERROR: $e");
    print(s);
    rethrow;
  }
}
}
