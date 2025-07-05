import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/weather/models/weather.dart';
import 'package:sample_flutter2025/weather/widgets/weather_view.dart';

import '../../../support/alchemist/device.dart';

void main() {
  group('WeatherView Golden Tests', () {
    const mockWeather = Weather(
      currentWeather: CurrentWeather(
        temperature: 15.0,
        windSpeed: 10.0,
        weatherCode: 3, // Overcast
      ),
    );

    Widget buildApp({required Brightness brightness}) {
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: brightness,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const WeatherView(weather: mockWeather),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'weather_view',
      builder:
          () => GoldenTestGroup(
            columns: 2,
            children:
                Device.all
                    .map(
                      (device) => GoldenTestScenario(
                        name: device.name,
                        constraints: BoxConstraints.tight(device.size),
                        child: Builder(
                          builder: (context) {
                            return buildApp(brightness: device.brightness);
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
    );
  });
}
