
import 'package:get/get.dart';
import 'package:services_app/pages/home/home_bindings.dart';
import 'package:services_app/pages/home/home_page.dart';
import 'package:services_app/pages/login/login_bindings.dart';
import 'package:services_app/pages/login/login_page.dart';
import 'package:services_app/pages/mark/mark_bindings.dart';
import 'package:services_app/pages/mark/mark_page.dart';
import 'package:services_app/pages/otp/otp_bindings.dart';
import 'package:services_app/pages/otp/otp_page.dart';
import 'package:services_app/pages/profile/profile_bindings.dart';
import 'package:services_app/pages/profile/profile_page.dart';
import 'package:services_app/pages/search/search_bindings.dart';
import 'package:services_app/pages/search/search_page.dart';

class MyRoutes {

  // navigate to Login Page
  static Future<void> navigateToLoginPage() async{
    return await Get.offAll(() => LoginPage(), binding: LoginBindings(),);
  }

  // navigate to otp page
  static Future<void> navigateToOtpPage(String number) async{
    Map<String, dynamic> args = {
      "number": number,
    };

    return await Get.to(() => OtpPage(), binding: OtpBindings(), arguments: args);
  }

  // navigate to mark page
  static Future<void> navigateToHomePage() async{
    return await Get.offAll(() => HomePage(), binding: HomeBindings(),);
  }

  // navigate to mark page
  static Future<void> navigateToMarkPage() async{
    return await Get.to(() => MarkPage(), binding: MarkBinding(),);
  }

  // navigate to search page
  static Future<void> navigateToSearchPage() async{
    return await Get.to(() => SearchPage(), binding: SearchBindings(),);
  }

  // navigate to profile page
  static Future<void> navigateToProfilePage() async{
    return await Get.to(() => ProfilePage(), binding: ProfileBindings(),);
  }
}