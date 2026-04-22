
import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/onboarding/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 30),

          /// SKIP
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 50),

          /// IMAGE
          Center(
            child: Container(
              height: 360,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/onboarding.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          /// TITLE
          const Center(
            child: Text(
              "Best Booking App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Explore the best services and book easily with our platform.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
          ),

          const Spacer(),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: CustomButton(
              text: "GET STARTED",
              onTap: () {
                Get.toNamed(AppRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}