

import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';
import '../my_text.dart';

class SearchTextField extends StatelessWidget {

  SearchTextField({Key? key,
    required this.textEditingController,
    required this.hint,
    required this.focusNode,
    required this.nextFocusNode,
    required this.textInputAction,
    this.textInputType,
    this.error,
    required this.icon,
    this.maxLength,
    this.onChanged,
  }) : super(key: key);

  TextEditingController? textEditingController;
  String hint;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  String? error;
  IconData icon;
  int? maxLength;
  Function? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: textEditingController,
          textInputAction: textInputAction,
          keyboardType: textInputType ?? TextInputType.text,
          focusNode: focusNode,
          onFieldSubmitted: nextFocusNode != null? (v) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } : null,
          cursorColor: MyColors.primaryColor,
          maxLength: maxLength,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: MyColors.lightGrey,
            suffixIcon: Icon(
              icon,
              color: MyColors.black54,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: InputBorder.none,/*OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),*/
            focusedBorder: InputBorder.none,/*OutlineInputBorder(
              borderSide:  BorderSide(color: MyColors.primaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),*/
            hintText: hint,
          ),
        ),
        const SizedBox(height: 5,),
        error == null || error!.isEmpty
            ? const SizedBox(
          height: 0,
          width: 0,
        )
            : MyText(
          text: error!,
          color: Colors.red,
        ),
      ],
    );
  }
}
