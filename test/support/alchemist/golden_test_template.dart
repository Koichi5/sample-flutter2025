import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/weather/models/weather.dart';
import 'package:sample_flutter2025/weather/views/weather_screen.dart';

import '../../support/alchemist/golden_test_device_scenario.dart';

void main() {
  group('TestTarget Golden Test', () {
    Widget buildMyApp() {
      const mockWeather = Weather(
        currentWeather: CurrentWeather(
          temperature: 15.0,
          windSpeed: 10.0,
          weatherCode: 3,
        ),
      );
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        home: const WeatherScreen(weather: mockWeather),
      );
    }

    final phonePortrait = Device.phonePortrait;

    goldenTest(
      'Default',
      fileName: 'my_app_default',
      builder: () {
        return GoldenTestGroup(
          columns: 1,
          children: [
            GoldenTestDeviceScenario(
              name: phonePortrait.name,
              device: phonePortrait,
              builder: () => buildMyApp(),
            ),
          ],
        );
      },
    );
  });
}