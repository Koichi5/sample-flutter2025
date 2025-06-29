import 'package:flutter/material.dart';
import 'package:sample_flutter2025/weather/models/weather.dart';
import 'package:sample_flutter2025/weather/widgets/weather_icon.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tokyo Weather')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WeatherIcon(weatherCode: weather.currentWeather.weatherCode),
            Text(
              '${weather.currentWeather.temperature}°C',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('Wind Speed: ${weather.currentWeather.windSpeed} km/h'),
          ],
        ),
      ),
    );
  }
}
