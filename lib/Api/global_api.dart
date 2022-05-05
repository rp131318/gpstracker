import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gpstracker/globalVariable.dart';

import '../main.dart';
import 'database_api.dart';
import 'local_storage.dart';

bool checkResponse(response) {
  customPrint("checkResponse :: $response");
  if (response.toString() == "null") {
    return false;
  }
  if (response[0]["response"].toString().toLowerCase() != "null") {
    if (response[0]["response"].toString().toLowerCase() == "false") {
      return false;
    }
    return true;
  }

  return true;
}

class GlobalApi {
  ///Store data to internet which was store in local srorage
  static Future<void> storeDataToInternet() async {
    ///Store IMS Registration data of user
    if (prefs.getBool(LSKey.regCon) ?? false) {
      final body = jsonDecode(prefs.getString(LSKey.regData) ?? "");
      await Dio()
          .post(DatabaseApi.mainUrl + DatabaseApi.registerDevice,
              data: jsonEncode(body))
          .then((value) async {
        customPrint("registerDevice :: ${value.data}");
        await prefs.setBool(LSKey.regCon, false);
      });
    }
  }
}
