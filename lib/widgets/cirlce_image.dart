
import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';

class CircleImage extends StatelessWidget {

  CircleImage({
    required this.size,
    this.imageUrl,
    this.onClick,
});

  String? imageUrl;
  double size;
  Function? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick!();
        }
      },
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            //color: MyColors.white,
            shape: BoxShape.circle,
            /*border: const Border(
              top: BorderSide(color: Colors.white, width: 0),
              bottom: BorderSide(color: Colors.white, width: 0),
              left: BorderSide(color: Colors.white, width: 0),
              right: BorderSide(color: Colors.white, width: 0),
            ),*/
            image: DecorationImage(
              image: imageUrl != null? NetworkImage(imageUrl!) : const AssetImage(
                "assets/images/user_placeholder.png",
              ) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
    );
  }
}
