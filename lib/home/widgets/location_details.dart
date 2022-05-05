import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/globalVariable.dart';
import 'package:gpstracker/home/Api.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({
    Key? key,
    required this.live,
  }) : super(key: key);
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(constants.defaultPadding),
      elevation: 0,
      child: HomeApi.subLocalityName.isNotEmpty
          ? Column(
              children: List.generate(HomeApi.subLocalityName.length, (index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: constants.defaultPadding / 8,
                            bottom: constants.defaultPadding / 8,
                            left: constants.defaultPadding,
                            right: constants.defaultPadding),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text("Time",
                                      style: textStyle.subHeadingColorDark),
                                ),
                                Expanded(
                                  child: Text(
                                    "Location",
                                    style: textStyle.subHeadingColorDark,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 0.2,
                              color: colorSubHeadingText,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: constants.defaultPadding / 8,
                            bottom: constants.defaultPadding / 8,
                            left: constants.defaultPadding,
                            right: constants.defaultPadding),
                        child: Column(
                          children: [
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
                                                  color: live
                                                      ? colorSuccess
                                                      : colorError,
                                                  borderRadius:
                                                      constants.borderRadius),
                                              width: 44.w,
                                              child: Center(
                                                child: Text(
                                                  "Live",
                                                  style: textStyle.smallText
                                                      .copyWith(fontSize: 14.sp)
                                                      .copyWith(
                                                          color: colorWhite),
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
                                              width:
                                                  constants.defaultPadding / 4,
                                            ),
                                            Text(
                                              HomeApi.subLocalityTime.reversed
                                                  .toList()[index],
                                              style: textStyle.smallText,
                                            )
                                          ],
                                        ),
                                ),
                                Expanded(
                                  child: Text(
                                      HomeApi.subLocalityName.reversed
                                          .toList()[index],
                                      textAlign: TextAlign.right,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: index == 1
                                          ? textStyle.smallText
                                              .copyWith(fontSize: 14.sp)
                                          : textStyle.smallText),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 0.2,
                              color: colorSubHeadingText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                      top: constants.defaultPadding / 8,
                      bottom: constants.defaultPadding / 8,
                      left: constants.defaultPadding,
                      right: constants.defaultPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
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
                                  HomeApi.subLocalityTime.reversed
                                      .toList()[index],
                                  style: textStyle.smallText,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                                HomeApi.subLocalityName.reversed
                                    .toList()[index],
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: index == 1
                                    ? textStyle.smallText
                                        .copyWith(fontSize: 14.sp)
                                    : textStyle.smallText),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 0.2,
                        color: colorSubHeadingText,
                      ),
                    ],
                  ),
                );
              }),
            )
          : Padding(
              padding: const EdgeInsets.all(constants.defaultPadding * 2),
              child: loadingWidget(),
            ),
    );
  }
}
