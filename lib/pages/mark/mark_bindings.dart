
import 'package:get/get.dart';
import 'package:services_app/pages/mark/mark_controller.dart';

class MarkBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MarkController>(() => MarkController(userRepo: Get.find(), authRepo: Get.find()));
  }

}