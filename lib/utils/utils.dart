
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Utils {

  // show error snackbar
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      colorText: Colors.white,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
        size: 24,
      ),
      backgroundColor: Colors.black,
      snackPosition: SnackPosition.BOTTOM
    );
  }

  // show success snack bar
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
        "Success",
        message,
        colorText: Colors.white,
        icon: const Icon(
          Icons.done,
          color: Colors.white,
          size: 24,
        ),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP
    );
  }

  // check registration no reg
  static bool checkRegistrationNoReg(String value) {
    return RegExp(r'^[A-Z0-9]$').hasMatch(value);
  }

  // show toast
  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}