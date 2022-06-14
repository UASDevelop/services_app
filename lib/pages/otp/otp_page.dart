
import 'package:flutter/material.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/otp/otp_controller.dart';
import 'package:get/get.dart';
import 'package:services_app/utils/my_routes.dart';
import 'package:services_app/widgets/my_icon_text_field.dart';
import 'package:services_app/widgets/text_btn.dart';

import '../../utils/my_colors.dart';
import '../../utils/strings.dart';
import '../../widgets/my_btn.dart';
import '../../widgets/my_text.dart';
import '../../widgets/progress_view.dart';

class OtpPage extends StatelessWidget {

  OtpPage({Key? key}) : super(key: key);

  OtpController controller = Get.put(OtpController(
    authRepo: AuthRepo(),
    userRepo: UserRepo(),
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
    return Obx(
      () =>
          controller.isProgressEnabled.value ? ProgressView() : buildMainBody(),
    );
  }

  // build main body
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
                Icons.dialpad,
                color: MyColors.white,
                size: 50,
              ),
            ),*/
            Image.asset(
              "assets/images/logos.png",
              width: 70,
              height: 60,
            ),
            const SizedBox(height: 50,),
            MyText(
              text: Strings.otp,
              size: 16,
              color: MyColors.white,
              fontFamilty: "Roboto",
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 20,),
            MyText(
              text: "Please enter the OTP sent to your mobile number",
              size: 13,
              color: MyColors.white,
              fontFamilty: "Roboto",
            ),
          ],
        ),
      ),
    );
  }

  // build Form
  Widget buildForm() {
    return Flexible(
      flex: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // otp text field
              MyIconTextField(
                textEditingController: controller.otpEditingController,
                hint: Strings.enterOtp,
                focusNode: controller.otpFocusNode,
                nextFocusNode:  null,
                textInputAction: TextInputAction.done,
                icon: Icons.dialpad_outlined,
                error: controller.otpError.value,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 30,),
              // submit button
              MyBtn(
                onClick: () {
                  // on submit
                  onSubmit();
                },
                label: Strings.submit,
                color: MyColors.primaryColor,
              ),
              const SizedBox(height: 40,),
              MyText(
                text: "Didn't receive OTP?",
                color: MyColors.black54,
              ),
              const SizedBox(height: 10,),
              TextBtn(
                onClick: () {
                  // on reset click
                  // resend code
                  controller.resendCode();
                },
                label: Strings.resendOtp,
                underline: true,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // on submit
  void onSubmit() {
    if (controller.validate()) {
      // data validated
      controller.verifyNumber();
    }
  }
}
