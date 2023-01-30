import 'package:flutter/material.dart';

class Service {
  final int id;
  late  String name;
  late  bool check;

  Service({
    required this.id,
    required this.name,
    required this.check
  });
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

List<int> capacityList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

List<int> durationList = [15, 30, 45, 60];

List subServices = [
  {'id': 0, 'value': false, 'subs': {'first': {false: 0}, 'second': {false: 0}}},
  {'id': 1, 'value': false, 'subs': {'looking': {false: 0}, 'Checking': {false: 0}}},
  {'id': 2, 'value': false, 'subs': {'Oil part1': {false: 0}, 'oil face': {false: 0}, 'testing': {false: 0}, 'note really': {false: 0}}},
  {'id': 3, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 4, 'value': false, 'subs': {'company1': {false: 0}}},
  {'id': 5, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 6, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 7, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 8, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 9, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 10, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 11, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 12, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 13, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 14, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 15, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 16, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 17, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 18, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 19, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 20, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 21, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 22, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 23, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 24, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 25, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 26, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 27, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 28, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 29, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 30, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 31, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 32, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 33, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 34, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 35, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 36, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 37, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 38, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
  {'id': 39, 'value': false, 'subs': {'company1': {false: 0}, 'company2': {false: 0}}},
];

List<Service> mainServices = [
  Service(id: 0, name: "Check up", check: false),
  Service(id: 1, name: "Oil Change", check: false),
  Service(id: 2, name: "Air Filter change", check: false),
  Service(id: 3, name: "Spark change", check: false),
  Service(id: 4, name: "Wipers change", check: false),
  Service(id: 5, name: "Battery change", check: false),
  Service(id: 6, name: "Tyre(s) change", check: false),
  Service(id: 7, name: "Radiator service and repair", check: false),
  Service(id: 8, name: "Brake service and repair", check: false),
  Service(id: 9, name: "Air Conditional Service", check: false),
  Service(id: 10, name: "Axle Assay / Axle Beam", check: false),
  Service(id: 11, name: "Bumper repair", check: false),
  Service(id: 12, name: "Clutch repair", check: false),
  Service(id: 13, name: "Compressor repair", check: false),
  Service(id: 14, name: "Clips repair", check: false),
  Service(id: 15, name: "Cushion cover / Seat cover", check: false),
  Service(id: 16, name: "Drive Shaft changing", check: false),
  Service(id: 17, name: "Electrical wiring checking & repair", check: false),
  Service(id: 18, name: "Engine repair & Overhaul service", check: false),
  Service(id: 19, name: "Fan Belt & Parts", check: false),
  Service(id: 20, name: "Gearbox maintenance", check: false),
  Service(id: 21, name: "Head Light repair", check: false),
  Service(id: 22, name: "Horn repair", check: false),
  Service(id: 23, name: "Jack Assembly", check: false),
  Service(id: 24, name: "Key / Latches and Locks", check: false),
  Service(id: 25, name: "Lamps / Fog Lamps", check: false),
  Service(id: 26, name: "Mirrors repair", check: false),
  Service(id: 27, name: "Oil Pumps", check: false),
  Service(id: 28, name: "Oil Treatment", check: false),
  Service(id: 29, name: "Overhauls", check: false),
  Service(id: 30, name: "Pumps", check: false),
  Service(id: 31, name: "Piston", check: false),
  Service(id: 32, name: "Regulator", check: false),
  Service(id: 33, name: "Power Brake", check: false),
  Service(id: 34, name: "Plates repair", check: false),
  Service(id: 35, name: "Relay repair", check: false),
  Service(id: 36, name: "Suspension service and repair", check: false),
  Service(id: 37, name: "Shock Absorber", check: false),
  Service(id: 38, name: "Speakers repair", check: false),
  Service(id: 39, name: "Valve changing & repair", check: false),
];

