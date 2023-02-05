import 'package:flutter/material.dart';

class Service {
  final int id;
  late String name;
  late bool check;

  Service({required this.id, required this.name, required this.check});
}

List<TimeOfDay> timeRange = [
  const TimeOfDay(hour: 0, minute: 0),
  const TimeOfDay(hour: 0, minute: 30),
  const TimeOfDay(hour: 1, minute: 0),
  const TimeOfDay(hour: 1, minute: 30),
  const TimeOfDay(hour: 2, minute: 0),
  const TimeOfDay(hour: 2, minute: 30),
  const TimeOfDay(hour: 3, minute: 0),
  const TimeOfDay(hour: 3, minute: 30),
  const TimeOfDay(hour: 4, minute: 0),
  const TimeOfDay(hour: 4, minute: 30),
  const TimeOfDay(hour: 5, minute: 0),
  const TimeOfDay(hour: 5, minute: 30),
  const TimeOfDay(hour: 6, minute: 0),
  const TimeOfDay(hour: 6, minute: 30),
  const TimeOfDay(hour: 7, minute: 0),
  const TimeOfDay(hour: 7, minute: 30),
  const TimeOfDay(hour: 8, minute: 0),
  const TimeOfDay(hour: 8, minute: 30),
  const TimeOfDay(hour: 9, minute: 0),
  const TimeOfDay(hour: 9, minute: 30),
  const TimeOfDay(hour: 10, minute: 0),
  const TimeOfDay(hour: 10, minute: 30),
  const TimeOfDay(hour: 11, minute: 0),
  const TimeOfDay(hour: 11, minute: 30),
  const TimeOfDay(hour: 12, minute: 0),
  const TimeOfDay(hour: 12, minute: 30),
  const TimeOfDay(hour: 13, minute: 0),
  const TimeOfDay(hour: 13, minute: 30),
  const TimeOfDay(hour: 14, minute: 0),
  const TimeOfDay(hour: 14, minute: 30),
  const TimeOfDay(hour: 15, minute: 0),
  const TimeOfDay(hour: 15, minute: 30),
  const TimeOfDay(hour: 16, minute: 0),
  const TimeOfDay(hour: 16, minute: 30),
  const TimeOfDay(hour: 17, minute: 0),
  const TimeOfDay(hour: 17, minute: 30),
  const TimeOfDay(hour: 18, minute: 0),
  const TimeOfDay(hour: 18, minute: 30),
  const TimeOfDay(hour: 19, minute: 0),
  const TimeOfDay(hour: 19, minute: 30),
  const TimeOfDay(hour: 20, minute: 0),
  const TimeOfDay(hour: 20, minute: 30),
  const TimeOfDay(hour: 21, minute: 0),
  const TimeOfDay(hour: 21, minute: 30),
  const TimeOfDay(hour: 22, minute: 0),
  const TimeOfDay(hour: 22, minute: 30),
  const TimeOfDay(hour: 23, minute: 0),
  const TimeOfDay(hour: 23, minute: 30),
];

List<String> days = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday'
];

List<int> capacityList = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20
];

List<int> durationList = [15, 30, 45, 60];
