import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpstracker/registration/Api.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:gpstracker/utils/text_styles.dart';

class TopTitle extends StatelessWidget {
  const TopTitle({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(
            top: constants.defaultPadding * 2.5,
            left: constants.defaultPadding,
            bottom: constants.defaultPadding),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(constants.radius * 2),
              bottomLeft: Radius.circular(constants.radius * 2)),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        width: double.infinity,
        height: 70,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(
                Icons.menu_rounded,
                size: 28,
                color: colorDark,
              ),
            ),
            const SizedBox(
              width: constants.defaultPadding,
            ),
            Text(
              RegistrationTempDetails.deviceName,
              style: textStyle.heading,
            )
          ],
        ),
      ),
    );
  }
}
