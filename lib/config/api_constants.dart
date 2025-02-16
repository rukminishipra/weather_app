import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey {
    try {
      return dotenv.env['ACCUWEATHER_API_KEY'] ?? 'YOUR_DEFAULT_API_KEY';
    } catch (e) {
      print('Error loading API key: $e');
      return 'YOUR_DEFAULT_API_KEY';
    }
  }

  static const String baseUrl = 'https://dataservice.accuweather.com';
  static const String cacheKey = 'weather_cache';
  static const Duration cacheDuration = Duration(minutes: 30);
}
