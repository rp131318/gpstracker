// @dart=2.9
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpstracker/authentication/login_page.dart';
import 'package:gpstracker/registration/device_name_page.dart';
import 'package:gpstracker/registration/qr_scan_page.dart';
import 'package:gpstracker/utils/colors.dart';
import 'home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'globalVariable.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    checkDebugMode();

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: () {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tracker',
            theme: ThemeData(
              primarySwatch: colorCustom,
              fontFamily: "OpenSans",
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            builder: (context, child) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            // home: const DeviceNamePage(),
            home: const LoginPage(),
          );
        });
  }
}
