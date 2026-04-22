import 'package:barpos/features/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print("🧩 SplashBinding executed");
    Get.lazyPut(() => SplashController());
  }
}