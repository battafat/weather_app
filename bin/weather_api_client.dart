import 'dart:convert';
import 'weather.dart';
import 'env/env.dart';

import 'package:http/http.dart' as http;

class WeatherApiException implements Exception {
  const WeatherApiException(this.message);
  final String message;
}

class geocodeApiClient {
  static const baseGeocodeUrl = 'https://maps.googleapis.com/maps/api/geocode';
  final googleMapsApiKey = Env.googleMapsApiKey;
  static const basePointsUrl = 'https://api.weather.gov/points';

  Future<String> getLatLng(String city) async {
    final localityURL = Uri.parse('$baseGeocodeUrl/json?components=locality:$city&key=$googleMapsApiKey');
    final localityResponse = await http.get(localityURL);
    if (localityResponse.statusCode != 200) {
      throw WeatherApiException('Error getting locationID for city: $city');
    }
    final localityJson = jsonDecode(localityResponse.body);
    final latLng = localityJson["results"].first["geometry"]["location"];
    final lat = latLng["lat"].toStringAsFixed(4);
    final lng = latLng["lng"].toStringAsFixed(4);
   
    final latlngID = "$lat,$lng";
    return latlngID;


  // https://maps.googleapis.com/maps/api/geocode/json?components=route:Annankatu|administrative_area:Helsinki|country:Finland&key=YOUR_API_KEY
  }

  Future<String> getForecastUrl(String latlngID) async {
    final pointsUrl = Uri.parse('$basePointsUrl/$latlngID');
    final pointsResponse = await http.get(pointsUrl);

    if (pointsResponse.statusCode != 200){
      throw WeatherApiException('Error getting forecastUrl for location: $latlngID');
    }
    final pointsJson = jsonDecode(pointsResponse.body);
    final forecastUrl = pointsJson['properties']['forecast'];
    return forecastUrl; 
  }

  Future<Weather> fetchWeather(String forecastUrl) async {
    final weatherUrl = Uri.parse(forecastUrl);
    final weatherResponse = await http.get(weatherUrl);
    if (weatherResponse.statusCode !=200) {
      throw WeatherApiException('Error getting weather for $forecastUrl');
    }
    final weatherJson = jsonDecode(weatherResponse.body);
    final periods = weatherJson['properties']['periods'] as List;
    if (periods.isEmpty){
      throw WeatherApiException(
        'Weather data not available for latlngID $forecastUrl');
    }
    return Weather.fromJson(periods[0]);
  }


  Future<Weather> getWeather(String city) async {
    final latlngID = await getLatLng(city);
    final forecastUrl = await getForecastUrl(latlngID);
    return fetchWeather(forecastUrl);
  }
}