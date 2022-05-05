import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/Api/global_api.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/Widgets/new_button.dart';
import 'package:gpstracker/globalVariable.dart';
import 'package:gpstracker/home/home_page.dart';
import 'package:gpstracker/main.dart';
import 'package:gpstracker/registration/Api.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';
import 'package:ms_undraw/ms_undraw.dart';
import '../Widgets/placeholder_widget.dart';
import '../utils/colors.dart';

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({Key? key}) : super(key: key);

  @override
  _RegisterDevicePageState createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  int favDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favDevice = prefs.getInt(LSKey.favDeviceIndex) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(constants.defaultPadding),
                  child: UnDraw(
                    height: 188.h,
                    color: colorDark,
                    illustration: UnDrawIllustration.devices,
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
                      "Active Devices",
                      style: textStyle.heading,
                    ),
                  ),
                ),
                const SizedBox(
                  height: constants.defaultPadding,
                ),
                checkResponse(RegistrationApi.registerDevices)
                    ? Column(
                        children: List.generate(
                            List.of(RegistrationApi.registerDevices).length,
                            (index) {
                          return Card(
                            semanticContainer: true,
                            elevation: 0,
                            color: colorCustom.shade50,
                            margin: const EdgeInsets.only(
                                left: constants.defaultPadding,
                                right: constants.defaultPadding,
                                top: constants.defaultPadding),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: constants.borderRadius),
                            child: ListTile(
                              onTap: () {
                                // RegistrationTempDetails.deviceName =
                                //     RegistrationApi.registerDevices[index]
                                //         ["device_name"];
                                // final temp = RegistrationApi
                                //     .registerDevices[index]["device_model_no"]
                                //     .toString();
                                //
                                // if (temp.split("-").length == 1) {
                                //   RegistrationTempDetails.deviceCode =
                                //       temp.split("-")[1];
                                // }
                                // nextPage(
                                //     context,
                                //     const HomePage(
                                //       changeDevice: true,
                                //     ));
                              },
                              leading: const Icon(
                                Icons.devices,
                                size: 33,
                                color: colorDark,
                              ),
                              title: Text(
                                RegistrationApi.registerDevices[index]
                                    ["device_name"],
                                style: textStyle.subHeadingColorDark,
                              ),
                              subtitle: Text(
                                RegistrationApi.registerDevices[index]
                                    ["device_model_no"],
                                style: textStyle.smallText,
                              ),
                              trailing: InkWell(
                                onTap: () async {
                                  setState(() {
                                    favDevice = index;
                                  });
                                  await prefs.setInt(
                                      LSKey.favDeviceIndex, index);
                                },
                                child: favDevice == index
                                    ? const Icon(
                                        Icons.favorite,
                                        size: 26,
                                        color: colorDark,
                                      )
                                    : Icon(
                                        Icons.favorite_border_rounded,
                                        size: 26,
                                        color: colorCustom.shade400,
                                      ),
                              ),
                            ),
                          );
                        }),
                      )
                    : loadingWidget(),
                const SizedBox(
                  height: constants.defaultPadding * 2,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NewButton(
              context: context,
              function: () {
                nextPage(context, const HomePage());
              },
              buttonText: "Save Favourite",
              margin: const EdgeInsets.all(constants.defaultPadding),
            ),
          ),
        ],
      ),
    );
  }
}
