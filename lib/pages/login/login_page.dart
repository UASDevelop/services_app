import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/utils/my_routes.dart';
import 'package:services_app/utils/strings.dart';
import 'package:services_app/widgets/icon_btn.dart';
import 'package:services_app/widgets/mobile_input_field.dart';
import 'package:services_app/widgets/my_btn.dart';
import 'package:services_app/widgets/my_text.dart';
import 'package:services_app/widgets/progress_view.dart';

import '../home/home_page.dart';
import 'emailsigin.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String usersCollection = "users";

  Future<void> createUser(String id,String? email ) async {
    var document = await firestore.collection(usersCollection).doc(auth.currentUser!.uid).get();
    if (document.exists) {
      return;
    }else {
      try {
        await firestore.collection(usersCollection).doc(auth.currentUser!.uid).set({
          "id":auth.currentUser!.uid,
          "email": auth.currentUser!.email,
        });
      } catch (e) {
        throw e.toString();
      }
    }
  }
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  LoginController controller = Get.put(LoginController(
    authRepo: AuthRepo(),
  ));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: buildBody(),
      ),
    );
  }
  Future<void> handleSignIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      var user = await _googleSignIn.signIn();
      print(user?.email);
      print(user?.displayName);
      print(user?.photoUrl);
      if (user != null) {
          navigateToHomePagese();



        GoogleSignInAuthentication _auhentication = await user.authentication;
        AuthCredential _credential = GoogleAuthProvider.credential(
            idToken: _auhentication.idToken,
            accessToken: _auhentication.accessToken);
        UserCredential result = await _auth.signInWithCredential(_credential);
        print(_credential);
        FirebaseAuth auth= FirebaseAuth.instance;
        return createUser(auth.currentUser!.uid, auth.currentUser!.email);

      }
    } catch (error) {
      print(error);
    }
  }


  // build body weather show progress or main body contents
  Widget buildBody() {
    return Obx(
      () =>
          controller.isProgressEnabled.value ? ProgressView() : buildMainBody(),
    );
  }

  // build main body contents
  Widget buildMainBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  buildHeader(),
                  buildForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // build header
  Widget buildHeader() {
    return Flexible(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.contact_phone_outlined,
                color: MyColors.white,
                size: 50,
              ),
            ),*/
            Image.asset(
              "assets/images/logos.png",
              width: 170,
              height: 130,
            ),
            
            MyText(
              text: Strings.mobileNumber,
              size: 16,
              color: MyColors.white,
              fontFamilty: "Roboto",
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 20,
            ),
            MyText(
              text: "We need to send OTP to authenticate your number",
              size: 13,
              color: MyColors.white,
              fontFamilty: "Roboto",
            ),
          ],
        ),
      ),
    );
  }

  // build form
  Widget buildForm() {
    return Flexible(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MobileInputField(
                  textEditingController: controller.numberEditingController,
                  hint: Strings.mobileNumber,
                  focusNode: controller.numberFocusNode,
                  nextFocusNode: null,
                  textInputAction: TextInputAction.done,
                  icon: Icons.phone_android,
                  error: controller.numberError.value,
                  countryCode: controller.countryCode.value,
                  textInputType: TextInputType.phone,
                  onCountryCodeChanged: (value) {
                    // on country code change VALUE as Country Code
                    controller.countryCode.value = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // Authenticate button
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Row(
                    children: [
                      MyBtn(
                        onClick: () {
                          print("on authenticate");
                          // on authenticate
                          onAuthenticate();
                        },
                        label: Strings.authenticate,
                        color: MyColors.primaryColor,
                      ),
                      SizedBox(width: 10,),
                      Emailpassword()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //buildSocialLogins(),
          Container(
            height: 50,
            width: 290,
            child: FlatButton(
              color: MyColors.primaryColor,
                onPressed: (){
                  handleSignIn();
                },
              child: Text(Strings.googlename,style: TextStyle(color: MyColors.white),),
            ),
          ),

                SizedBox(width: 25,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Emailpassword() {
    return MyBtn(
      onClick: () {
        print("Email singin");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            emailloginpage()
        ));

      },
      label: Strings.emailpasword,
      color: MyColors.primaryColor,
    );
  }

  /*Widget buildSocialLogins() {
    return Column(
      children: [
        // Text "Or Login with"
        MyText(
          text: "Or Login with",
          fontFamilty: "Roboto",
          fontWeight: FontWeight.w500,
          color: MyColors.black54,
          size: 18,
        ),
        const SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // face book button
            InkWell(
              onTap: () {

              },
              child: SvgPicture.asset(
                "assets/images/facebook.svg",
                width: 36,
                height: 36,
              ),
            ),
            const SizedBox(width: 20,),
            // Google button
            InkWell(
              onTap: () {

              },
              child: SvgPicture.asset(
                "assets/images/google.svg",
                width: 36,
                height: 36,
              ),
            ),
          ],
        ),
      ],
    );
  }*/
  void onAuthenticate() {
    if (controller.validate()) {
      controller.authenticate();
    }
  }
   navigateToHomePagese() {
    MyRoutes.navigateToHomePage();
  }
}
