import 'dart:convert';
import 'package:barpos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barpos/services/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;

  // ================= GETTERS =================
  UserModel? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get isLoading => _isLoading;

  bool get isAuthenticated =>
      _accessToken != null && _accessToken!.isNotEmpty;

  // ================= SETTERS (STATE ONLY) =================

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void setToken({
    required String accessToken,
    String? refreshToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  void clear() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  // ================= LOAD FROM STORAGE =================
  Future<void> loadFromPrefs() async {
    setLoading(true);

    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString('user');
    final access = prefs.getString('access');
    final refresh = prefs.getString('refresh');

    if (userData != null) {
      _user = UserModel.fromJson(jsonDecode(userData));
    }

    _accessToken = access;
    _refreshToken = refresh;

    setLoading(false);
  }

  // ================= SAVE TO STORAGE =================
  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();

    if (_user != null) {
      await prefs.setString('user', jsonEncode(_user!.toJson()));
    }

    if (_accessToken != null) {
      await prefs.setString('access', _accessToken!);
    }

    if (_refreshToken != null) {
      await prefs.setString('refresh', _refreshToken!);
    }
  }

  // ================= LOGOUT STATE ONLY =================
  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    clear();
  }
  Future<void> logout() async {
  await AuthService().logout();
  clear(); // your provider reset
}
}