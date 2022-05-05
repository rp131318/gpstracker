import 'dart:developer';

// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkHelper{
  NetworkHelper({required this.startLng,required this.startLat,required this.endLng,required this.endLat});

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408';
  final String journeyMode = 'foot-walking'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    String link = "https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408&start=90.532171,23.551904&end=90.531813,23.560625";
    await Dio().get(link).then((value){
      log("Res :: ${value.data}");
      return jsonDecode(value.data);
    });


    // http.Response response = await http.get("https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408&start=90.532171,23.551904&end=90.531813,23.560625");
    // print("response ss : $response");
    // if(response.statusCode == 200) {
    //
    //   String data = response.body;
    //   return jsonDecode(data);
    //
    // }
    // else{
    //   print(response.statusCode);
    // }
  }

//https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408&start=23.551904,90.532171&end=23.560625,90.531813
//https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf624814262ce9caa7455c94f657fe795b6408&start=90.532171,23.551904&end=90.531813,23.560625
}