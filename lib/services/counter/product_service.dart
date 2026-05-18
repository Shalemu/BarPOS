import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barpos/services/model/product_model.dart';
import 'package:barpos/core/constants/api_constant.dart';

class ProductService {
  Future<List<ProductModel>> fetchCounterProducts(
    String token,
    int counterId,
  ) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.fetchProducts}/$counterId/products",
      );

      print("REQUEST URL: $url");

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
        return (data["products"] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }

      throw Exception(data["message"] ?? "Failed to load products");
    } catch (e, s) {
      print("PRODUCT ERROR: $e");
      print(s);
      rethrow;
    }
  }
}
