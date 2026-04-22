import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// FORM CARD
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        /// EMAIL
                        TextField(
                          controller: controller.usernameController,
                          decoration: inputDecoration('Email', Icons.email),
                        ),

                        const SizedBox(height: 15),

                        /// PASSWORD
                        Obx(
                          () => TextField(
                            controller: controller.passwordController,
                            obscureText: controller.obscurePassword.value,
                            decoration: inputDecoration(
                              'Password',
                              Icons.lock,
                              suffix: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// FORGOT PASSWORD
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// LOGIN BUTTON
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () =>
                                        controller.login(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// REGISTER LINK
                        GestureDetector(
                          onTap: () {
                            Get.offAllNamed(AppRoutes.register);
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
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