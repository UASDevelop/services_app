import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_app/utils/my_colors.dart';

import 'my_text.dart';


class MobileInputField extends StatelessWidget {
  MobileInputField({
    Key? key,
    required this.textEditingController,
    required this.hint,
    required this.focusNode,
    required this.nextFocusNode,
    required this.textInputAction,
    required this.icon,
    this.error,
    this.textInputType,
    this.maxLength,
    this.onChanged,
    this.countryCode,
    this.number,
    this.onCountryCodeChanged,
  }) : super(key: key);

  TextEditingController? textEditingController;
  String? hint;
  String? countryCode;
  String? number;
  IconData icon;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputAction? textInputAction;
  String? error;
  TextInputType? textInputType;
  int? maxLength;
  Function? onCountryCodeChanged;
  Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // country code picker
            CountryCodePicker(
              onChanged: (value) {
                if (onCountryCodeChanged != null) {
                  onCountryCodeChanged!(value.dialCode);
                }
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: countryCode ?? '+1',
              favorite: const ['+1',],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              showDropDownButton: true,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              hideMainText: false,
              showFlagMain: false,
              showFlag: true,
              showFlagDialog: true,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
            // textfield
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                textInputAction: textInputAction,
                keyboardType: textInputType ?? TextInputType.text,
                focusNode: focusNode,
                maxLength: maxLength,
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged!(value);
                  }
                },
                onFieldSubmitted: nextFocusNode != null
                    ? (v) {
                  FocusScope.of(context).requestFocus(nextFocusNode);
                }
                    : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    icon,
                    color: MyColors.primaryColor,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: MyColors.primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: hint,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        error == null || error!.isEmpty
            ? const SizedBox(
          height: 0,
          width: 0,
        )
            : Padding(
              padding: const EdgeInsets.only(left: 100),
              child: MyText(
          text: error!,
          color: Colors.red,
        ),
            ),
      ],
    );
  }
}
