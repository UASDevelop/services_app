

import 'package:firebase_auth/firebase_auth.dart';

class User {
  String? id;
  String? name;
  String? number;
  String? image;
  String? streetAddress;
  String? company;
  String? email;
  List<Point> points = [];
  int authUserPoints = 5;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    image = json['image'];
    streetAddress = json['street_address'];
    company = json['company'];
    email = json['email'];
    List? pointList = json['points'];
    if (pointList != null) {
      points = pointList.map((i) => Point.fromJson(i)).toList();
    }
    authUserPoints = getAuthUserPoints(points); // get auth user points from points array
  }

  // to json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['company'] = company;
    json['email'] = email;
    json['number'] = number;
    json['street_address'] = streetAddress;

    return json;
  }

  // get auth user points from points
  int getAuthUserPoints(List<Point> points) {
    int p = 5;
    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      for (var element in points) {
        if (element.userId == uid) {
          p = element.point!;
          break;
        }
      }
    }

    return p;
  }
}

class Point {
  String? userId;
  int? point;

  Point({this.userId, this.point});

  Point.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    point = json['point'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_id'] = userId;
    json['point'] = point;

    return json;
  }
}