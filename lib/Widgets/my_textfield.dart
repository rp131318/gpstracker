import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

import '../utils/colors.dart';

class MyTextFiled extends StatelessWidget {
  const MyTextFiled({
    Key? key,
    required this.controller,
    required this.hint,
    this.length,
    this.inputType,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final int? length;
  final inputType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76.h,
      child: Padding(
        padding: const EdgeInsets.only(
            top: constants.defaultPadding * 2,
            left: constants.defaultPadding,
            right: constants.defaultPadding),
        child: TextFormField(
          controller: controller,
          inputFormatters: length != null
              ? [
                  LengthLimitingTextInputFormatter(length),
                ]
              : [],
          keyboardType: inputType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 2),
              borderRadius: constants.borderRadius,
            ),
            labelText: hint,
            labelStyle: textStyle.subHeading
                .copyWith(color: colorDark, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
