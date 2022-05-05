import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/Widgets/my_textfield.dart';
import 'package:gpstracker/Widgets/new_button.dart';
import 'package:gpstracker/Widgets/splash_screen.dart';
import 'package:gpstracker/registration/Api.dart';
import 'package:gpstracker/registration/qr_scan_page.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../Widgets/placeholder_widget.dart';
import '../globalVariable.dart';
import '../home/home_page.dart';
import '../utils/colors.dart';

class DeviceNamePage extends StatefulWidget {
  const DeviceNamePage({Key? key, this.backPress = false}) : super(key: key);

  @override
  _DeviceNamePageState createState() => _DeviceNamePageState();
  final bool backPress;
}

class _DeviceNamePageState extends State<DeviceNamePage> {
  final deviceNameController = TextEditingController();
  bool splash = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.backPress) {
      splash = false;
    } else {
      checkRegisterDevice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(widget.backPress),
      child: Scaffold(
        body: splash
            ? const SplaceScreen()
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      UnDraw(
                        height: 222.h,
                        color: colorDark,
                        illustration: UnDrawIllustration.details,
                        placeholder: const PlaceholderWidget(),
                        errorWidget: const Icon(Icons.error_outline,
                            color: Colors.red,
                            size:
                                50), //optional, default is the Text('Could not load illustration!').
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: constants.defaultPadding * 2,
                              left: constants.defaultPadding),
                          child: Text(
                            "Enter name of your device",
                            style: textStyle.heading.copyWith(fontSize: 22.sp),
                          ),
                        ),
                      ),
                      MyTextFiled(
                          controller: deviceNameController,
                          hint: "Device Name"),
                      NewButton(
                        context: context,
                        function: () {
                          if (deviceNameController.text.isEmpty) {
                            showSnackbar(
                                context,
                                "Please enter device name and processed",
                                colorWarning);
                            return;
                          }
                          RegistrationTempDetails.deviceName =
                              deviceNameController.text;
                          nextPage(context, const QrScanPage());
                        },
                        buttonText: "Processed",
                        margin: const EdgeInsets.only(
                            top: constants.defaultPadding * 2,
                            left: constants.defaultPadding,
                            right: constants.defaultPadding),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void checkRegisterDevice() {
    RegistrationApi.getRegisterDevice(context).then((value) {
      if (value) {
        nextPage(context, const HomePage());
      } else {
        setState(() {
          splash = false;
        });
      }
    });
  }
}
