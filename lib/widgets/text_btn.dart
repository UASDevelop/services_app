
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';

class TextBtn extends StatelessWidget {

  TextBtn({
    required this.onClick,
    required this.label,
    required this.underline,
    this.fontSize = 14,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w300,
});

  String label;
  bool underline;
  double fontSize;
  Color color;
  FontWeight fontWeight;
  Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Text(
        label,
        style: TextStyle(fontFamily: "Roboto", fontSize: fontSize, fontWeight: fontWeight,
          color: color, decoration: underline? TextDecoration.underline : TextDecoration.none),
      ),
    );
  }
}
