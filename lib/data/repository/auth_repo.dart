
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepo extends GetxService {

  FirebaseAuth auth = FirebaseAuth.instance;

  // check current auth status
  User checkAuthStatus() {
    User? user =  auth.currentUser;
    if (user != null) {
      return user;
    }else {
      throw "User is current signed out!";
    }
  }

  // get firebase auth user
  User? getAuthUser() {
    return auth.currentUser;;
  }

  // send code
  void sendCode({required String number, required bool resend,
    required Function onCodeSent, required Function onError}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: number,
      codeSent: (String verificationId, int? resendToken) async {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onError();
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
      verificationFailed: (FirebaseAuthException error) {
        onError();
      },
      forceResendingToken: resend? 1 : 0,
    );
  }

  // verify number and sign in
  Future<User> verifyNumber(String verificationId, String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

    // Sign the user in (or link) with the credential
    UserCredential userCredential = await auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      return userCredential.user!;
    }else {
      throw "Unable to SignIn please try again";
    }
  }

  // logout user
  Future<void> logout() async {
    await auth.signOut();
  }
}