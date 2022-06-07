

import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/pages/start/start_controller.dart';

class StartBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthRepo>(() => AuthRepo());
    Get.lazyPut<StartController>(() => StartController(authRepo: Get.find()));
  }

}