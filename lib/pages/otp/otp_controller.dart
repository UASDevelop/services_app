
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/utils/my_routes.dart';
import 'package:services_app/utils/utils.dart';

class OtpController extends GetxController {

  OtpController({required this.authRepo, required this.userRepo});

  AuthRepo authRepo;
  UserRepo userRepo;

  var isProgressEnabled = false.obs;

  final otpEditingController = TextEditingController();

  final otpFocusNode = FocusNode();

  var otpError = "".obs;

  String number = "";

  String? verificationId;

  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> args = Get.arguments;
    number = args["number"];

    sendOtpCode();
  }

  // validate data
  // return boolean
  bool validate() {
    bool isValid = true;

    if (otpEditingController.text.isEmpty) {
      otpError.value = "required *.";
      isValid = false;
    }

    return isValid;
  }

  // send otp code with given number
  void sendOtpCode() {
    print(number);
    isProgressEnabled.value = true;
    authRepo.sendCode(number: number, resend: false, onCodeSent: (value) {
      isProgressEnabled.value = false;
      // value as verification id
      verificationId = value;
      Utils.showToast("OTP code sent to your given number");
    }, onError: () {
      isProgressEnabled.value = false;
      Utils.showErrorSnackbar("Unexpected error please try again or check your number");
    });
  }

  // resend code
  void resendCode() {
    isProgressEnabled.value = true;
    authRepo.sendCode(number: number, resend: true, onCodeSent: (value) {
      isProgressEnabled.value = false;
      // value as verification id
      verificationId = value;
      Utils.showToast("Code Resend successfully");
    }, onError: () {
      Utils.showErrorSnackbar("Unexpected error please try again or check your number");
      isProgressEnabled.value = false;
    });
  }

  // verify number
  void verifyNumber() {
    String code = otpEditingController.text;
    isProgressEnabled.value = true;
    authRepo.verifyNumber(verificationId!, code).then((value) {
      // login success
      isProgressEnabled.value = false;
      // create user in firestore
      createUser(value.uid, value.phoneNumber!);
    }).catchError((error) {
      isProgressEnabled.value = false;
      // login error
      print(error.toString());
      Utils.showErrorSnackbar(error.toString());
    });
  }

  // create user in firestore database
  void createUser(String id, String number) {
    isProgressEnabled.value = true;
    userRepo.createUser(id, number).then((value) {
      // success
      isProgressEnabled.value = false;
      Utils.showToast("Signed in success");
      // navigate to mark page
      navigateToHomePage();
    }).catchError((error) {
      // error
      isProgressEnabled.value = false;
      print(error);
      Utils.showErrorSnackbar(error);
      authRepo.logout();
    });
  }

  // navigate to mark page
  void navigateToHomePage() {
    MyRoutes.navigateToHomePage();
  }
}