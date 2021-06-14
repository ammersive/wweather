import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wweather/models/weather.dart';
import 'package:wweather/models/location.dart';
import 'package:wweather/services/current_location.dart';
import 'package:wweather/services/network_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'location_screen.dart';

String apiKey = env['OPENWEATHER_API'];

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = false;

  // @override
  void getWeatherData() async {
    CurrentLocation currentLocation = CurrentLocation();
    await currentLocation.getLocation();
    double currentLatitude = currentLocation.latitude;
    double currentLongitude = currentLocation.longitude;
    int unixYesterday = ((DateTime.now().millisecondsSinceEpoch / 1000) - 86400)
        .round(); // also https://www.unixtimestamp.com/

    List<Location> faveLocations =
        Provider.of<Weather>(context, listen: false).faveLocations;

    List<NetworkHelper> currentCalls = [];
    List currentResponses = [];
    faveLocations.forEach((location) {
      currentCalls.add(NetworkHelper(
          'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey'));
    });
    currentCalls.forEach((call) async {
      currentResponses.add(await call.getData());
    });
    Provider.of<Weather>(context).addLocationData(currentResponses);

    List<NetworkHelper> historicCalls = [];
    List historicResponses = [];
    faveLocations.forEach((location) {
      historicCalls.add(NetworkHelper(
          'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=${location.latitude}&lon=${location.longitude}&dt=$unixYesterday&appid=$apiKey'));
    });
    currentCalls.forEach((call) async {
      historicResponses.add(await call.getData());
    });

    Provider.of<Weather>(context).addLocationData(historicResponses);

    NetworkHelper networkHelperCurrent = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey');
    NetworkHelper networkHelperHistorical = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$currentLatitude&lon=$currentLongitude&dt=$unixYesterday&appid=$apiKey');

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
            child: isLoading
                ? SpinKitWave(
                    color: Colors.white,
                    size: 100.0,
                  )
                : FlatButton(
                    child: Text("Get weather data",
                        style: TextStyle(color: Colors.cyan)),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      getWeatherData();
                    },
                  )));
  }
}
