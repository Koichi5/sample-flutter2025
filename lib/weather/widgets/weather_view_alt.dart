import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_flutter2025/weather/providers/weather_provider.dart';
import 'package:sample_flutter2025/weather/widgets/weather_icon.dart';

class WeatherViewAlt extends HookConsumerWidget {
  const WeatherViewAlt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Weather (Alt)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: weatherAsyncValue.when(
          data:
              (weather) => Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Tokyo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        WeatherIcon(
                          weatherCode: weather.currentWeather.weatherCode,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${weather.currentWeather.temperature}°C',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.air),
                            const SizedBox(width: 8),
                            Text(
                              'Wind: ${weather.currentWeather.windSpeed} km/h',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          error:
              (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
        ),
      ),
    );
  }
}
