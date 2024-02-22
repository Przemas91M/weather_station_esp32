import "dart:async";
import "dart:convert";
import "dart:ui";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:weather_station_esp32/locations_management/models/location.dart";
import "package:weather_station_esp32/weather/models/models.dart";

/// Bloc Repository to handle Firebase and WeatherApi communication
///
/// Uses [User] object to retrieve or store user saved locations.
/// Readings from stations are streamed from [FirebaseDatabase] reference.
/// User data such as name or saved location are stored in [FirebaseFirestore]
/// To translate weather condition app language object [Locale] is necessary.
class WeatherRepository {
  /// Stores user data provided from AppBloc.
  final User user;

  /// API key for WeatherApi.
  String openWeatherAPI = 'eb4f9d0a14c5403fba4202400231411';

  /// Reference to Firebase Realtime Database containing readings from all weather stations.
  FirebaseDatabase stationDatabase = FirebaseDatabase.instance;

  /// Reference to Firebase Firestore Database containing user saved data.
  FirebaseFirestore firestoreDatabase = FirebaseFirestore.instance;

  /// Stores multilingual weather condition translations loaded by [getConditionsTranslationsFromJson].
  List<Map<String, dynamic>> conditionsTranslations = [];

  /// App language provided by AppBloc.
  final Locale appLanguage;

  /// Stores forecast data loaded by [getCurrentWeather].
  List<dynamic> forecast = [];

  WeatherRepository({required this.user, required this.appLanguage}) {
    getConditionsTranslationsFromJson(); //get big json data once and read from it when needed
  }

  /// Map [limit] readings from station at [cityName] to [StationReading] object.
  ///
  /// This method is called everytime when a station uploads new data to firebase.
  /// All reading values are mapped to a new [StationReading] object, then added to list.
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

  //consider deleting this method!
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

  /// Requests current weather and weather forecast from WeatherApi in [cityName].
  ///
  /// Response from API contains current weather and weather forecast, which is separated into two variables.
  /// Forecast is stored in global variable [forecast].
  /// Current weather is returned as a [CurrentWeather] object.
  Future<CurrentWeather> getCurrentWeather(String cityName) async {
    String url =
        'http://api.weatherapi.com/v1/forecast.json?key=$openWeatherAPI&q=$cityName&days=8&aqi=no&alerts=no&lang=${appLanguage.languageCode}';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> current =
            jsonDecode(response.body)['current'];
        forecast = jsonDecode(response.body)['forecast']['forecastday'];
        return CurrentWeather.fromJson(current,
            getConditionTranslationFromCode(current['condition']['code']));
      } else {
        throw Exception('Failed to load weather data!');
      }
    } catch (_) {
      throw Exception('Failed to load weather data!');
    }
  }

  /// Fetches all installed physical stations information, such as location from Firebase.
  /// Returns a list of Maps contatining downloaded data.
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
      print(error.toString()); //TODO add error handling
    });
    return stations;
  }

  /// Takes [forecast] data from global variable, fetched by [getCurrentWeather]
  /// and maps selected parameters to a [Forecast] object list.
  /// Each list entry is a single day forecast.
  List<Forecast> getWeatherForecast() {
    List<Forecast> forecastList = [];
    if (forecast.isNotEmpty) {
      //lists containing forecast data for each hour
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
          avgHumidity: value['day']['avghumidity'] * 1.0,
          uvIndex: value['day']['uv'],
          condition: WeatherCondition.fromJson(
              value['day']['condition'],
              getConditionTranslationFromCode(
                  value['day']['condition']['code'])),
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

  /// Fetches raw user saved cities from Firestore Database.
  /// Uses [User] object to get current user saved data.
  Future<List<dynamic>> getUserSavedData() async {
    return firestoreDatabase
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }
      return data['cities'] as List<dynamic>;
    }).onError((error, stackTrace) {
      print(error.toString()); //TODO implement error handling
      return [];
    });
  }

  /// Uses data fetched by [getUserSavedData]
  /// and maps selected values to a [Location] object list.
  /// Also checks whether location has a weather station installed.
  Future<List<Location>> getUserSavedLocations() async {
    List<Location> locations = [];
    List<dynamic> userData = await getUserSavedData();
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

  ///Takes a list of [locations] and saves it to current [user] Firebase Firestore.
  ///User can bookmark a location to track it's current weather and forecast.
  //TODO implement error handling and remove bool return value
  Future<bool> saveUserSavedLocations(List<Location> locations) async {
    List<Map<String, dynamic>> cities = [];
    for (Location loc in locations) {
      cities.add({'name': loc.name, 'country': loc.country, 'url': loc.url});
    }
    await firestoreDatabase
        .collection('users')
        .doc(user.uid)
        .set({'cities': cities}).onError((error, stackTrace) {
      print(error.toString()); //TODO implement error handling
      return false;
    });
    return true;
  }

  /// Finds a city by a provided name [query].
  ///
  /// Used to find and bookmark new city for user to check it's weather.
  /// Sends a request to WeatherAPI to return a list of cities matching [query].
  /// This list is mapped to a [Location] object list.
  /// Also checks wheter found locations have a weather station installed.
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

  /// Loads a multilingual condition list in JSON format to [conditionsTranslations] map list.
  /// This file is stored in assets folder.
  /// Contains a short weather description based on a code in multiple languages.
  /// Condition description returned from WeatherAPI response fields doesn't
  /// support special characters in some languages.
  Future<void> getConditionsTranslationsFromJson() async {
    conditionsTranslations = await rootBundle
        .loadString('assets/conditions.json')
        .then((value) => (jsonDecode(value) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList());
  }

  /// Returns weather description translated to app language taken from [Locale]
  /// object and based on a [code].
  /// Description is filtered from [conditionsTranslations] map list.
  Map<String, dynamic> getConditionTranslationFromCode(int code) {
    return (conditionsTranslations
                .firstWhere((element) => element['code'] == code)['languages']
            as List) //fist get specific description from code
        .firstWhere((element) =>
            element['lang_iso'] ==
            appLanguage
                .languageCode); //then get translation based on app language
  }
}
