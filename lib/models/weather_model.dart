import 'package:flutter/foundation.dart';

@immutable
class WeatherModel {
  final double temperature;
  final String condition;
  final String location;
  final String iconCode;
  final DateTime lastUpdated;

  const WeatherModel({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.iconCode,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String location) {
    return WeatherModel(
      temperature: json['Temperature']['Metric']['Value'].toDouble(),
      condition: json['WeatherText'],
      location: location,
      iconCode: json['WeatherIcon'].toString().padLeft(2, '0'),
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'condition': condition,
        'location': location,
        'iconCode': iconCode,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}
