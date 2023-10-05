import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Forecast extends Equatable {
  final String date;
  final String temperature;
  final Icon icon;

  const Forecast(
      {required this.date, required this.temperature, required this.icon});

  @override
  List<Object?> get props => [date, temperature, icon];
}
