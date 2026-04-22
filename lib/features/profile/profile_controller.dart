import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();

  var isLoading = false.obs;

  String get userName =>
      authProvider.user?.firstName ?? "User";

  String get email =>
      authProvider.user?.email ?? "No email";

  String get phone =>
    authProvider.user?.phoneNumber ?? "No phone";

  void logout() {
    authProvider.logout();
  }
}