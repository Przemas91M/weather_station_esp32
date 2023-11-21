import "dart:convert";

import "package:firebase_database/firebase_database.dart";
import "package:weather_station_esp32/weather/models/current_weather.dart";
import "package:weather_station_esp32/weather/models/reading.dart";
import "package:http/http.dart" as http;
import "package:weather_station_esp32/weather/models/weather_condition.dart";

import "../models/forecast.dart";

class WeatherRepository {
  String openWeatherAPI = 'api key';
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<dynamic> forecast = [];

  Stream<List<StationReading>> databaseDataChanged(String cityName, int limit) {
    return database
        .ref('/Readings/$cityName')
        .limitToLast(limit)
        .onValue
        .map((event) {
      List<StationReading> stationReadings = [];
      var value = Map<String, dynamic>.from(
          event.snapshot.value as Map<Object?, Object?>);
      for (var key in value.keys) {
        stationReadings.add(StationReading(
            batteryVoltage: value[key]['BatteryVoltage'] * 1.0,
            humidity: value[key]['Humidity'] * 1.0,
            insideTemperature: value[key]['InsideTemp'] * 1.0,
            insideTemperatureF: ((value[key]['InsideTemp'] * 1.8) + 32) * 1.0,
            lux: value[key]['Light'] * 1.0,
            outsideTemperature: value[key]['OutsideTemp'] * 1.0,
            outsideTemperatureF: ((value[key]['OutsideTemp'] * 1.8) + 32) * 1.0,
            pressure: value[key]['Pressure'] * 1.0,
            solarVoltage: value[key]['SolarVoltage'] * 1.0,
            uvIndex: value[key]['UV'] * 1.0 / 100,
            timestamp: int.parse(key)));
      }
      stationReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return stationReadings;
    });
  }

  Future<List<StationReading>> getReadingsOnce(String path, int limit) async {
    List<StationReading> stationReadings = [];
    final snapshot = await database.ref().child(path).limitToLast(limit).get();
    if (snapshot.exists) {
      var value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);

      for (var key in value.keys) {
        stationReadings.add(StationReading(
            batteryVoltage: value[key]['BatteryVoltage'] * 1.0,
            humidity: value[key]['Humidity'] * 1.0,
            insideTemperature: value[key]['InsideTemp'] * 1.0,
            insideTemperatureF: ((value[key]['InsideTemp'] * 1.8) + 32) * 1.0,
            lux: value[key]['Light'] * 1.0,
            outsideTemperature: value[key]['OutsideTemp'] * 1.0,
            outsideTemperatureF: ((value[key]['OutsideTemp'] * 1.8) + 32) * 1.0,
            pressure: value[key]['Pressure'] * 1.0,
            solarVoltage: value[key]['SolarVoltage'] * 1.0,
            uvIndex: value[key]['UV'] * 1.0 / 100,
            timestamp: int.parse(key)));
      }
      stationReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    return stationReadings;
  }

  Future<CurrentWeather> getCurrentWeather(String cityName) async {
    String url =
        'http://api.weatherapi.com/v1/forecast.json?key=$openWeatherAPI&q=$cityName&days=5&aqi=no&alerts=no';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> current =
            jsonDecode(response.body)['current'];
        forecast = jsonDecode(response.body)['forecast']['forecastday'];
        return CurrentWeather.fromJson(current);
      } else {
        throw Exception('Failed to load weather data!');
      }
    } catch (_) {
      throw Exception('Failed to load weather data!');
    }
  }

  List<Forecast> getWeatherForecast(String cityName) {
    List<Forecast> forecastList = [];
    if (forecast.isNotEmpty) {
      List<Map<String, dynamic>> hourlyTempC = [];
      List<Map<String, dynamic>> hourlyTempF = [];
      List<Map<String, dynamic>> hourlyPressure = [];
      List<Map<String, dynamic>> hourlyPrecipMM = [];
      List<Map<String, dynamic>> hourlyPrecipIN = [];
      List<Map<String, dynamic>> hourlyHumidity = [];
      for (var value in forecast) {
        for (var hourly in value['hour']) {
          hourlyTempC.add({hourly['time']: hourly['temp_c']});
          hourlyTempF.add({hourly['time']: hourly['temp_f']});
          hourlyPressure.add({hourly['time']: hourly['pressure_mb']});
          hourlyPrecipMM.add({hourly['time']: hourly['precip_mm']});
          hourlyPrecipIN.add({hourly['time']: hourly['precip_in']});
          hourlyHumidity.add({hourly['time']: hourly['humidity']});
        }
        forecastList.add(Forecast(
          date: value['date'],
          dateEpoch: value['date_epoch'],
          maxTempC: value['day']['maxtemp_c'],
          maxTempF: value['day']['maxtemp_f'],
          minTempC: value['day']['mintemp_c'],
          minTempF: value['day']['mintemp_f'],
          avgTempC: value['day']['avgtemp_c'],
          avgTempF: value['day']['avgtemp_f'],
          maxWindKph: value['day']['maxwind_kph'],
          maxWindMph: value['day']['maxwind_mph'],
          totalPrecipMM: value['day']['totalprecip_mm'],
          totalPrecipIN: value['day']['totalprecip_in'],
          avgHumidity: value['day']['avghumidity'],
          uvIndex: value['day']['uv'],
          condition:
              WeatherCondition.fromCode(value['day']['condition']['code']),
          hourlyTempC: hourlyTempC.toList(),
          hourlyTempF: hourlyTempF.toList(),
          hourlyPressure: hourlyPressure.toList(),
          hourlyPrecipMM: hourlyPrecipMM.toList(),
          hourlyPrecipIN: hourlyPrecipIN.toList(),
          hourlyHumidity: hourlyHumidity.toList(),
        ));
        hourlyTempC.clear();
        hourlyTempF.clear();
        hourlyPressure.clear();
        hourlyPrecipMM.clear();
        hourlyPrecipIN.clear();
        hourlyHumidity.clear();
      }
    }
    return forecastList;
  }
}
