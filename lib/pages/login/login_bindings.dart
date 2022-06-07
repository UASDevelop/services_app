
import 'package:get/instance_manager.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/pages/login/login_controller.dart';

class LoginBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthRepo>(() => AuthRepo());
    Get.lazyPut<LoginController>(() => LoginController(authRepo: Get.find()));
  }

}