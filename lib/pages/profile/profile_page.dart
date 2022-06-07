
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services_app/data/repository/user_repo.dart';
import 'package:services_app/pages/profile/profile_controller.dart';
import 'package:services_app/widgets/cirlce_image.dart';
import 'package:services_app/widgets/icon_btn.dart';
import 'package:services_app/widgets/my_btn.dart';
import 'package:services_app/widgets/progress_view.dart';

import '../../utils/my_colors.dart';
import '../../utils/strings.dart';
import '../../widgets/my_icon_text_field.dart';
import '../../widgets/my_text.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  ProfileController controller = Get.put(ProfileController(
    userRepo: UserRepo(),
  ));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.lightGrey,
        body: buildBody(),
      ),
    );
  }

  // build appbar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () {
          // pop back to mark page
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: MyColors.black54,
        ),
      ),
      title: MyText(
        text: Strings.profile,
        fontWeight: FontWeight.w700,
        color: MyColors.black,
        size: 18,
      ),
      centerTitle: true,
      actions: [

      ],
    );
  }

  // build body contents
  Widget buildBody() {
    return Obx(() => controller.isProgressEnabled.value? ProgressView() : Stack(
      children: [
        buildHeader(),
        buildBodyContents(),
      ],
    )
    );
  }

  // build header
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        /*borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),*/
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back button
            IconBtn(
              onClick: () {
                Get.back();
              },
              icon: Icons.arrow_back_ios_outlined,
              color: MyColors.white,
              size: 24,
            ),
            // title
            MyText(
              text: Strings.profile,
              fontWeight: FontWeight.w700,
              color: MyColors.white,
              size: 18,
            ),
            const SizedBox(width: 0, height: 0,),
          ],
        ),
      ),
    );
  }

  // build body contents
  Widget buildBodyContents() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            borderOnForeground: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10),),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildProfileImage(),
                    //const SizedBox(height: 10,),
                    //buildNumber(),
                    const SizedBox(height: 30,),
                    buildUpdateForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // build profile image
  Widget buildProfileImage() {
    return CircleImage(
      size: 100,
      imageUrl: controller.authUser.value != null && controller.authUser.value!.image != null?
        controller.authUser.value!.image! : null,
      onClick: () {
        // on profile image click
        pickImage(); // pick image from gallery
      },
    );
  }

  // build number
  Widget buildNumber() {
    return MyText(
      text: "+25677777777777",
      size: 16,
      fontFamilty: "Roboto",
      color: MyColors.black54,
      fontWeight: FontWeight.w500,
    );
  }

  // build update user profile form
  Widget buildUpdateForm() {
    return Column(
      children: [
        // name
        MyIconTextField(
          textEditingController: controller.nameEditingController,
          hint: Strings.name,
          focusNode: controller.nameFocusNode,
          nextFocusNode: controller.numberFocusNode,
          textInputAction: TextInputAction.next,
          icon: Icons.person,
          textInputType: TextInputType.text,
          error: controller.nameError.value,
        ),
        const SizedBox(height: 15,),
        // number
        MyIconTextField(
          textEditingController: controller.numberEditingController,
          hint: Strings.number,
          focusNode: controller.numberFocusNode,
          nextFocusNode: controller.emailFocusNode,
          textInputAction: TextInputAction.next,
          icon: Icons.call,
          textInputType: TextInputType.phone,
          error: controller.numberError.value,
        ),
        const SizedBox(height: 15,),
        // email
        MyIconTextField(
          textEditingController: controller.emailEditingController,
          hint: Strings.email,
          focusNode: controller.emailFocusNode,
          nextFocusNode: controller.companyFocusNode,
          textInputAction: TextInputAction.next,
          icon: Icons.email,
          textInputType: TextInputType.emailAddress,
          error: controller.emailError.value,
        ),
        const SizedBox(height: 15,),
        // company
        MyIconTextField(
          textEditingController: controller.companyEditingController,
          hint: Strings.compnay,
          focusNode: controller.companyFocusNode,
          nextFocusNode: controller.homeStreetFocusNode,
          textInputAction: TextInputAction.next,
          icon: Icons.badge,
          textInputType: TextInputType.text,
          error: controller.tagError.value,
        ),
        const SizedBox(height: 15,),
        // home street
        MyIconTextField(
          textEditingController: controller.homeStreetEditingController,
          hint: Strings.homeStreet,
          focusNode: controller.homeStreetFocusNode,
          nextFocusNode: null,
          textInputAction: TextInputAction.done,
          icon: Icons.location_on,
          textInputType: TextInputType.text,
          error: controller.homeStreetError.value,
        ),
        const SizedBox(height: 20,),
        MyBtn(
          onClick: () {
            // on update click
            onUpdate();
          },
          label: Strings.update.toUpperCase(),
          color: MyColors.primaryColor,
        ),
      ],
    );
  }

  // pick image form gallery
  void pickImage() async {
    if (await Permission.storage.request().isGranted) {
      // permission granted
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.updateUserImage(image.path);
      }
    }
  }

  // onUpdate
  // update user
  void onUpdate() {
    print("on update");
    controller.updateUser();
  }
}
