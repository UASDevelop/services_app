

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/utils/utils.dart';

import '../../data/models/user.dart' as MyUser;

class MarkController extends GetxController {

  MarkController({
    required this.userRepo,
    required this.authRepo,
});

  UserRepo userRepo;
  AuthRepo authRepo;

  var isProgressEnabled = false.obs;

  var users = <MyUser.User>[].obs;
  var displayUsers = <MyUser.User>[].obs;

  @override
  void onInit() {
    super.onInit();

    // get auth user
    getUsers();
  }

  // get all users
  void getUsers() {
    isProgressEnabled.value = true;
    userRepo.getAllUsers(onSuccess: (value) {
      isProgressEnabled.value = false;
      users.value = value;
      sortUsers(value);
    }, onError: (error) {
      isProgressEnabled.value = false;
      print(error);
      Utils.showErrorSnackbar(error);
    });
  }

  // sort users according to highest points on top
  void sortUsers(List<MyUser.User> users) {
    users.sort((a, b) {
      int aC = getPointSum(a.points);
      int bC = getPointSum(b.points);
      return bC.compareTo(aC);
    });

    displayUsers.value = users;
  }

  // get sum of total points in given points
  int getPointSum(List<MyUser.Point> points) {
    int sum = 0;
    points.forEach((element) {
      sum = sum + element.point!;
    });

    return sum;
  }

  // get the selcted point whihc is selected by current user
  int getSelectedPoint(MyUser.User myUser) {
    int point = 5;
    User? user = authRepo.getAuthUser();
    if (user != null && myUser.points.isNotEmpty) {
      for (var element in myUser.points) {
        if (element.userId == user.uid) {
          point = element.point!;
          break;
        }
      }
    }

    return point;
  }

  // update points by current auth selected
  void updatePoints(MyUser.User user, int points) {
    User? authUser = authRepo.getAuthUser();
    if (authUser != null) {
      MyUser.Point userPoint = MyUser.Point(userId: authUser.uid, point: points);
      int? index = _isPointsExists(user, authUser.uid);
      int? oldPoints = getOldPoints(user, authUser.uid);
      if (index != null) {
        // remove point in array
        user.points.removeAt(index);
      }

      // add point to array
      // and make changes in users list
      user.points.add(userPoint);
      user.authUserPoints = points;
      users.value.remove(user);
      users.value.add(user);
      sortUsers(users);

      if (index != null && oldPoints != null) {
        // update point entry in firestore
        userRepo.updatePoints(user.id!, authUser.uid, points, oldPoints, onSuccess: () {

        }, onError: (error) {
          print(error);
          Utils.showErrorSnackbar(error);
        });
      }else {
        // create new point entry in firestore
        userRepo.createPoints(user.id!, authUser.uid, points, onSuccess: () {

        }, onError: (error) {
          print(error);
          Utils.showErrorSnackbar(error);
        });
      }
    }
  }

  // is points already exists
  int? _isPointsExists(MyUser.User user, String uid) {
    int? index;
    int arrayIndex = 0;
    for (var element in user.points) {
      if (element.userId == uid) {
        index = arrayIndex;
        break;
      }
      arrayIndex++;
    }
    return index;
  }

  // get old points
  int? getOldPoints(MyUser.User user, String uid) {
    int? points;
    for (var element in user.points) {
      if (element.userId == uid) {
        points = element.point;
        break;
      }
    }

    return points;
  }
}