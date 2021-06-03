import 'package:flutter/material.dart';
import 'package:wweather/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = env['OPENWEATHER_API'];

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();

    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    await location.getLocation(); // can only await methods that rtn Futures
    latitude = location.latitude;
    longitude = location.longitude;
  }

  void getData() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = convert.jsonDecode(data);
      var description = decodedData['weather'][0]['description'];

      print('The weather is $description');
    } else {
      print('failed with ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        // body: Center(
        //   child: RaisedButton(
        //     onPressed: () {
        //       //Get the current location
        //       getLocation();
        //     },
        //     child: Text('Get Location'),
        //   ),
        // ),
        );
  }
}
