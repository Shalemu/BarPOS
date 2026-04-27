import 'package:barpos/core/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:barpos/provider/auth_provider.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();

  var isLoading = false.obs;

  String get userName => authProvider.user.value?.firstName ?? "User";

  String get email => authProvider.user.value?.email ?? "No email";

  String get phone => authProvider.user.value?.phoneNumber ?? "No phone";

  Future<void> logout() async {
    await authProvider.logout(); // clears storage + token
    Get.offAllNamed(AppRoutes.login); // force navigation
  }
}
