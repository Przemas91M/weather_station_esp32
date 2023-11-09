import 'package:equatable/equatable.dart';

class StationReading extends Equatable {
  final double batteryVoltage;
  final double humidity;
  final double insideTemperature;
  final double lux;
  final double outsideTemperature;
  final double pressure;
  final double solarVoltage;
  final double uvIndex;
  final int timestamp;

  const StationReading(
      {required this.batteryVoltage,
      required this.humidity,
      required this.insideTemperature,
      required this.lux,
      required this.outsideTemperature,
      required this.pressure,
      required this.solarVoltage,
      required this.uvIndex,
      required this.timestamp});

  @override
  List<Object?> get props => [
        batteryVoltage,
        humidity,
        insideTemperature,
        lux,
        outsideTemperature,
        pressure,
        solarVoltage,
        timestamp,
        uvIndex
      ];
}
