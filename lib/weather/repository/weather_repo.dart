import "package:firebase_database/firebase_database.dart";

class WeatherRepository {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> getReadingsOnce(String path, int limit) async {
    final snapshot = await database.ref().child(path).limitToLast(limit).get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available!');
    }
  }
}
