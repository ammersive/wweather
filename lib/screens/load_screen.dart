import 'package:flutter/material.dart';
import 'package:wweather/services/location.dart';
import 'package:wweather/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'location_screen.dart';

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

    getLocationData();
  }

  void getLocationData() async {
    Location location = Location();
    await location.getLocation(); // can only await methods that rtn Futures
    latitude = location.latitude;
    longitude = location.longitude;

    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');

    var weatherData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(weatherData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: SpinKitWave(
            color: Colors.white,
            size: 100.0,
          ),
        ));
  }
}
