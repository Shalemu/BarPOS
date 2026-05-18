
import 'package:barpos/features/counter/cart/cart_controller.dart' show CartController;
import 'package:barpos/features/waiter/orders/orders_controller.dart';
import 'package:barpos/features/profile/profile_controller.dart';
import 'package:barpos/provider/auth_provider.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../../core/bottom_nav_controller.dart';

class CounterHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CounterHomeController());

    /// IMPORTANT: inject BottomNavController with permissions
    Get.lazyPut(() {
      final auth = Get.find<AuthProvider>();

      final permissions = auth.user.value?.permissions;

      return BottomNavController(permissions: permissions ?? []);
    });

    Get.lazyPut(() => CartController());

    Get.put<OrdersController>(OrdersController(), permanent: true);

    Get.lazyPut(() => ProfileController());
  }
}
