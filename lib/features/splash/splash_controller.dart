import 'package:barpos/core/routes/app_routes.dart';
import 'package:barpos/features/splash/models/slpash_model.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModel = SplashModel().obs;

  @override
  void onInit() {
    super.onInit();

    print("🚀 SplashController initialized");

    _startSplash();
  }

  void _startSplash() async {
    try {
      print("⏳ Splash timer started");

      await Future.delayed(const Duration(milliseconds: 1200));

      print("➡️ Navigating to onboarding");

      await Future.delayed(Duration.zero); // allows UI frame to settle

      Get.offAllNamed(AppRoutes.onboarding);

      print("✅ Navigation executed");
    } catch (e) {
      print("Splash error: $e");
    }
  }
}