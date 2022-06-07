
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';
import 'package:services_app/widgets/my_text.dart';

class HomeFooterSplitBtn extends StatelessWidget {

  HomeFooterSplitBtn({
    required this.onClick,
    required this.label,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
});

  Function onClick;
  String label;
  double topLeftRadius;
  double topRightRadius;
  double bottomLeftRadius;
  double bottomRightRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: MyColors.black54, width: 1),
            bottom: BorderSide(color: MyColors.black54, width: 1),
            left: BorderSide(color: MyColors.black54, width: 1),
            right: BorderSide(color: MyColors.black54, width: 1),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            topRight: Radius.circular(topRightRadius),
            bottomLeft: Radius.circular(bottomLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius)
          ),
          color: MyColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: MyText(
            text: label,
            color: MyColors.primaryColor,
            fontFamilty: "Roboto",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
