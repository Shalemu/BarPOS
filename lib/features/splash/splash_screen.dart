import 'package:barpos/core/widgets/dot_loader.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../auth/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _goToLogin();
  }

  void _goToLogin() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Logo
            Image.asset(
              'assets/logos/privatech.png',
              width: 120,
              height: 120,
              color: AppColors.primary,
            ),

            const SizedBox(height: 20),

            /// App Name
            const Text(
              'BAR POS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 40),

            /// Loader
            const DotLoader(),

            const SizedBox(height: 10),

            const Text(
              'Loading...',
              style: TextStyle(
                color: AppColors.hintText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}