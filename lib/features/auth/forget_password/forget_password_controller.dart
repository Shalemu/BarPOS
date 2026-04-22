import 'dart:convert';
import 'package:barpos/core/constants/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;




class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var otpSent = false.obs;
  var isLoading = false.obs;

  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  void toggleNewPassword() {
    obscureNew.value = !obscureNew.value;
  }

  void toggleConfirmPassword() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  void showSnack(String message, {Color color = Colors.red}) {
    Get.snackbar(
      "Message",
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// REQUEST OTP
  Future<void> requestOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showSnack('Please enter your phone number.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.otpRequestForPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['detail'] != null) {
        showSnack(data['detail'], color: Colors.green);
        otpSent.value = true;
      } else {
        showSnack(data['detail'] ?? 'Failed to send OTP.');
      }
    } catch (e) {
      showSnack('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// RESET PASSWORD
  Future<void> resetPassword() async {
    final otp = otpController.text.trim();
    final phone = phoneController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (otp.isEmpty ||
        phone.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showSnack('Please fill all fields.');
      return;
    }

    if (newPassword != confirmPassword) {
      showSnack('Passwords do not match.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'otp': otp,
          'phone': phone,
          'password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.headers['content-type']
              ?.contains('application/json') ??
          false) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          showSnack(
            data['detail'] ?? "Password reset successful",
            color: Colors.green,
          );

          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          });
        } else {
          showSnack(data.toString());
        }
      } else {
        showSnack("Server returned HTML error.");
      }
    } catch (e) {
      showSnack("Error occurred. Check logs.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}