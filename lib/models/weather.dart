import 'package:flutter/foundation.dart';
import 'package:wweather/models/location.dart';

class Weather extends ChangeNotifier {
  List<Location> faveLocations = [
    Location(51.454853, -2.627298), // The Gorge
    Location(51.287586, -2.752947), // Cheddar
    Location(51.672440, -2.683341), // Wyndcliffe
  ];

  List locationData = []; // TODO, currently unordered, store data better

  void addLocationData(locationDataResponse) {
    locationData.add(locationDataResponse);
  }
  // var sorted = locationDataResponse.sort((a, b) {
  //   return a.value['name']
  //       .toString()
  //       .toLowerCase()
  //       .compareTo(b.value['name'].toString().toLowerCase());
  // });
  // locationData.add(locationDataResponse.sort((a, b) =>
  //      a.value['name']
  //         .toString()
  //         .toLowerCase()
  //         .compareTo(b.value['name'].toString().toLowerCase())));
}
