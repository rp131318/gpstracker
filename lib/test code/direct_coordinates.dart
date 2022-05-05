import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'networking.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? mapController;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  // var data;

  //variable for google original APIS
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;

  // Dummy Start and Destination Points
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

  int i = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // setMarkers();
  }

  setMarkers(double endLatitude, double endLongitude) {
    print("setMarkers");
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(21.199334, 72.793018),
        infoWindow: InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );

    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position: LatLng(endLatitude, endLongitude),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star ratted place",
      ),
    ));
    setState(() {});
  }

  void getJsonData() async {
    try {
      print("hello world");
      while (responseLoop) {
        print("API Link :: https://breathemedicalsystems.com/recipee/get_location.php?start=$startApi&end=$endApi");
        await Dio()
            .get(
            "https://breathemedicalsystems.com/recipee/get_location.php?start=$startApi&end=$endApi")
            .then((value) async {
          print("printdata :: ${value.data}");

          final jsonData = jsonDecode(value.data);
          int lenn = getJsonLength(jsonData);
          print("length of array $lenn");
          if (jsonData[0]["response"].toString() == "true") {

            langStart = double.parse(jsonData[0]["longitude"]);
            latStart = double.parse(jsonData[0]["latitude"]);
            langEnd = double.parse(jsonData[lenn - 1]["longitude"]);
            latEnd = double.parse(jsonData[lenn - 1]["latitude"]);

            for (int i = 0; i < lenn - 1; i++) {
              double stlong = double.parse(jsonData[i]["longitude"]);
              double stlat = double.parse(jsonData[i]["latitude"]);
              // double enlong = double.parse(jsonData[i + 1]["longitude"]);
              // double enlat = double.parse(jsonData[i + 1]["latitude"]);

              print("startLongitude :: $stlong");
              await setPolylinesss(stlat,stlong);
              print("google polylines loop : $i");
            }
            setMarkers(latEnd, langEnd);
            print("startttt 1");
            setState(() {
              print("polyyyyydss : $polylineCoordinates");
              _polylines.add(
                  Polyline(
                      width: 4,
                      polylineId: PolylineId('polyLine'),
                      color: Color(0xFFCE0101),
                      points: polylineCoordinates
                  )
              );
            });
            print("startttt 2");
            startApi = startApi + 10;
          } else {
            print("No data yet");
            responseLoop = false;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    print("polylineeee start : $polyLines");
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
    print("polylineeee : $polyLines");
    print("polylineeee lengtht : ${polyLines.length}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    Timer.periodic(Duration(seconds: 20), (timer) {
      print(DateTime.now());
      if(!responseLoop){
        responseLoop=true;
        print("running after 20 seconds");
        getJsonData();
      }

    });
    getJsonData();
  }

  Future<void> setPolylinesss(double startLatitude,double startLongitude) async {
    print("google polylines function:: ");
    polylineCoordinates.add(LatLng(startLatitude,startLongitude));
  }

  int getJsonLength(jsonText) {
    int len = 0;
    try {
      while (jsonText[len] != null) {
        len++;
      }
      // customPrint("Len :: $len");
    } catch (e) {
      // customPrint("Len Catch :: $len");
      return len;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Polyline Demo'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(21.1702, 72.8311),
            zoom: 15,
          ),
          markers: markers,
          polylines: _polylines,
        ),
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);

  List<dynamic> lineString;
}
