import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:barpos/services/model/counters_model.dart';

class CounterProvider extends GetxController {
  final box = GetStorage();

  var selectedCounter = Rxn<CounterModel>();
  var selectedCounterId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    loadSavedCounter();
  }

  void setCounter(CounterModel counter) {
    selectedCounter.value = counter;
    selectedCounterId.value = counter.id;

    // persist
    box.write("counter_id", counter.id);
  }

  void loadSavedCounter() {
    final id = box.read("counter_id");
    if (id != null) {
      selectedCounterId.value = id;
    }
  }

  void clearCounter() {
    selectedCounter.value = null;
    selectedCounterId.value = null;

    box.remove("counter_id");
  }
}