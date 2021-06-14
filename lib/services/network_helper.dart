// import 'dart:html';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = env['OPENWEATHER_API'];

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return convert.jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

// class UrlBuilder {
//   UrlBuilder({this.lattitude, this.longitude, this.apiKey})
// }
//
// NetworkHelper networkHelperCurrent = NetworkHelper(
//     'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
