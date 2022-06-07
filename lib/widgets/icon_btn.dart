
import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {

  IconBtn({
    required this.onClick,
    required this.icon,
    required this.color,
    this.size = 24
});

  IconData icon;
  Function onClick;
  Color color;
  double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
