

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/widgets/search/filter_radio_btn_values.dart';
import 'package:services_app/widgets/search/search_filters.dart';


import '../../data/models/doctor.dart';
import '../../data/models/user.dart' as MyUser;
import '../../utils/utils.dart';

class SearchController extends GetxController {

  SearchController({required this.authRepo, required this.userRepo});

  AuthRepo authRepo;
  UserRepo userRepo;

  final searchEditingController = TextEditingController();

  final searchFocusNode = FocusNode();

  var isProgressEnabled = false.obs;

  var users = <MyUser.User>[].obs;

  var filter = SearchFilters.name.obs;

  var filterGroupValue = FilterRadioBtnValues.name.obs;

  bool isQueryCleared = false;

  // search resut by query
  void search(String query) {
    users.clear();
    if (query.isEmpty) {
      print("empty search...");
      users.clear();
      isQueryCleared = true;
    }else if (filterGroupValue.value == FilterRadioBtnValues.name) {
      isQueryCleared = false;
      searchByName(query);
    }else if (filterGroupValue.value == FilterRadioBtnValues.company) {
      isQueryCleared = false;
      searchByCompany(query);
    }else if (filterGroupValue.value == FilterRadioBtnValues.email) {
      isQueryCleared = false;
      searchByEmail(query);
    }else if (filterGroupValue.value == FilterRadioBtnValues.number) {
      isQueryCleared = false;
      searchByNumber(query);
    }
  }

  // search by name
  void searchByName(String query) {
    isProgressEnabled.value = true;
    userRepo.getAllUsers(onSuccess: (value) {
      isProgressEnabled.value = false;
      if (!isQueryCleared) {
        users.clear();
        List<MyUser.User> _users = value;
        _users.forEach((element) {
          if (element.name != null) {
            String name = element.name!;
            if (name.toLowerCase().contains(query)) {
              users.value.add(element);
            }
          }
        });
        print("users length: ${users.value.length}");
      }
    }, onError: (error) {
      isProgressEnabled.value = false;
      print(error);
    });
  }

  // search by email
  void searchByEmail(String query) {
    isProgressEnabled.value = true;
    userRepo.getAllUsers(onSuccess: (value) {
      isProgressEnabled.value = false;
      if (!isQueryCleared) {
        users.clear();
        List<MyUser.User> _users = value;
        _users.forEach((element) {
          if (element.email != null) {
            String email = element.email!;
            if (email.toLowerCase().contains(query)) {
              users.value.add(element);
            }
          }
        });
        print("users length: ${users.value.length}");
      }
    }, onError: (error) {
      isProgressEnabled.value = false;
      print(error);
    });
  }

  // search by company
  void searchByCompany(String query) {
    isProgressEnabled.value = true;
    userRepo.getAllUsers(onSuccess: (value) {
      isProgressEnabled.value = false;
      if (!isQueryCleared) {
        users.clear();
        List<MyUser.User> _users = value;
        _users.forEach((element) {
          if (element.company != null) {
            String company = element.company!;
            if (company.toLowerCase().contains(query)) {
              users.value.add(element);
            }
          }
        });
        print("users length: ${users.value.length}");
      }
    }, onError: (error) {
      isProgressEnabled.value = false;
      print(error);
    });
  }

  // search by number
  void searchByNumber(String query) {
    isProgressEnabled.value = true;
    userRepo.getAllUsers(onSuccess: (value) {
      isProgressEnabled.value = false;
      if (!isQueryCleared) {
        users.clear();
        List<MyUser.User> _users = value;
        _users.forEach((element) {
          if (element.number != null) {
            String number = element.number!;
            if (number.toLowerCase().contains(query)) {
              users.value.add(element);
            }
          }
        });
        print("users length: ${users.value.length}");
      }
    }, onError: (error) {
      isProgressEnabled.value = false;
      print(error);
    });
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
      users.refresh();
      //sortUsers(users);

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
