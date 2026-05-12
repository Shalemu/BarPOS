import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:barpos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthProvider authProvider = Get.find<AuthProvider>();

  var obscurePassword = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login(BuildContext context) async {
  final email = usernameController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    TopNotification.show(
      context,
      message: "Email and password required",
      color: Colors.redAccent,
      icon: Icons.error_outline,
    );
    return;
  }

  try {
    isLoading.value = true;

    final authService = AuthService();
    final response = await authService.login(email, password);

    final user = response.user;
    final token = user.token;

    print("TOKEN RECEIVED: $token");

    // SAVE AUTH (user + token)
    await authProvider.saveAuth(
      userData: user,
      token: token,
    );

    TopNotification.show(
      // ignore: use_build_context_synchronously
      context,
      message: response.message,
      color: AppColors.primary,
      icon: Icons.check_circle,
    );

   
    final permissions = user.permissions;

    // COUNTER (order picker / kitchen / bar processing)
    if (permissions.contains('order.pick')) {
      Get.offAllNamed(AppRoutes.counterHome);
      return;
    }

    // WAITER / CASHIER / POS USER
    if (permissions.contains('order.create') ||
        permissions.contains('pos')) {
      Get.offAllNamed(AppRoutes.waiterHome);
      return;
    }

    // FALLBACK (no valid permission)
    Get.offAllNamed(AppRoutes.login);

  } catch (e) {
    print("LOGIN ERROR: $e");

    TopNotification.show(
      context,
      message: e.toString(),
      color: Colors.redAccent,
      icon: Icons.error_outline,
    );
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
