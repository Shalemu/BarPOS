import 'package:get/get.dart';
import 'add_items_controller.dart';

class AddItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddItemsController());
  }
}