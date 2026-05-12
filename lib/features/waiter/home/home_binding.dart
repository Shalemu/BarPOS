import 'package:barpos/core/bottom_nav_controller.dart';
import 'package:barpos/features/waiter/cart/cart_controller.dart';
import 'package:barpos/features/waiter/orders/orders_controller.dart';
import 'package:barpos/features/profile/profile_controller.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import '../../../provider/auth_provider.dart';

class WaiterHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaiterHomeController());

  
    Get.lazyPut(() {
      final auth = Get.find<AuthProvider>();
      final permissions = auth.user.value?.permissions ?? [];

      return BottomNavController(
        permissions: permissions,
      );
    });

    Get.lazyPut(() => CartController());

    Get.put<OrdersController>(
      OrdersController(),
      permanent: true,
    );

    Get.lazyPut(() => ProfileController());
  }
}