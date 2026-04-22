import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/auth/forget_password/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 100),

              SizedBox(
                height: 160,
                child: Image.asset('assets/logo/logo.png'),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// OTP + PASSWORD SECTION
              Obx(() {
                if (!controller.otpSent.value) return const SizedBox();

                return Column(
                  children: [
                    TextField(
                      controller: controller.otpController,
                      decoration: InputDecoration(
                        labelText: 'OTP Code',
                        prefixIcon: const Icon(Icons.lock_open),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Obx(() => TextField(
                          controller:
                              controller.newPasswordController,
                          obscureText:
                              controller.obscureNew.value,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureNew.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  controller.toggleNewPassword,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        )),

                    const SizedBox(height: 20),

                    Obx(() => TextField(
                          controller:
                              controller.confirmPasswordController,
                          obscureText:
                              controller.obscureConfirm.value,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon:
                                const Icon(Icons.lock_reset),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureConfirm.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  controller.toggleConfirmPassword,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        )),

                    const SizedBox(height: 30),
                  ],
                );
              }),

              /// BUTTON
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.otpSent.value
                              ? controller.resetPassword
                              : controller.requestOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : Text(
                              controller.otpSent.value
                                  ? 'Reset Password'
                                  : 'Request OTP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}