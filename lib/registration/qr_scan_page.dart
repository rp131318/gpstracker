import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/Widgets/new_button.dart';
import 'package:gpstracker/Widgets/progressHud.dart';
import 'package:gpstracker/registration/Api.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../Widgets/placeholder_widget.dart';
import '../globalVariable.dart';
import '../home/home_page.dart';
import '../main.dart';
import '../utils/colors.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key, this.backPress = false}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();

  final bool backPress;
}

class _QrScanPageState extends State<QrScanPage> {
  bool loading = false;
  String buttonText = "Connect WIFI";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(widget.backPress),
      child: Scaffold(
        body: ProgressHUD(
          isLoading: loading,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(constants.defaultPadding,
                  constants.defaultPadding, constants.defaultPadding, 0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      UnDraw(
                        height: 222.h,
                        color: colorDark,
                        illustration: UnDrawIllustration.online_connection,
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
                              top: constants.defaultPadding * 2),
                          child: Text(
                            "Connect Wifi to device",
                            style: textStyle.heading.copyWith(fontSize: 22.sp),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: constants.defaultPadding),
                          child: Text(
                            "Please connect your mobile wifi to device generated wifi.",
                            style: textStyle.subHeading,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NewButton(
                        margin: const EdgeInsets.only(
                            bottom: constants.defaultPadding),
                        context: context,
                        function: () async {
                          OpenSettings.openWIFISetting();
                        },
                        buttonText: buttonText,
                      ),
                      NewButton(
                        border: true,
                        margin: const EdgeInsets.only(
                            bottom: constants.defaultPadding * 2),
                        context: context,
                        textStyle: textStyle.button.copyWith(color: colorDark),
                        function: () async {
                          if (await Permission.camera.request().isGranted) {
                            await scanner.scan().then((value) async {
                              if (value != null) {
                                setState(() {
                                  loading = true;
                                });

                                RegistrationTempDetails.deviceCode =
                                    getRandomInt(10);

                                await prefs.setString(
                                    LSKey.qrNumber +
                                        RegistrationTempDetails.deviceCode,
                                    value);
                                RegistrationApi.sendDetails().then((value) {
                                  nextPage(context, const HomePage());
                                });
                              }
                            });
                          } else {
                            showMyDialog(context,
                                onYes: () {},
                                noButtonText: "Ok",
                                shoYesButton: false,
                                title: "Camera Permission",
                                content:
                                    "App need camera permission to scan qr code.");
                          }
                        },
                        buttonText: "Scan QR",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
