import 'package:firstly/main.dart';
import 'package:firstly/repositories/weather_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';

final locationSearchProvider = StateProvider<List<LocationModel>>((ref) => []);

final selectedLocationProvider = StateProvider<LocationModel?>((ref) => null);

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherModel>>((ref) {
  return WeatherNotifier(ref.watch(weatherRepositoryProvider));
});

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherModel>> {
  final WeatherRepository _repository;

  WeatherNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> getWeather(String locationId, String locationName) async {
    try {
      state = const AsyncValue.loading();
      final weather = await _repository.getWeather(locationId, locationName);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
