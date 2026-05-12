import 'dart:convert';
import 'package:barpos/core/constants/api_constant.dart';
import 'package:barpos/services/model/api_response.dart';
import 'package:http/http.dart' as http;

class MyCounterService {
  Future<ApiResponse<List<dynamic>>> fetchMyCounters(String token) async {
    try {
      final url = Uri.parse(ApiConstants.myCounter);

      print("FETCH COUNTERS START");
      print("URL: $url");

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final List countersJson = data['counters'];

        return ApiResponse.success(countersJson);
      } else {
        return ApiResponse.error(
          data['message'] ?? 'Failed to fetch counters',
          statusCode: response.statusCode,
        );
      }
    } catch (e, stack) {
      print("EXCEPTION: $e");
      print(stack);

      return ApiResponse.error(e.toString());
    } finally {
      print("FETCH COUNTERS END");
    }
  }
}
