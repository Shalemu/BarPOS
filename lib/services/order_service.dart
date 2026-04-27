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
    try {
      final url = Uri.parse(ApiConstants.submitOrder);

      final body = {
        "counterId": counterId,
        "tableRef": tableRef,
        "items": items,
      };

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

      throw Exception(data["message"] ?? "Failed to submit order");
    } catch (e, s) {
      print("ORDER ERROR: $e");
      print(s);
      rethrow;
    }
  }
}