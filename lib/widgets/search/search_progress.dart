
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class SearchProgress extends StatelessWidget {
  const SearchProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
            strokeWidth: 4,
          ),
        ),
      ),
    );
  }
}
