import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/registration/device_name_page.dart';
import 'package:gpstracker/registration/qr_scan_page.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

import '../../globalVariable.dart';
import '../../main.dart';
import '../../register_devices/register_device_page.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.account_circle_rounded,
                  size: 44,
                  color: colorDark,
                ),
                title: Text(
                  "Hello User !",
                  style: textStyle.subHeadingColorDark,
                ),
                subtitle: Text(
                  "Register device 2",
                  style: textStyle.smallText,
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              DrawerOptions(
                icon: Icons.add,
                text: "Add Device",
                subTitle: "Register new module",
                onPress: () {
                  nextPage(
                      context,
                      const DeviceNamePage(
                        backPress: true,
                      ));
                },
              ),
              DrawerOptions(
                icon: Icons.change_history_rounded,
                text: "Switch Device",
                subTitle: "Switch to another device",
                onPress: () {
                  nextPage(context, const RegisterDevicePage());
                },
              ),
              DrawerOptions(
                icon: Icons.privacy_tip_outlined,
                text: "Privacy Policy",
                subTitle: "Our privacy and policy of app",
                onPress: () {},
              ),
              DrawerOptions(
                icon: Icons.phone,
                text: "Contact Us",
                subTitle: "Help support and feedback",
                onPress: () {},
              ),
              DrawerOptions(
                icon: Icons.logout,
                text: "Logout",
                subTitle: "Logout from app",
                onPress: () {
                  ///Logout
                  logoutUser(context);
                  prefs.remove(LSKey.isDeviceRegister);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerOptions extends StatelessWidget {
  const DrawerOptions({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPress,
    required this.subTitle,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final String subTitle;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: constants.borderRadius),
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.only(
          left: constants.defaultPadding,
          right: constants.defaultPadding,
          top: constants.defaultPadding * 1.5),
      child: ListTile(
        onTap: () {
          onPress();
        },
        leading: Icon(
          icon,
          size: 26,
          color: colorDark,
        ),
        title: Text(
          text,
          style: textStyle.subHeadingColorDark.copyWith(color: colorDark),
        ),
        subtitle: Text(
          subTitle,
          style: textStyle.smallText,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colorDark,
        ),
      ),
    );
  }
}
