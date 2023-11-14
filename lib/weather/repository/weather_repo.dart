import "dart:convert";

import "package:firebase_database/firebase_database.dart";
import "package:weather_station_esp32/weather/models/reading.dart";
import "package:http/http.dart" as http;

class WeatherRepository {
  String openWeatherAPI = 'eb4f9d0a14c5403fba4202400231411';
  FirebaseDatabase database = FirebaseDatabase.instance;

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
            lux: value[key]['Light'] * 1.0,
            outsideTemperature: value[key]['OutsideTemp'] * 1.0,
            pressure: value[key]['Pressure'] * 1.0,
            solarVoltage: value[key]['SolarVoltage'] * 1.0,
            uvIndex: value[key]['UV'] * 1.0 / 100,
            timestamp: int.parse(key)));
      }
      stationReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    return stationReadings;
  }

  Future<void> getCurrentWeather(String cityName) async {
    String url =
        'http://api.weatherapi.com/v1/current.json?key=$openWeatherAPI&q=$cityName&aqi=no';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        print(decodedJson);
        //TODO map decoded information to weather forecast model and return it to the caller!
      } else {
        throw Exception('Failed to load weather data!');
      }
    } catch (_) {
      throw Exception('Failed to load weather data!');
    }
  }
}
