
import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/strings.dart';
import 'my_text.dart';

class ProgressView extends StatelessWidget {

  ProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: MyColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // text "Generating..."
            MyText(
              text: Strings.loading,
              size: 16,
              color: MyColors.primaryColor,
              fontFamilty: "Roboto",
            ),
            const SizedBox(height: 40,),
            // circular progress
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                strokeWidth: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
