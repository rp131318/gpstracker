import 'package:flutter/material.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

import '../globalVariable.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppExitPopup(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 111,
                color: colorDark,
              ),
              const SizedBox(
                height: constants.defaultPadding * 2,
              ),
              Text(
                "Low Internet Connection",
                style: textStyle.heading,
              ),
              const SizedBox(
                height: constants.defaultPadding / 2,
              ),
              Text(
                "Check your internet or connect with active wifi network.",
                style: textStyle.subHeading,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
