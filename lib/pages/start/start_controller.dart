
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';

import '../../utils/my_routes.dart';

class StartController extends GetxService {

  StartController({required this.authRepo});

  AuthRepo authRepo;

  @override
  void onInit() {
    super.onInit();

    // check login status
    checkLoginStatus();
  }

  // check login status
  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1), (){});
    try {
      User user = authRepo.checkAuthStatus();
      navigateToHomePage();
    } catch (e) {
      print(e.toString());
      navigateToLoginPage();
    }
  }

  // navigate to mark page
  void navigateToHomePage() {
    MyRoutes.navigateToHomePage();
  }

  // navigate to login page
  void navigateToLoginPage() {
    MyRoutes.navigateToLoginPage();
  }
}