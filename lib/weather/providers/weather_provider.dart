import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_flutter2025/weather/models/weather.dart';

part 'weather_provider.g.dart';

@riverpod
Future<Weather> weather(WeatherRef ref) async {
  final uri = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=35.6895&longitude=139.6917&current=temperature_2m,weathercode,windspeed_10m',
  );
  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      print('Failed to load weather: HTTP ${response.statusCode}');
      throw Exception('Failed to load weather: HTTP ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to load weather: $e');
    throw Exception('Failed to load weather: $e');
  }
}
