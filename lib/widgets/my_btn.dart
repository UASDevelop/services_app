
import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';

class MyBtn extends StatelessWidget {

  MyBtn({Key? key,
    @required this.onClick,
    @required this.label,
    @required this.color,
    this.textColor = Colors.white,
    this.textSize = 16,
    this.radius = 30,
  }) : super(key: key);

  Function? onClick;
  String? label;
  Color? color;
  Color textColor;
  double textSize;
  double radius;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onClick!();
      },
      color: color,
      elevation: 0,
      padding: const EdgeInsets.only(top: 11, bottom: 11, left: 25, right: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        label!,
        style: TextStyle(fontSize: textSize, color: textColor,
            fontFamily: "Roboto", fontWeight: FontWeight.w500),
      ),
    );
  }
}
