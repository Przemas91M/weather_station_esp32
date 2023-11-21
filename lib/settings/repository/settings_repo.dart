import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  late bool darkTheme;
  late bool kilometers;
  late bool celsius;
  late bool milimeters;
  late List<String> cities;
  bool _readingDone = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> readAllSettings() async {
    try {
      SharedPreferences prefs = await _prefs;
      celsius = prefs.getBool('celsius') ?? true;
      darkTheme = prefs.getBool('theme') ?? false;
      kilometers = prefs.getBool('kilometers') ?? true;
      milimeters = prefs.getBool('milimeters') ?? true;
      cities = prefs.getStringList('cities') ?? ['Koszalin'];
      _readingDone = true;
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> getAllSettings() {
    Map<String, dynamic> settings = {};
    if (_readingDone) {
      settings = {
        'celsius': celsius,
        'darkTheme': darkTheme,
        'kilometers': kilometers,
        'milimeters': milimeters,
        'cities': cities,
      };
    }
    return settings;
  }

  Future<void> addCity(String city) async {
    final prefs = await _prefs;
    cities.add(city);
    prefs.setStringList('cities', cities);
  }

  Future<bool> removeCity(String city) async {
    final prefs = await _prefs;
    final bool success = cities.remove('city');
    if (success) {
      prefs.setStringList('cities', cities);
    }
    return success;
  }

  Future<void> setPrecipUnit(bool setting) async {
    final prefs = await _prefs;
    prefs.setBool('milimeters', setting);
    milimeters = setting;
  }

  Future<void> setTemperatureUnit(bool setting) async {
    final prefs = await _prefs;
    prefs.setBool('celsius', setting);
    celsius = setting;
  }

  Future<void> setTheme(bool setting) async {
    final prefs = await _prefs;
    prefs.setBool('theme', setting);
    darkTheme = setting;
  }

  Future<void> setWindSpeedUnit(bool setting) async {
    final prefs = await _prefs;
    prefs.setBool('kilometers', setting);
    kilometers = setting;
  }

  //get settings on start of the app, use these settings on startup
  //theme, units of measure, cities to forecast, remember user
}
