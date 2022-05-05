library my_prj.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gpstracker/utils/constants.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as rahul;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:page_transition/page_transition.dart';

import 'authentication/login_page.dart';

//=========================Variables============================================

void showSnackbar(context, String message, color, [int duration = 4000]) {
  try {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } catch (e) {
    customPrint("SnackBar Error :: $e");
  }
  final snackBar = SnackBar(
    elevation: 6.0,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(constants.defaultPadding),
    backgroundColor: color,
    duration: Duration(milliseconds: duration),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void nextPage(context, Widget page) {
  Navigator.push(context,
      PageTransition(type: PageTransitionType.rightToLeft, child: page));
}

void nextPageFade(context, Widget page) {
  Navigator.push(
      context, PageTransition(type: PageTransitionType.fade, child: page));
}
//
// void openDrawerPage(context) {
//   Navigator.push(
//       context,
//       PageTransition(
//           type: PageTransitionType.leftToRight,
//           child: const UserProfilePage()));
// }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

Widget loadingWidget(
    [String msgTitle = "No Data Found.",
    String msgSubTitle = "No data found or slow internet connection.",
    String image = "images/noHistory.png"]) {
  return Center(
    child: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (c, s) => s.connectionState == ConnectionState.done
            // ? Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         msgTitle,
            //         style: const TextStyle(
            //             fontWeight: FontWeight.bold, fontSize: 18),
            //       ),
            //       Text(
            //         msgSubTitle,
            //         style: const TextStyle(color: Colors.grey, fontSize: 12),
            //       )
            //     ],
            //   )
            ? Card(
                elevation: 1,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: constants.borderRadius),
                child: ListTile(
                  leading: const Icon(
                    Icons.error_outline_rounded,
                    size: 30,
                    color: colorDark,
                  ),
                  title: Text(
                    msgTitle,
                    style: textStyle.subHeadingColorDark,
                  ),
                  subtitle: Text(
                    msgSubTitle,
                    style: textStyle.smallText,
                  ),
                ),
              )
            : const CircularProgressIndicator()),
  );
}

List<String> dynamicToStatic(List projectClimate) {
  List<String> aa = [];
  for (int i = 0; i < projectClimate.length; i++) {
    aa.add(projectClimate[i].toString().trim());
  }
  return aa;
}

bool validateField(context, TextEditingController controller,
    [int validateLength = 0, String fieldType = "default"]) {
  if (controller.text.length > validateLength) {
    switch (fieldType) {
      case "default":
        return true;
        break;
      case "phone":
        if (controller.text.length == 10) {
          return true;
        }
        showSnackbar(context, "Phone number should be 10 digits", Colors.red);

        break;
      case "email":
        if (controller.text.contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
          return true;
        }
        showSnackbar(context, "Provide correct email address", Colors.red);
        break;
      case "password":
        if (controller.text.length > 8) {
          return true;
        }
        showSnackbar(context, "Password should be 8 digits", Colors.red);
        break;
    }
  } else {
    showSnackbar(context, "Field Can't be empty...", Colors.red);
    return false;
  }
  return false;
}

Widget titleTextField(String s, TextEditingController nameController,
    [bool enable = true, final keyBoard = TextInputType.text]) {
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            s,
            style: const TextStyle(fontSize: 18, color: colorDark),
          ),
        ),
      ),
      Container(
        height: 46,
        decoration: BoxDecoration(
            // color: global.colorLight,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.only(left: 18, right: 18, top: 6),
        padding: const EdgeInsets.only(left: 14),
        child: TextFormField(
          enabled: enable,
          style: const TextStyle(fontSize: 18),
          controller: nameController,
          keyboardType: keyBoard,
          cursorColor: Colors.black45,
          // textAlign: TextAlign.center,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: " ",
              hintStyle: const TextStyle(color: Colors.grey)),
        ),
      ),
    ],
  );
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
const _chars1 = '1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String getRandomInt(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars1.codeUnitAt(_rnd.nextInt(_chars1.length))));

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      customPrint('connected');
      return Future.value(true);
    }
  } on SocketException catch (_) {
    customPrint('not connected');
    return Future.value(false);
  }
  return Future.value(false);
}

