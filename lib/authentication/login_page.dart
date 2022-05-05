import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/authentication/profile_page.dart';
import 'package:gpstracker/home/home_page.dart';
import 'package:gpstracker/main.dart';
import 'package:gpstracker/registration/Api.dart';
import 'package:gpstracker/registration/device_name_page.dart';
import 'package:gpstracker/registration/qr_scan_page.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:ms_undraw/ms_undraw.dart';
import '../Widgets/my_textfield.dart';
import '../Widgets/new_button.dart';
import '../Widgets/placeholder_widget.dart';
import '../Widgets/splash_screen.dart';
import '../globalVariable.dart';
import '../utils/colors.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.back = true}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
  final bool back;
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  bool splash = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return WillPopScope(
      onWillPop: () {
        return Future.value(widget.back);
      },
      child: Scaffold(
        body: splash
            ? const SplaceScreen()
            : SingleChildScrollView(
                child: FadeInUp(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 12, left: 12),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(constants.defaultPadding),
                        //   child: Image.asset("images/login.png"),
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.all(constants.defaultPadding),
                          child: UnDraw(
                            height: 188.h,
                            color: colorDark,
                            illustration: UnDrawIllustration.login,
                            placeholder: const PlaceholderWidget(),
                            errorWidget: const Icon(Icons.error_outline,
                                color: Colors.red,
                                size:
                                    50), //optional, default is the Text('Could not load illustration!').
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: constants.defaultPadding,
                              top: constants.defaultPadding),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "OTP verification",
                              style: textStyle.heading,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: constants.defaultPadding,
                              top: constants.defaultPadding / 2,
                              right: constants.defaultPadding),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: 'We send you ',
                                style: textStyle.subHeading.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: colorSubHeadingText,
                                    fontSize: 16.sp),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'one time password ',
                                      style: textStyle.subHeading.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colorHeadingText,
                                          fontSize: 16.sp)),
                                  TextSpan(
                                      text: "on this mobile number",
                                      style: textStyle.subHeading.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: colorSubHeadingText,
                                          fontSize: 16.sp)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        MyTextFiled(
                          controller: phoneNumberController,
                          hint: "Mobile Number",
                          inputType: TextInputType.phone,
                          length: 10,
                        ),
                        NewButton(
                          context: context,
                          function: () {
                            if (phoneNumberController.text.length != 10) {
                              showSnackbar(
                                  context,
                                  "Phone number should be 10 digit only",
                                  colorWarning);
                              return;
                            }
                            nextPage(
                                context,
                                OtpPage(
                                  phoneNumber: phoneNumberController.text,
                                ));
                          },
                          buttonText: "GET OTP",
                          textStyle: textStyle.button,
                          margin: const EdgeInsets.only(
                              top: constants.defaultPadding * 2,
                              left: constants.defaultPadding,
                              right: constants.defaultPadding),
                          height: 55.h,
                        ),
                        // new Container(
                        //   child: new Material(
                        //     child: new InkWell(
                        //       onTap: () {
                        //         print("tapped");
                        //       },
                        //       child: new Container(
                        //         width: 100.0,
                        //         height: 100.0,
                        //       ),
                        //     ),
                        //     color: Colors.transparent,
                        //   ),
                        //   color: Colors.orange,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void checkUser() {
    Future.delayed(const Duration(milliseconds: 10), () {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (prefs.getBool(LSKey.isDeviceRegister) ?? false) {
          nextPageFade(context, const HomePage());
        } else {
          nextPageFade(context, const DeviceNamePage());
        }
      } else {
        setState(() {
          splash = false;
        });
      }
    });
  }
}
