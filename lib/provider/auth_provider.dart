import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barpos/services/model/user_model.dart';

class AuthProvider extends GetxController {

  final user = Rxn<UserModel>();
  final accessToken = RxnString();
  final refreshToken = RxnString();
  final isLoading = false.obs;

 
  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }


  bool get isAuthenticated =>
      accessToken.value != null && accessToken.value!.isNotEmpty;


  Future<void> loadFromPrefs() async {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString('user');
    final access = prefs.getString('access_token');
    final refresh = prefs.getString('refresh_token');

    if (userData != null) {
      user.value = UserModel.fromJson(jsonDecode(userData));
    }

    accessToken.value = access;
    refreshToken.value = refresh;

    print("Loaded token: ${accessToken.value}");

    isLoading.value = false;
  }

 
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
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    user.value = null;
    accessToken.value = null;
    refreshToken.value = null;

    print("Logged out");
  }
}