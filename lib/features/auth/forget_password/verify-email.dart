import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/auth/forget_password/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends GetView<ForgotPasswordController> {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),

              child: Column(
                children: [

                  const SizedBox(height: 30),

                  const Text(
                    'Verify Code',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Enter the 6-digit code sent to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        /// CODE INPUT
                        TextField(
                          controller: controller.codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: 'Verification Code',
                            prefixIcon: const Icon(Icons.verified),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// VERIFY BUTTON
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: controller.isLoading.value
                                  ? const Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed:() => controller.verifyCode(context),
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                      ),
                                      child: const Text(
                                        "Verify Code",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            )),

                        const SizedBox(height: 15),

                        /// RESEND CODE
                        TextButton(
                          onPressed: () => controller.resendCode(context),
                          child: const Text("Resend Code"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}