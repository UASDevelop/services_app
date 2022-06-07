

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:services_app/data/repository/auth_repo.dart';
import 'package:services_app/pages/start/start_controller.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/widgets/progress_view.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  StartController controller = Get.put(
    StartController(authRepo: AuthRepo()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
          strokeWidth: 6,
        ),
      ),
    );
  }
}
