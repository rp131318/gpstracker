import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/utils/constants.dart';

class SplaceScreen extends StatelessWidget {
  const SplaceScreen({
    Key? key,
    this.animate = true,
  }) : super(key: key);
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FadeInUpBig(
      duration: Duration(milliseconds: animate ? 1300 : 0),
      child: Padding(
        padding: const EdgeInsets.all(constants.defaultPadding),
        child: Image.asset(
          "images/logo.png",
          height: 222.h,
        ),
      ),
    ));
  }
}
