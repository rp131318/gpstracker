import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'dart:io';
import '../Widgets/back_button.dart';
import '../Widgets/my_textfield.dart';
import '../Widgets/new_button.dart';
import '../Widgets/progressHud.dart';
import '../Widgets/splash_screen.dart';
import '../globalVariable.dart';

import '../home/home_page.dart';
import '../utils/city_list.dart';
import '../utils/colors.dart';
import 'Api/user_details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key, this.allowBack = false, this.notStoreData = false})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

  final bool allowBack;
  final bool notStoreData;
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  bool loading = false;
  bool splash = true;
  bool showDP = false;
  final ImagePicker _picker = ImagePicker();
  String img64 = "";
  File _image = File("path");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.allowBack) {
      // getUserDetails(widget.notStoreData);
    } else {
      splash = false;
      nameController.text = UserDetails.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(widget.allowBack),
        child: splash
            ? const SplaceScreen(
                animate: false,
              )
            : ProgressHUD(
                isLoading: loading,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: FadeInUp(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 40, right: 12, left: 12),
                        child: Column(
                          children: [
                            widget.allowBack
                                ? MyBackButton(
                                    padding: EdgeInsets.only(
                                        left: constants.defaultPadding,
                                        top: constants.defaultPadding / 2,
                                        bottom: constants.defaultPadding / 2),
                                    context: context,
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: constants.defaultPadding,
                                  top: constants.defaultPadding * 4),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Now, let's create\nyour profile",
                                  style: textStyle.heading.copyWith(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: constants.defaultPadding * 4,
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final pickedFile = await _picker.getImage(
                                      source: ImageSource.gallery);
                                  customPrint(
                                      "pickedFile :: ${pickedFile?.path}");
                                  _image = File(pickedFile!.path);
                                  setState(() {
                                    showDP = true;
                                  });

                                  // final res = await testCompressAndGetFile(
                                  //     File(pickedFile.path));
                                  final bytes = Io.File(pickedFile.path)
                                      .readAsBytesSync();
                                  img64 = base64Encode(bytes);
                                  // img64 = base64Encode(res!);
                                  customPrint("img64 :: $img64");
                                } catch (e) {
                                  customLog("Err : $e");
                                }
                              },
                              child: SizedBox(
                                width: 111,
                                height: 111,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(200)),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Card(
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(200)),
                                        child: GetDisplayImage(),
                                      ),
                                      showDP
                                          ? const SizedBox(
                                              width: 0,
                                              height: 0,
                                            )
                                          : Card(
                                              margin: EdgeInsets.zero,
                                              semanticContainer: true,
                                              elevation: 0,
                                              color: colorDark,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: const Icon(
                                                Icons.add,
                                                size: 33,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            MyTextFiled(
                              controller: nameController,
                              hint: "Username",
                            ),
                            NewButton(
                              context: context,
                              function: () async {
                                if (nameController.text.isEmpty) {
                                  showSnackbar(
                                      context,
                                      "Please enter name properly",
                                      colorWarning);
                                  return;
                                }

                                setState(() {
                                  loading = true;
                                });
                                if (widget.allowBack) {
                                  ///Update
                                  UserDetails.name = nameController.text;
                                  if (img64.trim().isNotEmpty) {
                                    UserDetails.photo = img64.trim();
                                  }
                                  customPrint(
                                      "Update Api :: ${UserDetails.photo}");
                                  // _updateUserDetails();
                                } else {
                                  ///Create
                                  if (!showDP && !widget.allowBack) {
                                    ByteData bytes =
                                        await rootBundle.load('images/dp.png');
                                    var buffer = bytes.buffer;
                                    var result = await FlutterImageCompress
                                        .compressWithList(
                                      Uint8List.view(buffer),
                                      minHeight: 200,
                                      minWidth: 200,
                                      quality: 10,
                                    );
                                    img64 = base64.encode(result);
                                  }
                                  customPrint("Image 64 :: $img64");
                                  final body = {
                                    "image": img64.trim().isNotEmpty
                                        ? img64
                                        : UserDetails.photo,
                                    "number": UserDetails.number,
                                    "name": nameController.text,
                                    "email": ""
                                  };

                                  customPrint("sendUserDetails Body $body");

                                  // UserDetails.getUserDetails(notStoreData: true)
                                  //     .then((value) {
                                  //   if (value) {
                                  //     _updateUserDetails();
                                  //   } else {
                                  //     UserDetails.sendUserDetails(body)
                                  //         .then((value) async {
                                  //       await Future.delayed(
                                  //           const Duration(milliseconds: 1000),
                                  //           () {
                                  //         setState(() {
                                  //           loading = false;
                                  //         });
                                  //         nextPage(context, const HomePage());
                                  //       });
                                  //     });
                                  //   }
                                  // });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.allowBack ? "Update" : "Proceed",
                                    style: textStyle.button,
                                  ),
                                  const SizedBox(
                                    width: constants.defaultPadding,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 33,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              rDefaultWidget: false,
                              textStyle: textStyle.button,
                              margin: const EdgeInsets.only(
                                  top: constants.defaultPadding * 2,
                                  left: constants.defaultPadding,
                                  right: constants.defaultPadding),
                              height: 55.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Image GetDisplayImage() {
    if (widget.allowBack && !showDP) {
      return Image.network(
        UserDetails.photo,
        width: 111,
        height: 111,
        fit: BoxFit.fill,
      );
    }
    return !showDP
        ? Image.asset(
            "images/dp.png",
            fit: BoxFit.cover,
          )
        : Image.file(
            _image,
            width: 111,
            height: 111,
            fit: BoxFit.fill,
          );
  }

  // void getUserDetails(bool notStoreData) async {
  //   if (await checkInternet()) {
  //     UserDetails.getUserDetails(notStoreData: notStoreData, onlyImage: true)
  //         .then((value) {
  //       if (value) {
  //         _updateUserDetails();
  //       } else {
  //         setState(() {
  //           splash = false;
  //         });
  //       }
  //     });
  //   } else {
  //     // nextPage(context, const NoInternetPage());
  //   }
  // }

  // void _updateUserDetails() {
  //   final body = {
  //     "name": UserDetails.name,
  //     "email": "",
  //     "number": UserDetails.number,
  //     "dob": UserDetails.dob,
  //     "height": UserDetails.height,
  //     "weight": UserDetails.weight,
  //     "gender": UserDetails.gender,
  //     "face_type": UserDetails.faceType,
  //     "body_shape": UserDetails.bodyShape,
  //     "skin_tone": UserDetails.skinTone,
  //     "hair_type": UserDetails.hairType,
  //     "hair_length": UserDetails.hairLength,
  //     "beared_type": UserDetails.beardedType,
  //     "beared_length": UserDetails.beardLength,
  //     "image": UserDetails.photo,
  //   };
  //
  //   customPrint("sendUserDetails Body $body");
  //   UserDetails.updateUserDetails(body).then((value) {
  //     nextPageFade(
  //         context,
  //         const HomePage(
  //           splashAnimate: false,
  //         ));
  //   });
  // }

  Future<Uint8List?> testCompressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 200,
      minHeight: 200,
      quality: 10,
      rotate: 0,
    );
    customPrint(file.lengthSync());
    customPrint(result?.length);
    img64 = base64Encode(result!);
    customPrint("img64 img64 $img64");
    return result;
  }
}

// {name: User Name, email: , number: 1111111111, dob: 12/3/2022,
// height: 5.2, weight: 65.3, gender: Male, face_type: Heart Face,
// body_shape: Round, skin_tone: Sensitive  , hair_type: Long,
// hair_length: Shaved, beared_type: Clean Shaved,
// beared_length: Long, image:  }
