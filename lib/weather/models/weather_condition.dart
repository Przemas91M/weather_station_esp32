import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class WeatherCondition extends Equatable {
  final String condition;
  final IconData icon;
  final Color iconColor;
  static const Map<int, Map<String, dynamic>> conditionCodesMap = {
    1000: {
      'name': 'Sunny',
      'icon': WeatherIcons.day_sunny,
      'color': ColorPalette.yellow
    },
    1003: {
      'name': 'Partly cloudy',
      'icon': WeatherIcons.day_cloudy,
      'color': ColorPalette.lightBlue
    },
    1006: {
      'name': 'Cloudy',
      'icon': WeatherIcons.cloudy,
      'color': ColorPalette.lightBlue
    },
    1009: {
      'name': 'Overcast',
      'icon': WeatherIcons.day_sunny_overcast,
      'color': ColorPalette.lightBlue
    },
    1030: {
      'name': 'Mist',
      'icon': WeatherIcons.day_fog,
      'color': ColorPalette.lightBlue
    },
    1063: {
      'name': 'Patchy rain',
      'icon': WeatherIcons.rain_mix,
      'color': ColorPalette.lightBlue
    },
    1066: {
      'name': 'Patchy snow',
      'icon': WeatherIcons.snow,
      'color': ColorPalette.lightBlue
    },
    1069: {
      'name': 'Patchy sleet',
      'icon': WeatherIcons.sleet,
      'color': ColorPalette.lightBlue
    },
    1072: {
      'name': 'Patchy freezing drizzle',
      'icon': WeatherIcons.sprinkle,
      'color': ColorPalette.lightBlue
    },
    1087: {
      'name': 'Thundery outbreaks',
      'icon': WeatherIcons.lightning,
      'color': ColorPalette.lightBlue
    },
    1114: {
      'name': 'Blowing snow',
      'icon': WeatherIcons.snow_wind,
      'color': ColorPalette.lightBlue
    },
    1117: {
      'name': 'Blizzard',
      'icon': WeatherIcons.storm_showers,
      'color': ColorPalette.lightBlue
    },
    1135: {'name': 'Fog', 'icon': WeatherIcons.fog, 'color': ColorPalette.gray},
    1147: {
      'name': 'Freezing fog',
      'icon': WeatherIcons.fog,
      'color': ColorPalette.lightBlue
    },
    1150: {
      'name': 'Patchy light drizzle',
      'icon': WeatherIcons.day_sprinkle,
      'color': ColorPalette.lightBlue
    },
    1153: {
      'name': 'Light drizzle',
      'icon': WeatherIcons.sprinkle,
      'color': ColorPalette.lightBlue
    },
    1168: {
      'name': 'Freezing drizzle',
      'icon': WeatherIcons.sprinkle,
      'color': ColorPalette.lightBlue
    },
    1171: {
      'name': 'Heavy freezing drizzle',
      'icon': WeatherIcons.sprinkle,
      'color': ColorPalette.lightBlue
    },
    1180: {
      'name': 'Patchy light rain',
      'icon': WeatherIcons.day_rain_mix,
      'color': ColorPalette.lightBlue
    },
    1183: {
      'name': 'Light rain',
      'icon': WeatherIcons.rain_mix,
      'color': ColorPalette.lightBlue
    },
    1186: {
      'name': 'Moderate rain at times',
      'icon': WeatherIcons.hail,
      'color': ColorPalette.lightBlue
    },
    1189: {
      'name': 'Moderate rain',
      'icon': WeatherIcons.rain,
      'color': ColorPalette.lightBlue
    },
    1192: {
      'name': 'Heavy rain at times',
      'icon': WeatherIcons.rain,
      'color': ColorPalette.lightBlue
    },
    1195: {
      'name': 'Heavy rain',
      'icon': WeatherIcons.rain,
      'color': ColorPalette.lightBlue
    },
    1198: {
      'name': 'Light freezing rain',
      'icon': WeatherIcons.rain_wind,
      'color': ColorPalette.lightBlue
    },
    1201: {
      'name': 'Moderate / heavy freezing rain',
      'icon': WeatherIcons.rain_wind,
      'color': ColorPalette.lightBlue
    },
    1204: {
      'name': 'Light sleet',
      'icon': WeatherIcons.day_sleet,
      'color': ColorPalette.lightBlue
    },
    1207: {
      'name': 'Moderate / heavy sleet',
      'icon': WeatherIcons.sleet,
      'color': ColorPalette.lightBlue
    },
    1210: {
      'name': 'Patchy light snow',
      'icon': WeatherIcons.day_snow,
      'color': ColorPalette.lightBlue
    },
    1213: {
      'name': 'Light snow',
      'icon': WeatherIcons.day_snow,
      'color': ColorPalette.lightBlue
    },
    1216: {
      'name': 'Patchy moderate snow',
      'icon': WeatherIcons.snow,
      'color': ColorPalette.lightBlue
    },
    1219: {
      'name': 'Moderate snow',
      'icon': WeatherIcons.snow,
      'color': ColorPalette.lightBlue
    },
    1222: {
      'name': 'Patchy heavy snow',
      'icon': WeatherIcons.snow_wind,
      'color': ColorPalette.lightBlue
    },
    1225: {
      'name': 'Heavy snow',
      'icon': WeatherIcons.snow_wind,
      'color': ColorPalette.lightBlue
    },
    1237: {
      'name': 'Ice pellets',
      'icon': WeatherIcons.meteor,
      'color': ColorPalette.lightBlue
    },
    1240: {
      'name': 'Light rain shower',
      'icon': WeatherIcons.day_showers,
      'color': ColorPalette.lightBlue
    },
    1243: {
      'name': 'Moderate / heavy rain shower',
      'icon': WeatherIcons.showers,
      'color': ColorPalette.lightBlue
    },
    1246: {
      'name': 'Torrential rain shower',
      'icon': WeatherIcons.raindrops,
      'color': ColorPalette.lightBlue
    },
    1249: {
      'name': 'Light sleet showers',
      'icon': WeatherIcons.day_sleet,
      'color': ColorPalette.lightBlue
    },
    1252: {
      'name': 'Moderate / heavy sleet showers',
      'icon': WeatherIcons.sleet,
      'color': ColorPalette.lightBlue
    },
    1255: {
      'name': 'Light snow showers',
      'icon': WeatherIcons.day_snow_wind,
      'color': ColorPalette.lightBlue
    },
    1258: {
      'name': 'Moderate / heavy snow showers',
      'icon': WeatherIcons.snow_wind,
      'color': ColorPalette.lightBlue
    },
    1261: {
      'name': 'Light showers of ice pellets',
      'icon': WeatherIcons.meteor,
      'color': ColorPalette.lightBlue
    },
    1264: {
      'name': 'Moderate / heavy showers of ice pellets',
      'icon': WeatherIcons.meteor,
      'color': ColorPalette.lightBlue
    },
    1273: {
      'name': 'Patchy light rain with thunder',
      'icon': WeatherIcons.day_storm_showers,
      'color': ColorPalette.lightBlue
    },
    1276: {
      'name': 'Moderate / heavy rain with thunder',
      'icon': WeatherIcons.storm_showers,
      'color': ColorPalette.lightBlue
    },
    1279: {
      'name': 'Patchy light snow with thunder',
      'icon': WeatherIcons.day_snow_thunderstorm,
      'color': ColorPalette.lightBlue
    },
    1282: {
      'name': 'Moderate / heavy snow with thunder',
      'icon': WeatherIcons.thunderstorm,
      'color': ColorPalette.lightBlue
    },
  };

  const WeatherCondition(
      [this.condition = 'None',
      this.icon = Icons.close,
      this.iconColor = Colors.red]);

  factory WeatherCondition.fromCode(int code) {
    return WeatherCondition(conditionCodesMap[code]?['name'],
        conditionCodesMap[code]?['icon'], conditionCodesMap[code]?['color']);
  }

  factory WeatherCondition.fromJson(Map json, Map condition) {
    return WeatherCondition(
        condition['day_text'],
        conditionCodesMap[json['code']]?['icon'],
        conditionCodesMap[json['code']]?['color']);
  }

  @override
  List<Object?> get props => [condition];
}
