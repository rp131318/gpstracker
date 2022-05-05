import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpstracker/Api/database_api.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/globalVariable.dart';
import 'package:gpstracker/main.dart';

import '../authentication/Api/user_details.dart';

class RegistrationApi {
  /// 192.168.4.1/spur?spur=ssid-pass
  static String url =
      "http://192.168.4.1/spur?spur=phone-${prefs.getString(LSKey.qrNumber + RegistrationTempDetails.deviceCode)}-";

  // static String url = "https://cricket.cbity.com/live_match.php";

  static List<String> deviceNumber = [];
  static List<String> deviceName = [];
  static List<String> deviceModelNo = [];
  static List<String> deviceDateTime = [];

  static var registerDevices;

  static Future<void> sendDetails() async {
    customPrint("Url :: $url");
    return await Dio().get(url).then((value) async {
      customPrint("sendDetails :: ${value.data}");
      await prefs.setBool(LSKey.isDeviceRegister, true);
      await prefs.setBool(LSKey.regCon, true);
      registerDevice().then((value) {});
    });
  }

  static Future<void> registerDevice() async {
    var body = {
      "name": RegistrationTempDetails.deviceName,
      "model": "modelx-${RegistrationTempDetails.deviceCode}",
      "datetime": DateTime.now().toString(),
      "user_number": UserDetails.number,
      "device_number":
          prefs.getString(LSKey.qrNumber + RegistrationTempDetails.deviceCode)
    };

    if (!await checkInternet()) {
      await prefs.setString(LSKey.regData, jsonEncode(body));
    }

    return await Dio()
        .post(DatabaseApi.mainUrl + DatabaseApi.registerDevice,
            data: jsonEncode(body))
        .then((value) async {
      customPrint("registerDevice :: ${value.data}");
    });
  }

  static Future<bool> getRegisterDevice(BuildContext context) async {
    // if (!await checkInternet()) {
    //   nextPage(context, const NoInternet());
    // }
    return await Dio()
        .get(DatabaseApi.mainUrl +
            DatabaseApi.getRegisterDevice +
            "?number=${UserDetails.number}")
        .then((value) async {
      customPrint("getRegisterDevice :: ${value.data}");
      registerDevices = jsonDecode(value.data);

      if (registerDevices[0]["response"].toString() != "null") {
        return false;
      }

      RegistrationTempDetails.deviceNumber =
          registerDevices[prefs.getInt(LSKey.favDeviceIndex) ?? 0]
                  ["device_number"]
              .toString();

      RegistrationTempDetails.deviceName =
          registerDevices[prefs.getInt(LSKey.favDeviceIndex) ?? 0]
                  ["device_name"]
              .toString();

      final temp = registerDevices[prefs.getInt(LSKey.favDeviceIndex) ?? 0]
              ["device_model_no"]
          .toString();

      if (temp.split("-").length == 1) {
        RegistrationTempDetails.deviceCode = temp.split("-")[1];
      }
      await prefs.setString(LSKey.qrNumber + RegistrationTempDetails.deviceCode,
          RegistrationTempDetails.deviceNumber);
      return true;
    });
  }
}

class RegistrationTempDetails {
  static String deviceName = "My Device";
  static String deviceCode = "My Device";
  static String deviceNumber = "My Device";
}
