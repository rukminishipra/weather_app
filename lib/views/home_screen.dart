import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/location_search.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showLocationSearch(context),
          ),
        ],
      ),
      body: selectedLocation == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Search for a location',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showLocationSearch(context),
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                  ),
                ],
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(16.0),
              child: WeatherCard(),
            ),
      floatingActionButton: selectedLocation == null
          ? null
          : FloatingActionButton(
              onPressed: () => ref.read(weatherProvider.notifier).getWeather(
                    selectedLocation.id,
                    '${selectedLocation.name}, ${selectedLocation.country}',
                  ),
              child: const Icon(Icons.refresh),
            ),
    );
  }

  void _showLocationSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => const LocationSearch(),
      ),
    );
  }
}
