import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/authentication/widgets/back_button.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

import '../Widgets/placeholder_widget.dart';
import '../globalVariable.dart';
import '../utils/colors.dart';
import 'Api/phone_auth.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  String currentText = "";
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneAuth.verifyWithPhoneNumber(context, widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeInUp(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 12, left: 12),
              child: Column(
                children: [
                  const MyBackButton(),
                  // Padding(
                  //   padding: const EdgeInsets.all(constants.defaultPadding),
                  //   child: Image.asset("images/login-illustrator.png"),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultPadding),
                    child: UnDraw(
                      height: 188.h,
                      color: colorDark,
                      colorBlendMode: BlendMode.exclusion,
                      illustration: UnDrawIllustration.secure_login,
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
                        top: constants.defaultPadding * 3),
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
                        top: constants.defaultPadding * 1,
                        right: constants.defaultPadding),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          text: 'Enter the OTP sent to ',
                          style: textStyle.subHeading.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colorSubHeadingText,
                              fontSize: 16.sp),
                          children: <TextSpan>[
                            TextSpan(
                                text: '+91-${widget.phoneNumber}',
                                style: textStyle.subHeading.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorHeadingText,
                                    fontSize: 16.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: constants.defaultPadding * 2,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 11.0, horizontal: 18),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            String ab = v ?? "";
                            if (ab.length < 6) {
                              return "Enter correct OTP";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                              inactiveColor: colorDark,
                              inactiveFillColor: Colors.white,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: hasError
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              selectedFillColor: Colors.white,
                              selectedColor: colorDark),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          // errorAnimationController: errorController,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            /// Completed
                            PhoneAuth.signWithPhoneNumber(
                                context, otpController.text);
                          },
                          onChanged: (value) {
                            customPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            customPrint("Allowing to paste $text");
                            return true;
                          },
                        )),
                  ),
                  const SizedBox(
                    height: constants.defaultPadding * 1,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Didn't receive OTP ? ",
                      style: textStyle.subHeading.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colorSubHeadingText,
                          fontSize: 16.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Resend',
                            style: textStyle.subHeading.copyWith(
                                fontWeight: FontWeight.w800, color: colorDark)),
                      ],
                    ),
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
