import 'package:barpos/features/auth/login/auth_controller.dart';
import 'package:barpos/features/cart/cart_controller.dart';
import 'package:barpos/features/orders/orders_controller.dart';
import 'package:barpos/features/profile/profile_controller.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

void main() {
    Get.put(AuthController(), permanent: true);
     Get.put(AuthProvider(), permanent: true);
    Get.put(CartController(), permanent: true);
    // Get.put(CartsController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, 

      initialRoute: AppRoutes.login, 

      getPages: AppPages.pages,
    );
  }
}