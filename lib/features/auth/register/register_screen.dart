import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
SizedBox(height: 60,),
                  /// LOGO
                  Center(
                    child: Image.asset(
                      'assets/logos/privatech.png',
                      height: 55,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// TITLE
                  const Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Join BarPOS and manage your business",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// INPUTS (NO OUTER CARD ANYMORE)
                  _field(controller.firstNameController, "First Name", Icons.person),
                  _field(controller.middleNameController, "Middle Name", Icons.person_outline),
                  _field(controller.lastNameController, "Last Name", Icons.person_outline),
                  _field(controller.emailController, "Email", Icons.email),
                  _field(controller.phoneController, "Phone", Icons.phone),

                  const SizedBox(height: 5),

                  /// PASSWORD
                  Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: inputDecoration(
                          "Password",
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
                      )),

                  const SizedBox(height: 12),

                  /// CONFIRM PASSWORD
                  TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    decoration: inputDecoration(
                      "Confirm Password",
                      Icons.lock_outline,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// BUTTON
                  Obx(() => SizedBox(
                        height: 52,
                        child: controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () => controller.register(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "CREATE ACCOUNT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      )),

                  const SizedBox(height: 15),

                  /// LOGIN LINK
                  GestureDetector(
                    onTap: () => Get.offAllNamed(AppRoutes.login),
                    child: Text(
                      "Already have an account? Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: inputDecoration(label, icon),
      ),
    );
  }
}