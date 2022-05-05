import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracker/Api/global_api.dart';
import 'package:gpstracker/Api/local_storage.dart';
import 'package:gpstracker/Widgets/my_dropdown.dart';
import 'package:gpstracker/Widgets/new_button.dart';
import 'package:gpstracker/Widgets/splash_screen.dart';
import 'package:gpstracker/home/Api.dart';
import 'package:gpstracker/home/widgets/battery_section.dart';
import 'package:gpstracker/home/widgets/bottom_sheet_data.dart';
import 'package:gpstracker/home/widgets/home_drawer_widget.dart';
import 'package:gpstracker/home/widgets/location_details.dart';
import 'package:gpstracker/home/widgets/top_title.dart';
import 'package:gpstracker/main.dart';
import 'package:gpstracker/utils/colors.dart';
import 'package:gpstracker/utils/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excelSheet;

import '../Widgets/bottom_sheet_line.dart';
import '../globalVariable.dart';
import '../registration/Api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.changeDevice = false}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
  final bool changeDevice;
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  // var data;

  ///variable for google original APIS
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;

  /// Dummy Start and Destination Points
  double startLat = 21.180595;
  double startLng = 72.817936;
  double endLat = 21.192161;
  double endLng = 72.817338;
  double langStart = 0.0;
  double latStart = 21.180000;
  double langEnd = 72.818936;
  double latEnd = 0.0;
  int startApi = 0;
  int endApi = 10;
  bool responseLoop = true;
  bool dayChange = false;
  final List<Marker> _markers = [];
  bool live = true;
  int timeCounter = 0;
  List<double> anchors = [0, 0.5];
  double maxHeight = 0.5;

  @override
  void initState() {
    super.initState();
    if (!widget.changeDevice) {
      RegistrationApi.getRegisterDevice(context).then((value) {
        setState(() {});
        getJsonData();
        startLoop();
      });
    }
    polylinePoints = PolylinePoints();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppExitPopup(context);
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: checkResponse(RegistrationApi.registerDevices) || true
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(21.1702, 72.8311),
                      zoom: 11,
                    ),
                    markers: markers,
                    polylines: _polylines,
                  ),
                  TopTitle(scaffoldKey: _scaffoldKey),
                  BottomSheetData(
                    live: live,
                    onPress: () async {
                      showFlexibleBottomSheet(
                        minHeight: 0,
                        initHeight: 0.5,
                        maxHeight: maxHeight,
                        context: context,
                        builder: _buildBottomSheet,
                        anchors: anchors,
                      );
                    },
                  ),
                ],
              )
            : const SplaceScreen(),
        drawer: const HomeDrawerWidget(),
      ),
    );
  }

  void restartArray() {
    HomeApi.subLocalityName.clear();
    HomeApi.subLocalityTime.clear();
    HomeApi.latitude.clear();
    HomeApi.longitude.clear();
    polylineCoordinates.clear();
    _polylines.clear();
    markers.clear();
    _markers.clear();
    responseLoop = false;
    startApi = 0;
    dayChange = false;
  }

  setMarkers(double endLatitude, double endLongitude, String time) async {
    markers.add(
      Marker(
        markerId: const MarkerId("Home"),
        position: LatLng(endLatitude, endLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: "Live Location",
          snippet: time,
        ),
      ),
    );
  }

  void setMultipleMarkers(double latitude, double longitude, String time) {
    _markers.add(Marker(
      markerId: MarkerId('Marker $startApi'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: time),
    ));

    setState(() {
      markers.addAll(_markers);
    });
  }

  void getJsonData() async {
    try {
      customPrint("hello world");
      while (responseLoop) {
        if (dayChange) {
          restartArray();
        }
        // String link =
        //     "https://breathemedicalsystems.com/recipee/get_location.php?"
        //     "start=$startApi&type=${HomeApi.daysSelected.toLowerCase()}&number=91${prefs.getString("number")}";
        // if (debugMode) {
        String link =
            "https://breathemedicalsystems.com/recipee/get_location.php?start=$startApi&"
                    "type=Today&test=yes&date=${HomeApi.daysSelected}&number=" +
                checkCountryCode(prefs.getString(
                        LSKey.qrNumber + RegistrationTempDetails.deviceCode) ??
                    "");
        // }
        customPrint("API Link :: $link");
        await Dio().get(link).then((value) async {
          customPrint("customPrintdata :: ${value.data}");
          if (timeCounter > 25) {
            setState(() {
              live = false;
            });
          }
          final jsonData = jsonDecode(value.data);
          int lenn = getJsonLength(jsonData);
          customPrint("length of array $lenn");
          if (jsonData[0]["response"].toString() == "true" && lenn > 1) {
            setState(() {
              live = true;
            });
            timeCounter = 0;
            for (int i = 0; i < lenn - 1; i++) {
              double stlong = double.parse(jsonData[i]["longitude"]);
              double stlat = double.parse(jsonData[i]["latitude"]);
              double enlong = double.parse(jsonData[i + 1]["longitude"]);
              double enlat = double.parse(jsonData[i + 1]["latitude"]);
              if (startApi == 0) {
                HomeApi.subLocalityTime.add(jsonData[i]["time"].toString());
                HomeApi.battery = jsonData[i]["battery"].toString();
                await HomeApi.getLocationNameUsingLatLong(stlat, stlong)
                    .then((value) {
                  // customPrint("Database Full Address :: $value");
                });
              }
              HomeApi.subLocalityTime.add(jsonData[i + 1]["time"].toString());
              HomeApi.battery = jsonData[i + 1]["battery"].toString();

              ///Red Marker
              setMultipleMarkers(stlat, stlong, jsonData[i]["time"].toString());

              ///Green Marker
              setMarkers(enlat, enlong, jsonData[i + 1]["time"].toString());

              await HomeApi.getLocationNameUsingLatLong(enlat, enlong)
                  .then((value) {
                // customPrint("Database Full Address :: $value");
              });

              if (HomeApi.subLocalityName.length > 10) {
                setState(() {
                  anchors = [0, 0.5, 1];
                  maxHeight = 1;
                });
              }

              await getAllGoogleCoordinates(stlat, stlong, enlat, enlong);

              customPrint("I Value :: $i");
            }
            customPrint("Database Battery :: ${HomeApi.battery}");
            customPrint("Database Time :: ${HomeApi.subLocalityTime}");
            customPrint("Database Name :: ${HomeApi.subLocalityName}");
            setPolyLines();
            startApi = startApi + 1;
          } else {
            customPrint("No data yet");
            responseLoop = false;
          }
          customPrint("subLocalityTime :: ${HomeApi.subLocalityTime}");
          customPrint("subLocalityName :: ${HomeApi.subLocalityName}");
        });
        setState(() {});
      }
    } catch (e) {
      customPrint(e);
    }
  }

  setPolyLines() {
    customPrint("poly_coordinates :: $polylineCoordinates");
    customPrint("poly_coordinates length :: ${polylineCoordinates.length}");
    setState(() {
      _polylines.add(Polyline(
          width: 4,
          polylineId: const PolylineId('polyLine'),
          color: Colors.red,
          points: polylineCoordinates));
    });
  }

  Future<void> getAllGoogleCoordinates(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) async {
    customPrint("google polylines function:: ");
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
        "AIzaSyCuVPIWgsGqpm3zgpixG0JOa5onEybjquc",
        PointLatLng(startLatitude, startLongitude),
        PointLatLng(endLatitude, endLongitude),
        travelMode: TravelMode.walking);

    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      customPrint(
          "google polylines coordinates :: ${polylineCoordinates.length}");
    }
  }

  void startLoop() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      GlobalApi.storeDataToInternet();
      if (!responseLoop) {
        responseLoop = true;
        customPrint("running after 5 seconds");
        getJsonData();
        timeCounter++;
      } else {
        // showSnackbar(context, "responseLoop :: $responseLoop", Colors.red);
      }
    });
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    customPrint("bottomSheetOffset :: $bottomSheetOffset");
    return StatefulBuilder(builder: (context, _setState) {
      return SafeArea(
        child: Material(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(constants.radius * 2),
              topLeft: Radius.circular(constants.radius * 2)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const BottomSheetLine(),
                    const SizedBox(
                      height: constants.defaultPadding,
                    ),
                    BatterySection(live: live),
                    MyDropDown(
                        margin: const EdgeInsets.only(
                            top: constants.defaultPadding / 2,
                            left: constants.defaultPadding,
                            right: constants.defaultPadding),
                        onChange: (value) {
                          Navigator.pop(context);
                          setState(() {
                            HomeApi.daysSelected = value!;
                            dayChange = true;
                          });
                        },
                        defaultValue: HomeApi.daysSelected,
                        array: HomeApi.daysList),
                    LocationDetails(
                      live: live,
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                  ],
                ),
              ),
              Container(
                color: colorWhite,
                child: NewButton(
                  context: context,
                  function: () {
                    if (HomeApi.subLocalityTime.isEmpty ||
                        HomeApi.subLocalityName.isEmpty) {
                      Navigator.pop(context);
                      showSnackbar(
                          context,
                          "Location data not available for creation of excel.",
                          colorWarning);

                      return;
                    }
                    downloadDataInExcel();
                  },
                  margin: const EdgeInsets.all(constants.defaultPadding),
                  buttonText: "Download in Excel",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void downloadDataInExcel() async {
    final excelSheet.Workbook workbook = excelSheet.Workbook();
    final excelSheet.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText("Location Time");
    sheet.getRangeByName('B1').setText("Latitude");
    sheet.getRangeByName('C1').setText("Longitude");
    sheet.getRangeByName('D1').setText("Location Name");
    for (int i = 0; i < HomeApi.subLocalityName.length; i++) {
      sheet.getRangeByName('A${i + 2}').setText(HomeApi.subLocalityTime[i]);
      sheet.getRangeByName('B${i + 2}').setText(HomeApi.latitude[i]);
      sheet.getRangeByName('C${i + 2}').setText(HomeApi.longitude[i]);
      sheet.getRangeByName('D${i + 2}').setText(HomeApi.subLocalityName[i]);
    }

    sheet.getRangeByName("A1").autoFit();
    sheet.getRangeByName("B1").autoFit();
    sheet.getRangeByName("C1").autoFit();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    ///
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/${DateTime.now()}-GPS-Data.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  String checkCountryCode(String string) {
    if (string.length > 10) {
      return string;
    }
    return "91" + string;
  }
}
