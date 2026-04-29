import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

import 'provider/auth_provider.dart';
import 'provider/counter_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  try {
 
    Get.put(AuthProvider(), permanent: true);
    Get.put(CounterProvider());

    /// LOAD AUTH STATE
    final authProvider = Get.find<AuthProvider>();
    await authProvider.loadFromPrefs();

  } catch (e, s) {
    print("STARTUP ERROR: $e");
    print(s);
  }

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