import 'package:barpos/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

import 'provider/auth_provider.dart';
import 'features/auth/login/auth_controller.dart';
import 'features/cart/cart_controller.dart';
import 'features/orders/orders_controller.dart';
import 'features/profile/profile_controller.dart';
import 'features/home/home_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // PROVIDER FIRST
    final authProvider = Get.put(AuthProvider(), permanent: true);
    Get.put(CounterProvider());
    
    // CONTROLLERS
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    Get.put(HomeController(), permanent: true);
   

    // LOAD SAVED DATA
    await authProvider.loadFromPrefs();
  
  } catch (e, s) {
    print("STARTUP ERROR: $e");
    print(s);
  }

  await GetStorage.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.pages,

      defaultTransition: Transition.fade,
    );
  }
}