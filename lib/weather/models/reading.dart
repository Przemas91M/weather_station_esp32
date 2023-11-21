import 'package:equatable/equatable.dart';

class StationReading extends Equatable {
  final double batteryVoltage;
  final double humidity;
  final double insideTemperature;
  final double insideTemperatureF;
  final double lux;
  final double outsideTemperature;
  final double outsideTemperatureF;
  final double pressure;
  final double solarVoltage;
  final double uvIndex;
  final int timestamp;

  const StationReading(
      {required this.batteryVoltage,
      required this.humidity,
      required this.insideTemperature,
      required this.insideTemperatureF,
      required this.lux,
      required this.outsideTemperature,
      required this.outsideTemperatureF,
      required this.pressure,
      required this.solarVoltage,
      required this.uvIndex,
      required this.timestamp});

  @override
  List<Object?> get props => [
        batteryVoltage,
        humidity,
        insideTemperature,
        insideTemperatureF,
        lux,
        outsideTemperature,
        outsideTemperatureF,
        pressure,
        solarVoltage,
        timestamp,
        uvIndex
      ];
}
