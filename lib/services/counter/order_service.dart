import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barpos/core/constants/api_constant.dart';

class OrderService {
  Future<List<dynamic>> fetchCounterOrders(
    String token,
    int counterId,
  ) async {
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

}
