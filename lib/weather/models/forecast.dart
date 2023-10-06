import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Forecast extends Equatable {
  final String date;
  final double temperature;
  final IconData icon;

  const Forecast(
      {required this.date, required this.temperature, required this.icon});

  @override
  List<Object?> get props => [date, temperature, icon];
}
