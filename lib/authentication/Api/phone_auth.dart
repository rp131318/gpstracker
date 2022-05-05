import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpstracker/home/home_page.dart';
import 'package:gpstracker/registration/device_name_page.dart';
import 'package:gpstracker/registration/qr_scan_page.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../globalVariable.dart';
import '../../main.dart';
import '../profile_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;

String _verificationId = "";
final FirebaseAuth _auth = FirebaseAuth.instance;

class PhoneAuth {
  static Future<void> verifyWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await auth.signInWithCredential(phoneAuthCredential).then((user) async {
        customPrint("phoneAuthCredential :: $phoneAuthCredential");
        final User? user = auth.currentUser;
        if (user != null) {
          customPrint("User ::" + user.toString());
          final uid = user.uid;
          customPrint("uid :: $uid");
          await prefs.setBool("login", true);
          nextPage(context, const DeviceNamePage());
        } else {
          showSnackbar(context, "OTP not correct", Colors.red);
          customPrint("OTP Error");
        }
      }).catchError((error) {
        customPrint(error.toString());
        showSnackbar(context, "Error : $error", Colors.red);
      });
    };

    ///Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          context,
          'Phone number verification failed. Code: ${authException.message}',
          Colors.grey);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      customPrint("_verificationId1 :: $_verificationId");
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      customPrint("_verificationId2 :: $_verificationId");
    };

    try {
      await _auth
          .verifyPhoneNumber(
              phoneNumber: "+91" + phoneNumber,
              timeout: const Duration(seconds: 5),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) {
        customPrint("Code :: $codeSent");
      });
    } catch (e) {
      showSnackbar(context, "Failed to Verify Phone Number: $e", Colors.grey);
    }
  }

  static Future<void> signWithPhoneNumber(
      BuildContext context, String otp) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential).then((user) async {
        customPrint("credential New  :: $credential");
        final User? user = auth.currentUser;
        customPrint("User ::" + user.toString());
        final uid = user?.uid;
        customPrint(uid);
        nextPage(context, const DeviceNamePage());
      }).catchError((error) {
        customPrint(error.toString());
        showSnackbar(context, "Error : $error", Colors.red);
      });
    } catch (e) {}
  }
}
