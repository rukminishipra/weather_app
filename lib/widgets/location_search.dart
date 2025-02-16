import 'package:firstly/main.dart';
import 'package:firstly/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class LocationSearch extends ConsumerStatefulWidget {
  const LocationSearch({super.key});

  @override
  ConsumerState<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends ConsumerState<LocationSearch> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      if (query.length >= 3) {
        ref
            .read(weatherRepositoryProvider)
            .searchLocation(query)
            .then((locations) {
          ref.read(locationSearchProvider.notifier).state = locations;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationSearchProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search location',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                title: Text(location.name),
                subtitle: Text(location.country),
                onTap: () {
                  ref.read(selectedLocationProvider.notifier).state = location;
                  ref.read(weatherProvider.notifier).getWeather(
                        location.id,
                        '${location.name}, ${location.country}',
                      );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
