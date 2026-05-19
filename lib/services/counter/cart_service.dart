import 'dart:convert';
import 'package:barpos/core/constants/api_constant.dart';
import 'package:barpos/services/model/api_response.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<ApiResponse<dynamic>> submitOrder({
  required String token,
  required int counterId,
  String? tableRef,
  required List<Map<String, dynamic>> items,
  Map<String, dynamic>? payments, 
}) async {
  try {
    final url = Uri.parse(ApiConstants.counterSubmitOrder);

    final body = <String, dynamic>{
      "counterId": counterId,
      "tableRef": tableRef,
      "items": items,
    };

  
    if (payments != null) {
      body["payments"] = payments;
    }

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.success(data);
    } else {
      return ApiResponse.error(data['message'] ?? "Order failed");
    }
  } catch (e) {
    return ApiResponse.error(e.toString());
  }
}
}
