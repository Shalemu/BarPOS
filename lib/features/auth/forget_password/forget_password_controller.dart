import 'dart:convert';
import 'package:barpos/core/constants/api_constant.dart';
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  // ================= CONTROLLERS =================

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ================= STATE =================

  var isLoading = false.obs;

  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  String? savedEmail;

  // ================= HELPERS =================

  String get email => emailController.text.trim();

  // ================= NOTIFICATIONS =================

  void success(BuildContext context, String message) {
    TopNotification.show(
      context,
      message: message,
      color: Colors.green,
      icon: Icons.check_circle,
    );
  }

  void error(BuildContext context, String message) {
    TopNotification.show(
     context,
      message: message,
      color: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  // ================= STEP 1: SEND CODE =================

  Future<void> sendCodeToEmail(BuildContext context) async {
    if (email.isEmpty) {
      error(context, "Please enter your email");
      return;
    }

    savedEmail = email;

    await _sendCodeRequest(context);

    Get.toNamed('/verify-code');
  }

  // ================= RESEND CODE =================

  Future<void> resendCode(BuildContext context) async {
    if (savedEmail == null) {
      error(context, "Email not found. Go back and enter email again.");
      return;
    }

    await _sendCodeRequest(context);
  }

  // ================= API: SEND CODE =================

  Future<void> _sendCodeRequest(BuildContext context) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': savedEmail}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        success(context, data['message'] ?? "Code sent successfully");
      } else {
        error(context, data['message'] ?? "Failed to send code");
      }
    } catch (e) {
      print("SEND CODE ERROR: $e");
      error(context, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= STEP 2: VERIFY CODE =================

  Future<void> verifyCode(BuildContext context) async {
    final emailToUse = savedEmail;

    if (emailToUse == null || codeController.text.trim().isEmpty) {
      error(context, "Enter code");
      return;
    }

    try {
      isLoading.value = true;

      final int? code = int.tryParse(codeController.text.trim());

      if (code == null) {
        error(context, "Code must be a number");
        return;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.tokenVerification),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': emailToUse,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        success(context, "Code verified");

        Future.delayed(const Duration(milliseconds: 300), () {
          Get.offNamed(AppRoutes.resetPassword);
        });
      } else {
        error(context, data['message'] ?? "Invalid code");
      }
    } catch (e) {
      print("VERIFY ERROR: $e");
      error(context, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= STEP 3: RESET PASSWORD =================

  Future<void> resetPassword(BuildContext context) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (savedEmail == null ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      error(context, "Please fill all fields");
      return;
    }

    if (newPassword != confirmPassword) {
      error(context, "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': savedEmail,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        success(context, "Password reset successful");

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutes.login);
        });
      } else {
        error(context, data['message'] ?? "Reset failed");
      }
    } catch (e) {
      print("RESET ERROR: $e");
      error(context, "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CLEANUP =================

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}