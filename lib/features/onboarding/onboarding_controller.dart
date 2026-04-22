import 'package:barpos/features/onboarding/models/onboarding_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OnboardingController extends GetxController {
  Rx<Onboarding001Model> onboarding001ModelObj = Onboarding001Model().obs;

  @override
  void onReady() {
    super.onReady();
   
  }

  @override
  void onClose() {
    super.onClose();
  }
}
