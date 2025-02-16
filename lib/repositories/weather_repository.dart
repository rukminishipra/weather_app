import '../models/weather_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService _apiService;
  LocationModel? _selectedLocation;

  WeatherRepository(this._apiService);

  Future<List<LocationModel>> searchLocation(String query) {
    return _apiService.searchLocation(query);
  }

  Future<WeatherModel> getWeather(
      String locationId, String locationName) async {
    final data = await _apiService.getWeather(locationId);
    return WeatherModel.fromJson(data[0], locationName);
  }

  void setSelectedLocation(LocationModel location) {
    _selectedLocation = location;
  }

  LocationModel? get selectedLocation => _selectedLocation;
}
