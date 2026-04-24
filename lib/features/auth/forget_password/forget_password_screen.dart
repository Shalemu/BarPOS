import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/auth/forget_password/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 650;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: isSmall ? 10 : 30,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),

              child: Column(
                children: [

                  SizedBox(height: isSmall ? 10 : 30),

                  /// LOGO
                  Image.asset(
                    'assets/logos/privatech.png',
                    height: 60,
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// CARD
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        /// EMAIL INPUT
                        TextField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// BUTTON
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                   onPressed: () => controller.sendCodeToEmail(context),
                                        
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Send Verification Code',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmall ? 20 : 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}