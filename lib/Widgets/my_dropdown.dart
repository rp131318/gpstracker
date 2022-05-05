import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/utils/constants.dart';

import '../globalVariable.dart';
import '../utils/colors.dart';

class MyDropDown extends StatelessWidget {
  const MyDropDown({
    Key? key,
    required this.onChange,
    required this.defaultValue,
    required this.array,
    this.margin,
  }) : super(key: key);

  final Function(String?) onChange;
  final String defaultValue;
  final List<String> array;
  final margin;

  @override
  Widget build(BuildContext context) {
    customPrint("defaultValue :: $defaultValue");
    customPrint("array :: $array");

    return SizedBox(
      width: double.infinity,
      // height: 76.h,
      child: Card(
        margin: margin ??
            EdgeInsets.only(
                top: constants.defaultPadding,
                left: constants.defaultPadding,
                right: constants.defaultPadding),
        semanticContainer: true,
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: colorDark, width: 2.0),
            borderRadius: constants.borderRadius),
        child: Row(
          children: [
            const SizedBox(
              width: constants.defaultPadding,
            ),
            Expanded(
              flex: 9,
              child: DropdownButton<String>(
                value: defaultValue,
                underline: Container(),
                icon: Container(),
                items: array.toSet().toList().map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
                onChanged: onChange,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
            ),
            const SizedBox(
              width: constants.defaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