Future<void> copyToClipboard(context, copyText) async {
  await Clipboard.setData(ClipboardData(text: copyText));
  showSnackbar(context, '$copyText Copied to clipboard', Colors.green);
}

int getJsonLength(jsonText) {
  int len = 0;
  try {
    while (jsonText[len] != null) {
      len++;
    }
    // customPrint("Len :: $len");
  } catch (e) {
    // customPrint("Len Catch :: $len");
    return len;
  }
  return 0;
}

String stringToJson(String key, String value) {
  String dff = ("\"" + key + "\"\r" + ": \"" + value + "\"\r").toString();
  String jsonText = '"$key": "$value"';
  customPrint("Dff :: $jsonText");
  return jsonText;
}

bool debugMode = false;

checkDebugMode() {
  assert(() {
    debugMode = true;
    rahul.log("App running on debug mode!");
    return true;
  }());
}

void customPrint(text) {
  if (debugMode) {
    rahul.log(text);
  }
}

void customLog(text) {
  if (debugMode) {
    rahul.log(text);
  }
}

String getStringCont(String cont) {
  return cont.replaceAll("+91", "").toString().trim();
}

String getStringInt(String text) {
  try {
    String data = "";
    data = text.replaceAll(new RegExp(r'[^0-9]'), '');
    return int.parse(data).toString();
  } catch (e) {
    return "3";
  }
}

class SplitArray {
  static List list1 = [];
  static List list2 = [];
  static List mergeList = [];

  static void split(List array, [String delim = "{}"]) {
    list1.clear();
    list2.clear();
    for (int i = 0; i < array.length; i++) {
      list1.add(array[i].toString().split(delim)[0]);
      list2.add(array[i].toString().split(delim)[1]);
    }
    customPrint("List 1 :: $list1");
    customPrint("List 2 :: $list2");
  }

  static void add(List array1, List array2, [String delim = "{}"]) {
    mergeList.clear();
    for (int i = 0; i < array1.length; i++) {
      mergeList.add(array1[i] + delim + array2[i]);
    }
  }
}

void logoutUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you really want to Logout?"),
        actions: [
          FlatButton(
            child: const Text(
              "Yes",
              style: TextStyle(color: colorDark),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              nextPage(context, const LoginPage(back: false));
            },
          ),
          FlatButton(
            child: const Text(
              "No",
              style: TextStyle(color: colorDark),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

void AppExitPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit'),
      content: const Text("Do you really want to exit ?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        FlatButton(
          onPressed: () => exit(0),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}

void showMyDialog(
  BuildContext context, {
  String title = "Title",
  String content = "Dialog content text",
  String yesButtonText = "Yes",
  String noButtonText = "No",
  bool shoYesButton = true,
  required Function onYes,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: textStyle.heading,
      ),
      content: Text(
        content,
        style: textStyle.subHeading.copyWith(color: colorHeadingText),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(noButtonText),
        ),
        Visibility(
          visible: shoYesButton,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
              onYes();
            },
            child: Text(yesButtonText),
          ),
        ),
      ],
    ),
  );
}

showSuccessDialog(BuildContext context,
    {String text = "You have warning !", final color = colorSuccess}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
                bottom: constants.defaultPadding,
                top: constants.defaultPadding),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            padding: const EdgeInsets.all(constants.defaultPadding),
            child: const Icon(
              Icons.done_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle.subHeadingColorDark,
          )
        ],
      ),
    ),
  );
}

showWarningDialog(BuildContext context,
    {String text = "You have warning !", final color = colorWarning}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
                bottom: constants.defaultPadding,
                top: constants.defaultPadding),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            padding: const EdgeInsets.all(constants.defaultPadding),
            child: const Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle.subHeadingColorDark,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Ok",
            ))
      ],
    ),
  );
}
