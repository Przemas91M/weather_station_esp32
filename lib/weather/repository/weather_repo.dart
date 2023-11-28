import "dart:async";
import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_database/firebase_database.dart";
import "package:http/http.dart" as http;
import "package:weather_station_esp32/locations_management/models/location.dart";
import "package:weather_station_esp32/weather/models/models.dart";

class WeatherRepository {
  String openWeatherAPI = 'eb4f9d0a14c5403fba4202400231411';
  FirebaseDatabase stationDatabase = FirebaseDatabase.instance;
  FirebaseFirestore firestoreDatabase = FirebaseFirestore.instance;
  List<dynamic> forecast = [];

  Stream<List<StationReading>> databaseDataChanged(String cityName, int limit) {
    return stationDatabase
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
    final snapshot = await stationDatabase
        .ref('/Readings')
        .child(path)
        .limitToLast(limit)
        .get();
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
        'http://api.weatherapi.com/v1/forecast.json?key=$openWeatherAPI&q=$cityName&days=8&aqi=no&alerts=no';
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

  Future<List<Map<String, dynamic>>> getStationsLocation() async {
    List<Map<String, dynamic>> stations = [];
    await firestoreDatabase
        .collection('stationLocations')
        .get()
        .then((querysnapshot) {
      for (var item in querysnapshot.docs) {
        stations.add(item.data());
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
    return stations;
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

  Future<List<dynamic>> getUserSavedData(String uid) async {
    return firestoreDatabase
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }
      return data['cities'] as List<dynamic>;
    }).onError((error, stackTrace) {
      print(error.toString());
      return [];
    });
  }

  Future<List<Location>> getUserSavedLocations(String uid) async {
    List<Location> locations = [];
    List<dynamic> userData = await getUserSavedData(uid);
    List<Map<String, dynamic>> stations = await getStationsLocation();
    for (var data in userData) {
      for (var station in stations) {
        if (data['name'] == station['name'] &&
            data['country'] == station['country']) {
          locations.add(Location.fromJson(data, true));
        } else {
          locations.add(Location.fromJson(data, false));
        }
      }
    }
    return locations;
  }

  Future<bool> saveUserSavedLocations(
      String uid, List<Location> locations) async {
    List<Map<String, dynamic>> cities = [];
    for (Location loc in locations) {
      cities.add({'name': loc.name, 'country': loc.country, 'url': loc.url});
    }
    await firestoreDatabase
        .collection('users')
        .doc(uid)
        .set({'cities': cities}).onError((error, stackTrace) {
      print(error.toString());
      return false;
    });
    return true;
  }

  Future<List<Location>> locationFinder(String query) async {
    String url =
        'http://api.weatherapi.com/v1/search.json?key=$openWeatherAPI&q=$query';
    try {
      List<Map<String, dynamic>> stations = await getStationsLocation();
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Location> foundLocations = [];
        final List<dynamic> data = jsonDecode(response.body);
        for (var item in data) {
          for (var station in stations) {
            if (item['name'] == station['name'] &&
                item['country'] == station['country']) {
              foundLocations.add(Location.fromJson(item, true));
            } else {
              foundLocations.add(Location.fromJson(item, false));
            }
          }
        }
        return foundLocations;
      } else {
        throw Exception('Failed to load location suggestion');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
