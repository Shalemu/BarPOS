import 'package:get/get.dart';

class AuthController extends GetxController {
  var user = Rxn<dynamic>();
  var accessToken = ''.obs;
  var refreshToken = ''.obs;

  void login(dynamic userModel, String access, String refresh) {
    user.value = userModel;
    accessToken.value = access;
    refreshToken.value = refresh;
  }

  void logout() {
    user.value = null;
    accessToken.value = '';
    refreshToken.value = '';
  }
}