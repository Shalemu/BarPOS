import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:barpos/core/constants/api_constant.dart';
import 'package:barpos/features/auth/models/LoginResponse.dart';
import 'package:barpos/services/model/api_response.dart';
import 'package:barpos/services/model/user_model.dart';
import 'package:barpos/provider/auth_provider.dart';

class AuthService {
  final AuthProvider authProvider = Get.find<AuthProvider>();


  Map<String, String> _headers({bool auth = false}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (auth && authProvider.accessToken.value != null)
        'Authorization': 'Bearer ${authProvider.accessToken.value}',
    };
  }


  dynamic _handleResponse(http.Response response) {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode == 401) {
      authProvider.handleUnauthorized(); 
      throw Exception("Unauthorized");
    }

    return data;
  }

  //LOGIN
  Future<LoginResponseModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = _handleResponse(response);

    if (response.statusCode == 200 && data["status"] == "success") {
      return LoginResponseModel.fromJson(data);
    } else {
      throw Exception(data["message"] ?? "Login failed");
    }
  }

  // REGISTER
  Future<ApiResponse<UserModel>> register({
    required String firstName,
    required String middleName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required int roleId,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registration),
      headers: _headers(),
      body: jsonEncode({
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "phone_number": phone,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "role_id": roleId,
      }),
    );

    final data = _handleResponse(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse<UserModel>.fromJson(
        data,
        (json) => UserModel.fromJson(json['user'] ?? json),
      );
    }

    return ApiResponse.error(
      data["message"] ?? "Registration failed",
      statusCode: response.statusCode,
    );
  }

  // CHANGE PASSWORD
  Future<ApiResponse<void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.changePassword),
        headers: _headers(auth: true),
        body: jsonEncode({
          'old_password': oldPassword,
          'password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      final data = _handleResponse(response);

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
      return ApiResponse.error('Unexpected error: $e', statusCode: 500);
    }
  }

  // LOGOUT (API OPTIONAL)
  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.logout),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authProvider.accessToken.value}',
        },
      );

      // Optional: check response
      if (response.statusCode == 200) {
        print("Server logout success");
      } else {
        print("Server logout failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Logout API error: $e");
    } finally {
      await authProvider.logout();
      print("User logged out locally");
    }
  }
}
