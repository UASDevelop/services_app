

import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/widgets/my_text.dart';

class CoinNumber extends StatelessWidget {

  CoinNumber({
    required this.onSelect,
    required this.number,
    required this.isSelected,
});

  int number;
  Function onSelect;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect();
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isSelected? MyColors.white : MyColors.primaryColor,
        ),
        child: Center(
          child: MyText(
            text: number.toString(),
            color: isSelected? MyColors.primaryColor :  MyColors.white,
            size: 11,
          ),
        ),
      ),
    );
  }
}
