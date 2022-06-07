
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/search/search_controller.dart';

class SearchBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<UserRepo>(() => UserRepo());
    Get.lazyPut<AuthRepo>(() => AuthRepo());
    Get.lazyPut<SearchController>(() => SearchController(authRepo: Get.find(),
        userRepo: Get.find()));
  }

}