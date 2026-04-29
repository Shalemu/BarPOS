import 'package:barpos/features/cart/cart_controller.dart';
import 'package:barpos/features/orders/orders_controller.dart';
import 'package:barpos/features/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'bottom_nav_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BottomNavController());
      Get.lazyPut(() => CartController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => ProfileController());
  }
}
