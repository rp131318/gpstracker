import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:gpstracker/Widgets/my_dropdown.dart';
import 'package:gpstracker/Widgets/new_button.dart';
import 'package:gpstracker/home/Api.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

class BatterySection extends StatelessWidget {
  const BatterySection({
    Key? key,
    required this.live,
  }) : super(key: key);
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: constants.defaultPadding,
          right: constants.defaultPadding,
          top: constants.defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: live ? colorSuccess : colorError,
              ),
              SizedBox(
                width: constants.defaultPadding / 4,
              ),
              Text(
                live ? "Online" : "Offline",
                style: textStyle.subHeadingColorDark,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.battery_full,
                size: 18,
                color: colorDark,
              ),
              SizedBox(
                width: constants.defaultPadding / 4,
              ),
              Text(
                "${HomeApi.battery}%",
                style: textStyle.subHeadingColorDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
