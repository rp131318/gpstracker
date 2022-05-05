import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/utils/constants.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    Key? key,
    required this.context,
    this.padding,
  }) : super(key: key);

  final BuildContext context;
  final padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: padding ?? const EdgeInsets.all(constants.defaultPadding),
        child: Align(
          alignment: Alignment.topLeft,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}
