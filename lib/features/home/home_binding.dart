import 'package:get/get.dart';
import 'home_controller.dart';
import 'bottom_nav_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BottomNavController());
  }
}
