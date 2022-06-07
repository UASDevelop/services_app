
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/user.dart' as Myuser;

class UserRepo extends GetxService {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String usersCollection = "users";

  Future<void> createUser(String id, String number) async {
    var document = await firestore.collection(usersCollection).doc(id).get();
    if (document.exists) {
      return;
    }else {
      try {
        await firestore.collection(usersCollection).doc(id).set({
          "id": id,
          "number": number,
        });
      } catch (e) {
        throw e.toString();
      }
    }
  }

  // get auth user
  void getAuthUser({onSuccess, onError}) {
     User? user = auth.currentUser;
     if (user != null) {
       print("uid:${user.uid}");
       firestore.collection(usersCollection).doc(user.uid).get().then((value) {
         Map<String, dynamic>? json = value.data();
         if (json != null) {
           Myuser.User myUser = Myuser.User.fromJson(json);
           onSuccess(myUser);
         }else {
           onError("Unexpected error please try again");
         }
       }).catchError((error) {
         onError(error.toString());
       });
     }
  }

  // update auth user
  void updateAuthUser(Myuser.User user, {onSuccess, onError}) {
    firestore.collection(usersCollection).doc(user.id).update(user.toJson()).then((value) {
      onSuccess();
    }, onError: (error) {
      onError(error.toString());
    });
  }

  // get all users
  void getAllUsers({onSuccess, onError}) {
    firestore.collection(usersCollection).get().then((value) {
      List<Myuser.User> users = [];
      for (var element in value.docs) {
        users.add(Myuser.User.fromJson(element.data()));
      }
      onSuccess(users);
    }).catchError((error) {
      onError(error.toString());
    });
  }

  // update point by current user
  void updatePoints(String docId, String authUid, int newPoints, int oldPoints, {onSuccess, onError}) {
    //print("update points:${user.points.length}");
    firestore.collection(usersCollection).doc(docId).update({
      "points": FieldValue.arrayRemove([{"user_id": authUid, "point": oldPoints}]),
    }).then((value) {
      firestore.collection(usersCollection).doc(docId).update({
        "points": FieldValue.arrayUnion([{"user_id": authUid, "point": newPoints}]),
      }).then((value) {
        onSuccess();
      }).catchError((error) {
        onError(error.toString());
      });
    }).catchError((error) {
      onError(error.toString());
    });
  }

  // create point by current user
  void createPoints(String docId, String authUid, int points, {onSuccess, onError}) {
    //print("update points:${user.points.length}");
    firestore.collection(usersCollection).doc(docId).update({
      "points": FieldValue.arrayUnion([{"user_id": authUid, "point": points}]),
    }).then((value) {
      onSuccess();
    }).catchError((error) {
      onError(error.toString());
    });
  }
  
  // search users by name
  void searchUsersByName(String query, {onSuccess, onError}) {
    print("searching...");
    firestore.collection(usersCollection).get().then((value) {
      List<Myuser.User> users = [];
      for (var element in value.docs) {
        users.add(Myuser.User.fromJson(element.data()));
      }
      print("Result: ${users.length}");
      onSuccess(users);
    }).catchError((error) {
      onError(error.toString());
    });
  }

  // upload user image
  void uploadUserImage(String path, {onSuccess, onError}) async {
    User? user = auth.currentUser;

    if (user != null) {
      final storageRef = FirebaseStorage.instance.ref();
      File file = File(path);

      String fileName = DateTime.now().microsecond.toString() + ".jpg";
      final mountainsRef = storageRef.child(fileName);

      try {
        var task = await mountainsRef.putFile(file);
        var url = await task.ref.getDownloadURL();
        print("download url: $url");
        firestore.collection(usersCollection).doc(user.uid).update(
          {"image": url}
        ).then((value) {
          onSuccess(url);
        }).catchError((error) {
          onError(error.toString());
        });
      } catch (e) {
        onError(e.toString());
      }
    }else {
      onError("Unexpected error please close and reopen app");
    }
  }
}