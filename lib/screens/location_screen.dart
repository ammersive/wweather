import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen(this.locationData, this.historicalData);

  final locationData;
  final historicalData;

  @override
  Widget build(BuildContext context) {
    String description = locationData['weather'][0]['description'];
    String city = locationData['name'];

    print('current data: $locationData');
    // print('historical data: $historicalData');

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('images/location_background.jpg'),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //         Colors.white.withOpacity(0.8), BlendMode.dstATop),
        //   ),
        // ),
        // constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Center(child: Text('The weather in $city is $description')),
        ),
      ),
    );
  }
}
