import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/home/Api.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

import '../../Widgets/bottom_sheet_line.dart';

class BottomSheetData extends StatelessWidget {
  const BottomSheetData({
    Key? key,
    required this.live,
    required this.onPress,
  }) : super(key: key);

  final bool live;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (value) {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.only(
            left: constants.defaultPadding,
            right: constants.defaultPadding,
            bottom: constants.defaultPadding),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(constants.radius * 2),
              topLeft: Radius.circular(constants.radius * 2)),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetLine(),
            const SizedBox(
              height: constants.defaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: live
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                  constants.defaultPadding / 8),
                              decoration: BoxDecoration(
                                  color: live ? colorSuccess : colorError,
                                  borderRadius: constants.borderRadius),
                              width: 44.w,
                              child: Center(
                                child: Text(
                                  "Live",
                                  style: textStyle.smallText
                                      .copyWith(fontSize: 14.sp)
                                      .copyWith(color: colorWhite),
                                ),
                              ),
                              margin: EdgeInsets.zero,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 10,
                              color: colorWarning,
                            ),
                            const SizedBox(
                              width: constants.defaultPadding / 4,
                            ),
                            Text(
                              HomeApi.subLocalityTime.isEmpty
                                  ? "N/A"
                                  : HomeApi.subLocalityTime.reversed
                                      .toList()[0],
                              style: textStyle.smallText,
                            )
                          ],
                        ),
                ),
                Expanded(
                  child: Text(
                      HomeApi.subLocalityName.isEmpty
                          ? "N/A"
                          : HomeApi.subLocalityName.reversed.toList()[0],
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.smallText.copyWith(fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
