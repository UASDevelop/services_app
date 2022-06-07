
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/utils/my_routes.dart';

class LoginController extends GetxController with WidgetsBindingObserver{

  LoginController({required this.authRepo});

  AuthRepo authRepo;

  var isProgressEnabled = false.obs;

  final numberEditingController = TextEditingController();

  final numberFocusNode = FocusNode();

  var numberError = "".obs;

  var countryCode = "+1".obs;

  @override
  void onInit() {
    super.onInit();

    // check login status
    //checkLoginStatus();
  }

  // check login status
  void checkLoginStatus() async {
    isProgressEnabled.value = true; // show progress
    await Future.delayed(const Duration(seconds: 1), (){});
    isProgressEnabled.value = false; // hide progress
    try {
      User user = authRepo.checkAuthStatus();
      navigateToHomePage();
    } catch (e) {
      print(e.toString());
    }
  }

  // validate data
  bool validate() {
    bool isValid = true;

    if (numberEditingController.text.isEmpty) {
      numberError.value = "required *.";
      isValid = false;
    }

    return isValid;
  }

  // navigate to otp page with number
  void authenticate() {
    String fullNumber = countryCode.value + numberEditingController.text;
    MyRoutes.navigateToOtpPage(fullNumber); // navigate to OTP page with number
  }

  // navigate to mark page
  void navigateToHomePage() {
    MyRoutes.navigateToHomePage();
  }

}