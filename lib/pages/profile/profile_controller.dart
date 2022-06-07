
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/utils/utils.dart';
import '../../data/models/user.dart' as MyUser;

class ProfileController extends GetxController {

  ProfileController({
    required this.userRepo,
});

  UserRepo userRepo;

  final nameEditingController = TextEditingController();
  final companyEditingController = TextEditingController();
  final homeStreetEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final numberEditingController = TextEditingController();

  final nameFocusNode = FocusNode();
  final companyFocusNode = FocusNode();
  final homeStreetFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final numberFocusNode = FocusNode();

  var nameError = "".obs;
  var tagError = "".obs;
  var homeStreetError = "".obs;
  var emailError = "".obs;
  var numberError = "".obs;

  var isProgressEnabled = false.obs;

  Rxn<MyUser.User> authUser = Rxn();

  @override
  void onInit() {
    super.onInit();

    // get and initialize user data
    initUserData();
  }

  // get auth user data and initialize in fields
  void initUserData() {
    userRepo.getAuthUser(onSuccess: (value) {
      authUser.value = value;
      authUser.refresh();
      if (authUser != null) {
        nameEditingController.text = authUser.value!.name != null? authUser.value!.name! : "";
        companyEditingController.text = authUser.value!.company != null? authUser.value!.company! : "";
        emailEditingController.text = authUser.value!.email != null? authUser.value!.email! : "";
        numberEditingController.text = authUser.value!.number != null? authUser.value!.number! : "";
        homeStreetEditingController.text = authUser.value!.streetAddress != null? authUser.value!.streetAddress! : "";
      }
    }, onError: (error) {
      print(error.toString());
    });
  }

  // update data
  void updateUser() {
    if (authUser.value != null) {
      authUser.value!.name = nameEditingController.text;
      authUser.value!.company = companyEditingController.text;
      authUser.value!.email = emailEditingController.text;
      authUser.value!.number = numberEditingController.text;
      authUser.value!.streetAddress = homeStreetEditingController.text;

      isProgressEnabled.value = true;
      userRepo.updateAuthUser(authUser.value!, onSuccess: () {
        isProgressEnabled.value = false;
        Utils.showToast("User updated");
      }, onError: (error) {
        isProgressEnabled.value = false;
        print(error);
        Utils.showErrorSnackbar(error);
      });
    }
  }

  // update user image
  void updateUserImage(String path) {
    isProgressEnabled.value = true;
    userRepo.uploadUserImage(path, onSuccess: (value) {
      isProgressEnabled.value = false;
      // value as url
      authUser.value!.image = value;
      authUser.refresh();
    }, onError: (error) {
      isProgressEnabled.value = false;
      print("Error: $error");
      Utils.showErrorSnackbar(error);
    });
  }
}