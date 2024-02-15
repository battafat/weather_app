class Weather {
  const Weather({
    required this.isDaytime, 
    required this.temperature, 
    required this.windSpeed, 
    required this.detailedForecast,
    });

  final bool isDaytime;
  final int temperature;
  final String windSpeed;
  final String detailedForecast;

  
  factory Weather.fromJson(Map<String, Object?> json)=> Weather(
    isDaytime: json['isDaytime'] as bool,
    temperature: json['temperature'] as int,
    windSpeed: json['windSpeed'] as String,
    detailedForecast: json['detailedForecast'] as String,
  );

  @override
  String toString() => '''
  isDaytime: ${isDaytime}
  temperature: ${temperature.toStringAsFixed(0)}°F
  windSpeed: $windSpeed
  Forecast: $detailedForecast
  ''';

}