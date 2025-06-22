import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.weatherCode});
  final int weatherCode;

  IconData _getIconData(int weatherCode) {
    switch (weatherCode) {
      case 0: // Clear sky
        return Icons.wb_sunny;
      case 1: // Mainly clear
      case 2: // Partly cloudy
      case 3: // Overcast
        return Icons.cloud;
      case 45: // Fog
      case 48: // Depositing rime fog
        return Icons.foggy;
      case 51: // Drizzle: Light
      case 53: // Drizzle: Moderate
      case 55: // Drizzle: Dense intensity
      case 56: // Freezing Drizzle: Light
      case 57: // Freezing Drizzle: Dense
        return Icons.water_drop;
      case 61: // Rain: Slight
      case 63: // Rain: Moderate
      case 65: // Rain: Heavy intensity
      case 66: // Freezing Rain: Light
      case 67: // Freezing Rain: Heavy
        return Icons.grain;
      case 71: // Snow fall: Slight
      case 73: // Snow fall: Moderate
      case 75: // Snow fall: Heavy intensity
      case 77: // Snow grains
        return Icons.ac_unit;
      case 80: // Rain showers: Slight
      case 81: // Rain showers: Moderate
      case 82: // Rain showers: Violent
        return Icons.shower;
      case 85: // Snow showers slight
      case 86: // Snow showers heavy
        return Icons.snowing;
      case 95: // Thunderstorm: Slight or moderate
      case 96: // Thunderstorm with slight hail
      case 99: // Thunderstorm with heavy hail
        return Icons.thunderstorm;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(weatherCode),
      size: 100,
      color: Colors.orangeAccent,
    );
  }
}