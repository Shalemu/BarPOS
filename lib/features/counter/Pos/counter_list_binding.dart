import 'package:barpos/features/counter/Pos/counter_list_controller.dart';
import 'package:get/get.dart';


class ItemListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterListController>(
      () => CounterListController(),
    );
  }
}