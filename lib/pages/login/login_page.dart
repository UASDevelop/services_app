
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:services_app/data/repository/auth_repo.dart';
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

class LoginPage extends StatelessWidget {

  LoginPage({Key? key}) : super(key: key);

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

  // build body weather show progress or main body contents
  Widget buildBody() {
    return Obx(() =>
        controller.isProgressEnabled.value? ProgressView() : buildMainBody(),
    );
  }

  // build main body contents
  Widget buildMainBody() {
    return LayoutBuilder(builder: (context, constraints) {
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
              width: 90,
              height: 60,
            ),
            const SizedBox(height: 30,),
            MyText(
              text: Strings.mobileNumber,
              size: 16,
              color: MyColors.white,
              fontFamilty: "Roboto",
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 20,),
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
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),),
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
                const SizedBox(height: 20,),
                // Authenticate button
                MyBtn(
                  onClick: () {
                    print("on authenticate");
                    // on authenticate
                    onAuthenticate();
                  },
                  label: Strings.authenticate,
                  color: MyColors.primaryColor,
                ),
                const SizedBox(height: 30,),
                //buildSocialLogins(),
              ],
            ),
          ),
        ),
      ),
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

  // check data validation and then authenticate(navigate to OTP page)
  void onAuthenticate() {
    if (controller.validate()) {
      controller.authenticate();
    }
  }
}
