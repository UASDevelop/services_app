
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/data/models/doctor.dart';
import 'package:services_app/data/repository/user_repo.dart';

import '../../data/models/user.dart';

class HomeController extends GetxController with WidgetsBindingObserver{

  HomeController({
    required this.userRepo,
});

  UserRepo userRepo;

  Rxn<User> user = Rxn();
  var pointsInPercent = 100.0.obs;

  @override
  void onInit() {
    super.onInit();

    // get auth user
    getAuthUser();
  }

  // get auth user
  void getAuthUser() {
    userRepo.getAuthUser(onSuccess: (value) {
      // value as User
      user.value = value;
      user.refresh();
      // calculate user points percentage
      calculatePoints();
    }, onError: (error) {
      // error
      print(error);
    });
  }

  // calculate points
  void calculatePoints() {
    if (user.value != null && user.value!.points.isNotEmpty) {
      int sum = 0;
      int length = user.value!.points.length;
      for (var element in user.value!.points) {
        sum = sum + element.point!;
      }
      double r = sum / (5 * length);
      pointsInPercent.value = (r * 100.0);
    }

  }

}