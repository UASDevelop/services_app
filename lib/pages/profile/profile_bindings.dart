
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/profile/profile_controller.dart';

class ProfileBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthRepo>(() => AuthRepo());
    Get.lazyPut<UserRepo>(() => UserRepo());
    Get.lazyPut<ProfileController>(() => ProfileController(userRepo: Get.find()));
  }


}