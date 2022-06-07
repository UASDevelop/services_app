
import 'package:get/get.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/otp/otp_controller.dart';

class OtpBindings extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut<UserRepo>(() => UserRepo());
    Get.lazyPut<OtpController>(() => OtpController(authRepo: Get.find(),
        userRepo: Get.find()));
  }


}