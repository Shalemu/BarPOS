import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController(text: '+255 ');
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // States
  var obscurePassword = true.obs;
  var isLoading = false.obs;

  var roles = <Map<String, dynamic>>[].obs;
  var selectedRoleId = RxnInt();

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // optional: fetchRoles(); if needed
  }

  // Toggle password
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Phone formatter
  String formatPhone(String input) {
    String phone = input.replaceAll(' ', '').trim();

    if (phone.startsWith('0')) {
      phone = '+255${phone.substring(1)}';
    } else if (phone.startsWith('255')) {
      phone = '+$phone';
    } else if (!phone.startsWith('+255')) {
      phone = '+255$phone';
    }

    return phone;
  }

  // REGISTER
 Future<void> register(BuildContext context) async {
  final firstName = firstNameController.text.trim();
  final middleName = middleNameController.text.trim();
  final lastName = lastNameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final phone = formatPhone(phoneController.text);

  if (selectedRoleId.value == null) {
    TopNotification.show(
      context,
      message: "Please select a user type",
      color: Colors.redAccent,
      icon: Icons.error_outline,
    );
    return;
  }

  if ([firstName, lastName, email, password].any((e) => e.isEmpty)) {
    TopNotification.show(
      context,
      message: "Please fill all required fields",
      color: Colors.redAccent,
      icon: Icons.error_outline,
    );
    return;
  }

  try {
    isLoading.value = true;

    final response = await _authService.register(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      roleId: selectedRoleId.value!,
    );

    if (response.isSuccess) {
      TopNotification.show(
        context,
        message: response.message ?? "Registration successful",
        color: AppColors.primary,
        icon: Icons.check_circle,
      );

      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoutes.login);
      });
    } else {
      TopNotification.show(
        context,
        message: response.message ?? "Registration failed",
        color: Colors.redAccent,
        icon: Icons.error_outline,
      );
    }
  } catch (e) {
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
}