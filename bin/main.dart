// import 'package:weather_app/weather_app.dart' as weather_app;

import 'dart:io';
import 'weather_api_client.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    print('Syntax: dart bin/main.dart <city>');
    return;
  }
  final city = arguments.first;
  final api = geocodeApiClient();
  // final latlngID = await api.getLatLng(city);
  // print(latlngID);
  try {
    final weather = await api.getWeather(city);
    print(weather);
  } on WeatherApiException catch (e) {
    print(e.message);
  } on SocketException catch (_){
    print('Could not fetch data. Check your connection.');
  } catch (e) {
    print(e);
  }
  
}

  // final locationID = await api.getLatLng(city);
  // print(locationID);
