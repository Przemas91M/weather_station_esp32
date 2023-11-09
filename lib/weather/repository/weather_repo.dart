import "package:firebase_database/firebase_database.dart";
import "package:weather_station_esp32/weather/models/reading.dart";

class WeatherRepository {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<List<StationReading>> getReadingsOnce(String path, int limit) async {
    List<StationReading> stationReadings = [];
    final snapshot = await database.ref().child(path).limitToLast(limit).get();
    if (snapshot.exists) {
      var value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (var key in value.keys) {
        stationReadings.add(StationReading(
            batteryVoltage: value[key]['BatteryVoltage'],
            humidity: value[key]['Humidity'],
            insideTemperature: value[key]['InsideTemp'],
            lux: value[key]['Light'],
            outsideTemperature: value[key]['OutsideTemp'],
            pressure: value[key]['Pressure'],
            solarVoltage: value[key]['Pressure'],
            uvIndex: value[key]['UV'],
            timestamp: key.toString()));
      }
    } else {
      print('No data available!');
    }
    return stationReadings;
  }
}
