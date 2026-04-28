import 'dart:convert';
import 'package:barpos/services/model/counters_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barpos/services/model/user_model.dart';
import 'package:barpos/core/routes/app_routes.dart';

class AuthProvider extends GetxController {
  final user = Rxn<UserModel>();
  final accessToken = RxnString();
  final refreshToken = RxnString();
  final selectedCounter = Rxn<CounterModel>();

  final isLoading = false.obs;
  final isInitialized = false.obs;

  bool get isAuthenticated =>
      accessToken.value != null && accessToken.value!.isNotEmpty;

Future<void> loadFromPrefs() async {
  print("AUTH: Loading from SharedPreferences...");

  isLoading.value = true;

  final prefs = await SharedPreferences.getInstance();

  final userData = prefs.getString('user');
  final access = prefs.getString('access_token');
  final refresh = prefs.getString('refresh_token');

  print("AUTH: Raw token = $access");

  if (userData != null) {
    user.value = UserModel.fromJson(jsonDecode(userData));
    print("AUTH: User restored");
  }

  accessToken.value = access;
  refreshToken.value = refresh;

  print("AUTH: accessToken set = ${accessToken.value}");

  isLoading.value = false;
  isInitialized.value = true;

  print("AUTH: INIT COMPLETE");
}

  // SAVE AUTH (LOGIN)
  Future<void> saveAuth({
    required UserModel userData,
    required String token,
    String? refresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', jsonEncode(userData.toJson()));
    await prefs.setString('access_token', token);

    if (refresh != null) {
      await prefs.setString('refresh_token', refresh);
    }

    user.value = userData;
    accessToken.value = token;
    refreshToken.value = refresh;

    print("Token saved: $token");

    // Navigate after login
    Get.offAllNamed(AppRoutes.home);
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    user.value = null;
    accessToken.value = null;
    refreshToken.value = null;

    print("Logged out");

    Get.offAllNamed(AppRoutes.login);
  }

  
  /// HANDLE TOKEN EXPIRATION
  Future<void> handleUnauthorized() async {
    print("Token expired or unauthorized");

    // OPTIONAL: try refresh first
    if (refreshToken.value != null) {
      final success = await refreshAccessToken();
      if (success) return;
    }

    await logout();
  }


  //REFRESH TOKEN (OPTIONAL)
  Future<bool> refreshAccessToken() async {
    try {

      final newToken = null; 

      if (newToken != null) {
        accessToken.value = newToken;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', newToken);

        print("Token refreshed");

        return true;
      }

      return false;
    } catch (e) {
      print("Refresh failed: $e");
      return false;
    }
  }
}