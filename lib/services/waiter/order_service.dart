import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barpos/core/constants/api_constant.dart';

class OrderService {
  Future<void> submitOrder({
    required String token,
    required int counterId,
    String? tableRef,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse(ApiConstants.submitOrder);

    final body = {
      "counterId": counterId,
      "items": items,
      "tableRef": ?tableRef,
    };

    try {
      final response = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["status"] == "success") {
        return;
      }

      throw data["message"] ?? "Failed to submit order";
    } catch (e) {
      print("ORDER ERROR: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrder({
  required String token,
  int page = 1,
  int perPage = 5,
  String? fromDate,
  String? toDate,
}) async {
  final query = {
    "page": page.toString(),
    "per_page": perPage.toString(),
    if (fromDate != null) "from_date": fromDate,
    if (toDate != null) "to_date": toDate,
  };

  final uri = Uri.parse(ApiConstants.fetchOrder)
      .replace(queryParameters: query);

  final response = await http.get(uri, headers: _headers(token));
  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["status"] == "success") {
    final List raw = data["data"] ?? [];
    return raw.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  throw data["message"] ?? "Failed to fetch orders";
}
  Future<void> cancelOrder({
    required String token,
    required int orderId,
  }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/orders/$orderId/cancel");

    try {
      final response = await http.patch(url, headers: _headers(token));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        return;
      }

      throw data["message"] ?? "Failed to cancel order";
    } catch (e) {
      print("CANCEL ORDER ERROR: $e");
      rethrow;
    }
  }

  Future<void> addItemsToOrder({
    required String token,
    required int orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/orders/$orderId/items/add");

    try {
      final response = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode({"items": items}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        return;
      }

      throw data["message"] ?? "Failed to add items";
    } catch (e) {
      print("ADD ITEMS ERROR: $e");
      rethrow;
    }
  }

  Map<String, String> _headers(String token) {
    return {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }
}
