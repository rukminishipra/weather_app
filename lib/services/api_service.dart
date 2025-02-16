import 'package:dio/dio.dart';
import '../config/api_constants.dart';
import '../models/location_model.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      final response = await _dio.get(
        '/locations/v1/cities/autocomplete',
        queryParameters: {
          'q': query,
          'apikey': ApiConstants.apiKey,
          'language': 'en-us',
        },
        options: Options(
          headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'Expires': '0',
          },
        ),
      );

      if (response.statusCode == 403) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'API key invalid or expired',
        );
      }

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Failed to search location: ${response.statusCode}',
        );
      }

      return (response.data as List)
          .map((json) => LocationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('DioException caught:');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  Response status: ${e.response?.statusCode}');
      print('  Response data: ${e.response?.data}');
      print('  Request: ${e.requestOptions.uri}');

      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Unable to connect to weather service. Please check your internet connection.');
      }
      rethrow;
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<dynamic>> getWeather(String locationId) async {
    try {
      final response = await _dio.get(
        '/currentconditions/v1/$locationId',
        queryParameters: {
          'apikey': ApiConstants.apiKey,
          'details': true,
          'language': 'en-us',
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Failed to get weather: ${response.statusCode}',
        );
      }

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      print('Weather DioException caught:');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  Response status: ${e.response?.statusCode}');
      print('  Response data: ${e.response?.data}');
      print('  Request: ${e.requestOptions.uri}');
      rethrow;
    } catch (e, stackTrace) {
      print('Unexpected weather error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchByGeoposition(
      double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/locations/v1/cities/geoposition/search',
        queryParameters: {
          'apikey': ApiConstants.apiKey,
          'q': '$lat,$lon',
          'language': 'en-us',
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error:
              'Failed to get location by geoposition: ${response.statusCode}',
        );
      }

      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error getting location by geoposition: $e');
      rethrow;
    }
  }
}
