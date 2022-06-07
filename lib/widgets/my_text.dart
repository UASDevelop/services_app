
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {

  MyText({Key? key,
    required this.text,
    this.size = 14,
    this.color = Colors.black,
    this.fontFamilty = 'Roboto',
    this.lineSpace = 1,
    this.underline = false,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.textOverflow,
}) : super(key: key);

  String text;
  double size;
  String fontFamilty;
  double lineSpace;
  Color color;
  bool underline;
  FontWeight fontWeight;
  int? maxLines;
  TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontFamily: fontFamilty,
        color: color, height: lineSpace, fontWeight: fontWeight,
          decoration: underline? TextDecoration.underline : null),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
