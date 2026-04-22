
import 'package:get/get.dart';


class HomeController extends GetxController {
  var counters = <String>[].obs;
  var selectedCounter = RxnString();
  var selectedCategory = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCounters();
  }

  void loadCounters() {
    // Replace with API later
    counters.value = ["Main Bar", "VIP", "Outdoor"];
  }

  void selectCounter(String counter) {
    selectedCounter.value = counter;
  }

  // Map: productIndex -> quantity
var quantities = <int, int>{}.obs;

int getQty(int index) => quantities[index] ?? 0;

void increaseQty(int index) {
  quantities[index] = getQty(index) + 1;
}

void decreaseQty(int index) {
  final current = getQty(index);
  if (current > 0) {
    quantities[index] = current - 1;
  }
}

void setQty(int index, int value) {
  quantities[index] = value < 0 ? 0 : value;
}
}