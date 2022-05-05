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

  Set<Marker> markers_point = Set();

  //variable for google original APIS
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints ?polylinePoints;

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

  double stlong = 0;
  double stlat = 0;
  double enlong = 0;
  double enlat = 0;

  int i = 0;
  List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // setMarkers();
  }

  setMarkers() {
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
      position: LatLng(latEnd, langEnd),
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
        print(
            "API Link :: https://breathemedicalsystems.com/recipee/get_location.php?start=$startApi");
        await Dio()
            .get(
            "https://breathemedicalsystems.com/recipee/get_location.php?start=$startApi")
            .then((value) async {
          print("printdata :: ${value.data}");

          final jsonData = jsonDecode(value.data);
          int lenn = getJsonLength(jsonData);
          print("length of array $lenn");
          if (jsonData[0]["response"].toString() == "true" && lenn > 1) {
            langStart = double.parse(jsonData[0]["longitude"]);
            latStart = double.parse(jsonData[0]["latitude"]);
            langEnd = double.parse(jsonData[lenn - 1]["longitude"]);
            latEnd = double.parse(jsonData[lenn - 1]["latitude"]);

            for (int i = 0; i < lenn - 1; i++) {
              stlong = double.parse(jsonData[i]["longitude"]);
              stlat = double.parse(jsonData[i]["latitude"]);
              enlong = double.parse(jsonData[i + 1]["longitude"]);
              enlat = double.parse(jsonData[i + 1]["latitude"]);

              _markers.add(Marker(
                markerId: MarkerId('Marker $startApi'),
                position: LatLng(stlat, stlong),
                infoWindow: InfoWindow(title: 'Business $startApi'),
              ));

              setState(() {
                markers.addAll(_markers);
              });

              double distance = calculateDistance(stlat, stlong, enlat, enlong);

              String link =
                  "https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408&start=$stlong,$stlat&end=$enlong,$enlat";
              await Dio().get(link).then((value) {
                print("data from coor :: ${value.data}");

                // We can reach to our desired JSON data manually as following
                print(
                    "Res coordinates :: ${jsonDecode(value.data)["features"][0]['geometry']['coordinates']}");

                LineString ls = LineString(jsonDecode(value.data)['features'][0]
                ['geometry']['coordinates']);

                print("lengthog google : ${ls.lineString.length}");

                if(ls.lineString.length < 20){
                  for (int j = 0; j < ls.lineString.length; j++) {
                    polyPoints
                        .add(LatLng(ls.lineString[j][1], ls.lineString[j][0]));
                    print("fff polyPoints : ${ls.lineString[j][1]}");
                  }
                }else{
                  polyPoints.add(LatLng(stlat,stlong));
                }


              });
              print("length integer value $i");
            }
            setMarkers();
            setPolyLines();
            startApi = startApi + 1;
          } else {
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
      width: 3,
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
    getJsonData();
    Timer.periodic(Duration(seconds: 5), (timer) {
      print(DateTime.now());
      if(!responseLoop){
        responseLoop = true;
        print("running after 5 seconds");
        getJsonData();
      }

    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    double distance_bet = 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    distance_bet = (12742 * asin(sqrt(a))) * 1000;
    print("distance between :: $distance_bet");
    return distance_bet;
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
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(21.1702, 72.8311),
            zoom: 15,
          ),
          markers: markers,
          polylines: polyLines,
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
