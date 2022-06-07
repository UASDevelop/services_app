
import 'package:get/get.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/home/home_controller.dart';

class HomeBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<UserRepo>(() => UserRepo());
    Get.lazyPut<HomeController>(() => HomeController(userRepo: Get.find()));
  }

}