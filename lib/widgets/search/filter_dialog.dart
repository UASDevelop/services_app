

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/utils/strings.dart';
import 'package:services_app/widgets/my_btn.dart';
import 'package:services_app/widgets/my_text.dart';
import 'package:services_app/widgets/search/filter_radio_btn_values.dart';

class FilterDialog extends StatelessWidget {

  FilterDialog({
    required this.groupValue,
    required this.onChanged,
    required this.onApply,
});

  int groupValue;
  Function onChanged;
  Function onApply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // name
          buildFilterRadioBtn(
            Strings.name,
            groupValue,
            FilterRadioBtnValues.name,
            (value) {
              print("onchanged");
              onChanged(value);
            },
          ),
          const SizedBox(height: 15,),
          // company
          buildFilterRadioBtn(
            Strings.compnay,
            groupValue,
            FilterRadioBtnValues.company,
                (value) {
                  print("onchanged");
              onChanged(value);
            },
          ),
          const SizedBox(height: 15,),
          // email
          buildFilterRadioBtn(
            Strings.email,
            groupValue,
            FilterRadioBtnValues.email,
                (value) {
              onChanged(value);
            },
          ),
          const SizedBox(height: 15,),
          // number
          buildFilterRadioBtn(
            Strings.number,
            groupValue,
            FilterRadioBtnValues.number,
                (value) {
              onChanged(value);
            },
          ),
          const SizedBox(height: 20,),
          // apply button
          MyBtn(
            onClick: () {
              // on apply button
              onApply(groupValue);
              Get.back();
            },
            label: Strings.apply,
            color: MyColors.primaryColor,
          ),
        ],
      ),
    );
  }

  // build filter radio button
  Widget buildFilterRadioBtn(String label, int groupValue, int value, Function onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: label,
          fontFamilty: "Roboto",
          color: MyColors.black,
          size: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: Radio(
            groupValue: groupValue,
            value: value,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
