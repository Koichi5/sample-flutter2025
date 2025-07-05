import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/weather/widgets/weather_icon.dart';


import '../../support/alchemist/device.dart';

void main() {
  group('WeatherIcon Golden Tests', () {
    const mockWeatherCode = 3; // Overcast

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
        home: const WeatherIcon(weatherCode: mockWeatherCode),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'weather_icon',
      builder: () => GoldenTestGroup(
        columns: 2,
        children: Device.all
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
