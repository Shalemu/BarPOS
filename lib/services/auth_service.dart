import 'dart:convert';
import 'package:barpos/core/constants/api_constant.dart';
import 'package:barpos/features/auth/models/LoginResponse.dart';
import 'package:barpos/services/model/api_response.dart';
import 'package:barpos/services/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// LOGIN
Future<LoginResponseModel> login(String email, String password) async {
  final response = await http.post(
    Uri.parse(ApiConstants.login),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["status"] == "success") {
    return LoginResponseModel.fromJson(data);
  } else {
    throw Exception(data["message"] ?? "Login failed");
  }
}

  /// REGISTER
Future<ApiResponse<UserModel>> register({
  required String firstName,
  required String middleName,
  required String lastName,
  required String phone,
  required String email,
  required String password,
  required int roleId,
}) async {
  final uri = Uri.parse(ApiConstants.registration);

  final body = {
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "phone_number": phone,
    "email": email,
    "password": password,
    "password_confirmation": password,
    "role_id": roleId,
  };

  final response = await http.post(
    uri,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  final decoded = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return ApiResponse<UserModel>.fromJson(
      decoded,
      (data) => UserModel.fromJson(data['user'] ?? data),
    );
  } else {
    return ApiResponse.error(
      decoded["message"] ?? "Registration failed",
      statusCode: response.statusCode,
    );
  }
}
  // ==============================
  // Change Password
  // ==============================
 Future<ApiResponse<void>> changePassword({
  required String token,
  required String oldPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.changePassword),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'password': newPassword,
        'confirm_password': confirmPassword,
      }),
    );

    final data =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode == 200) {
      return ApiResponse.success(
        null,
        message: data['message'] ?? 'Password changed successfully',
        statusCode: 200,
      );
    }

    return ApiResponse.error(
      data['message'] ?? 'Failed to change password',
      statusCode: response.statusCode,
    );
  } catch (e) {
    return ApiResponse.error(
      'Unexpected error: $e',
      statusCode: 500,
    );
  }
}
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove stored auth data
      await prefs.remove('user');
      await prefs.remove('access');
      await prefs.remove('refresh');

      // optional debug
      print(" User logged out successfully");
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }
}