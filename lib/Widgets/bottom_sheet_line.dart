import 'package:flutter/material.dart';
import 'package:gpstracker/utils/colors.dart';

class BottomSheetLine extends StatelessWidget {
  const BottomSheetLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 2,
      color: colorSubHeadingText,
      indent: 144,
      endIndent: 144,
    );
  }
}
