import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../globalVariable.dart';
import '../../main.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final ImagePicker _picker = ImagePicker();

class UserDetails {
  static String name = "User Name";
  static String photo = " ";
  static String number =
      auth.currentUser?.phoneNumber.toString().substring(3) ?? "-";
  static String image64 = "-";
  static File pickedImage = File("path");

  // static Future<void> sendUserDetails(body) async {
  //   final body1 = {
  //     "number": UserDetails.number,
  //     "dob": UserDetails.dob,
  //     "height": UserDetails.height,
  //     "weight": UserDetails.weight,
  //     "gender": UserDetails.gender,
  //   };
  //   final body2 = {
  //     "number": UserDetails.number,
  //     "face_type": UserDetails.faceType,
  //     "body_shape": UserDetails.bodyShape,
  //     "skin_tone": UserDetails.skinTone,
  //     "hair_type": UserDetails.hairType,
  //     "hair_length": UserDetails.hairLength,
  //     "beared_length": UserDetails.beardLength,
  //     "beared_type": UserDetails.beardedType,
  //   };
  //   customPrint("body1 :: $body1");
  //   customPrint("body2 :: $body2");
  //
  //   return await Dio()
  //       .post(DatabaseApi.mainUrl + DatabaseApi.uploadUserDetails,
  //           data: jsonEncode(body))
  //       .then((value) async {
  //     customPrint("uploadUserDetails :: ${value.data}");
  //     return await Dio()
  //         .post(DatabaseApi.mainUrl + DatabaseApi.uploadUserFeatures,
  //             data: jsonEncode(body1))
  //         .then((value) async {
  //       customPrint("uploadUserFeatures :: ${value.data}");
  //       return await Dio()
  //           .post(DatabaseApi.mainUrl + DatabaseApi.uploadUserBodySelections,
  //               data: jsonEncode(body2))
  //           .then((value) {
  //         customPrint("uploadUserBodySelections :: ${value.data}");
  //       });
  //     });
  //   });
  // }
  //
  // static Future<void> updateUserDetails(body) async {
  //   customPrint(
  //       "updateUserDetails Link :: ${DatabaseApi.mainUrl + DatabaseApi.updateUserDetails}");
  //   return await Dio()
  //       .post(DatabaseApi.mainUrl + DatabaseApi.updateUserDetails,
  //           data: jsonEncode(body))
  //       .then((value) async {
  //     customPrint("updateUserDetails :: ${value.data}");
  //   });
  // }
  //
  // static Future<bool> getUserDetails(
  //     {bool notStoreData = false, bool onlyImage = false}) async {
  //   return await Dio()
  //       .get(DatabaseApi.mainUrl +
  //           DatabaseApi.getUserDetails +
  //           "?number=${UserDetails.number}")
  //       .then((value) {
  //     customPrint("getUserDetails :: ${jsonDecode(value.data)}");
  //     final jsonData = jsonDecode(value.data);
  //
  //     if (notStoreData) {
  //       if (onlyImage) {
  //         photo = jsonData[0]["image"].toString();
  //         name = jsonData[0]["name"].toString();
  //       }
  //       return jsonData[0]["name"].toString() != "null" ? true : false;
  //     }
  //     name = jsonData[0]["name"].toString();
  //     photo = jsonData[0]["image"].toString();
  //     dob = jsonData[0]["dob"].toString();
  //     height = jsonData[0]["height"].toString();
  //     weight = jsonData[0]["weight"].toString();
  //     gender = jsonData[0]["gender"].toString();
  //     faceType = jsonData[0]["face_type"].toString();
  //     bodyShape = jsonData[0]["body_shape"].toString();
  //     skinTone = jsonData[0]["skin_tone"].toString();
  //     hairType = jsonData[0]["hair_type"].toString();
  //     hairLength = jsonData[0]["hair_length"].toString();
  //     beardedType = jsonData[0]["beared_type"].toString();
  //     beardLength = jsonData[0]["beared_length"].toString();
  //     prefs.setString("userName", jsonData[0]["name"].toString());
  //     prefs.setString("dob", jsonData[0]["dob"].toString());
  //     prefs.setString("height", jsonData[0]["height"].toString());
  //     prefs.setString("weight", jsonData[0]["weight"].toString());
  //     prefs.setString("gender", jsonData[0]["gender"].toString());
  //     prefs.setString("face_type", jsonData[0]["face_type"].toString());
  //     prefs.setString("body_shape", jsonData[0]["body_shape"].toString());
  //     prefs.setString("body_tone", jsonData[0]["skin_tone"].toString());
  //     prefs.setString("hair_type", jsonData[0]["hair_type"].toString());
  //     prefs.setString("hair_length", jsonData[0]["hair_length"].toString());
  //     prefs.setString("beard_length", jsonData[0]["beared_length"].toString());
  //     prefs.setString("beard_type", jsonData[0]["beared_type"].toString());
  //     return jsonData[0]["name"].toString() != "null" ? true : false;
  //   });
  // }

  static Future<Uint8List?> testCompressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 200,
      minHeight: 200,
      quality: 10,
      rotate: 0,
    );
    customPrint(file.lengthSync());
    customPrint(result?.length);
    return result;
  }
}
