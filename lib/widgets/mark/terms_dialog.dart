
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/my_colors.dart';
import '../../utils/strings.dart';
import '../my_text.dart';

class TermsDialog extends StatelessWidget {

  TermsDialog({
    required this.message,
});

  String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // dialog title
          MyText(
            text: Strings.terms,
            size: 18,
            fontWeight: FontWeight.w500,
            fontFamilty: "Roboto",
            color: MyColors.black,
          ),
          const SizedBox(height: 30,),
          // message
          Expanded(
            child: SingleChildScrollView(
              child: MyText(
                text: message,
                fontFamilty: "Roboto",
                size: 15,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                // on click ok button
                // dismiss dialog
                Get.back();
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.primaryColor,
                ),
                child: Center(
                  child: MyText(
                    text: Strings.ok,
                    fontFamilty: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
