// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherImpl _$$WeatherImplFromJson(Map<String, dynamic> json) =>
    _$WeatherImpl(
      currentWeather: CurrentWeather.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$WeatherImplToJson(_$WeatherImpl instance) =>
    <String, dynamic>{'current': instance.currentWeather};

_$CurrentWeatherImpl _$$CurrentWeatherImplFromJson(Map<String, dynamic> json) =>
    _$CurrentWeatherImpl(
      temperature: (json['temperature_2m'] as num).toDouble(),
      windSpeed: (json['windspeed_10m'] as num).toDouble(),
      weatherCode: (json['weathercode'] as num).toInt(),
    );

Map<String, dynamic> _$$CurrentWeatherImplToJson(
  _$CurrentWeatherImpl instance,
) => <String, dynamic>{
  'temperature_2m': instance.temperature,
  'windspeed_10m': instance.windSpeed,
  'weathercode': instance.weatherCode,
};
