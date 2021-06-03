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

    getWeatherData();
  }

  void getWeatherData() async {
    Location location = Location();
    await location.getLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    var unixYesterday = ((DateTime.now().millisecondsSinceEpoch / 1000) - 86400)
        .round(); // also https://www.unixtimestamp.com/

    NetworkHelper networkHelperCurrent = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
    NetworkHelper networkHelperHistorical = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$latitude&lon=$longitude&dt=$unixYesterday&appid=$apiKey');

    var currentWeatherData = await networkHelperCurrent.getData();
    var historicalWeatherData = await networkHelperHistorical.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(currentWeatherData, historicalWeatherData);
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
