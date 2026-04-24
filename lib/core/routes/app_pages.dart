import 'package:barpos/features/auth/forget_password/forget_password.binding.dart';
import 'package:barpos/features/auth/forget_password/forget_password_screen.dart';
import 'package:barpos/features/auth/forget_password/reset_password_screen.dart';
import 'package:barpos/features/auth/forget_password/verify-email.dart';
import 'package:barpos/features/onboarding/onboarding_binding.dart';
import 'package:barpos/features/onboarding/onboarding_screen.dart';
import 'package:barpos/features/splash/splash_binding.dart';
import 'package:barpos/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// AUTH
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/login/login_binding.dart';

import '../../features/auth/register/register_screen.dart';
import '../../features/auth/register/register_binding.dart';

// HOME
import '../../features/home/home_screen.dart';
import '../../features/home/home_binding.dart';

// CART
import '../../features/cart/cart_screen.dart';
import '../../features/cart/cart_binding.dart';

// ORDERS
import '../../features/orders/orders_screen.dart';
import '../../features/orders/orders_binding.dart';

// PROFILE
import '../../features/profile/profile_screen.dart';
import '../../features/profile/profile_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => Scaffold(body: Center(child: Text("ONBOARDING LOADED"))),
    ),
    // AUTH
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),

    GetPage(
      name: '/verify-code',
      page: () => const VerifyCodeScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: '/reset-password',
      page: () => const ResetPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    // HOME
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    // CART
    GetPage(
      name: AppRoutes.cart,
      page: () => CartScreen(),
      binding: CartBinding(),
    ),

    // ORDERS
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
      binding: OrdersBinding(),
    ),

    // PROFILE
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
