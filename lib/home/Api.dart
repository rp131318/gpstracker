import 'package:geocoder/geocoder.dart';
import 'package:gpstracker/globalVariable.dart';

final DateTime now = DateTime.now();
final yesterday = now.subtract(const Duration(days: 1));

class HomeApi {
  static List<String> daysList = [
    addZero(now.day.toString()) +
        "/" +
        addZero(now.month.toString()) +
        "/" +
        getYear(now),
    addZero(yesterday.day.toString()) +
        "/" +
        addZero(yesterday.month.toString()) +
        "/" +
        getYear(yesterday),
    "15/02/22",
    "17/02/22",
    "23/02/22",
    "28/02/22",
    "01/03/22",
    "04/03/22",
    "10/03/22",
  ];
  static String daysSelected = "15/02/22";
  static String battery = "--";
  static List<String> subLocalityName = [];
  static List<String> subLocalityTime = [];
  static List<String> latitude = [];
  static List<String> longitude = [];

  static Future<void> getLocationNameUsingLatLong(
      double lat, double long) async {
    customPrint("Database lat :: $lat -- long :: $long");
    latitude.add(lat.toString());
    longitude.add(long.toString());
    final coordinates = Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    // if()
    if (first.addressLine != null) {
      HomeApi.subLocalityName.add(first.addressLine);
    } else if (first.subAdminArea != null) {
      HomeApi.subLocalityName.add(first.subAdminArea);
    }

    // customPrint("Database Sublocality :: ${first.subLocality}");
    // customPrint(
    //     'Database Location Data ${first.locality}- ${first.adminArea}-${first.subLocality}- ${first.subAdminArea}-${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  }

  static String getYear(DateTime now) {
    String year = now.year.toString();
    year = year.substring(2, 4);
    return year;
  }

  static String addZero(String string) {
    if (int.parse(string) > 9) {
      return string;
    }
    return "0" + string;
  }

// static Future<void> getLocations() async {
//   ///Url
//   String link = DatabaseApi.mainUrl + DatabaseApi.getLocations;
//   customPrint("Link getDetails :: $link");
//
//   ///Function
//   return await Dio().get(link).then((value) async {
//     customPrint("getDetails :: ${jsonDecode(value.data)}");
//     final jsonData = jsonDecode(value.data);
//     int len = getJsonLength(jsonData);
//     if (clearArray) {
//       name.clear();
//       image.clear();
//       description.clear();
//       cardsDetailsArray.clear();
//     }
//     if (jsonData[0]["response"] != null) {
//       return;
//     }
//     for (int i = 0; i < len; i++) {
//       name.add(jsonData[i]["name"].toString());
//       image.add(jsonData[i]["image"].toString());
//       description.add(jsonData[i]["description"].toString());
//       List<String> temp = dynamicToStatic(jsonData[i]["card_array"]);
//       cardsDetailsArray.add(temp);
//     }
//   });
// }
}
