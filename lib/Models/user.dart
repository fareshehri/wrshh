import 'package:flutter/material.dart';

class AppUser {
  late String uid;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String city;
  late String userType;

  AppUser(
      {required this.email,
      required this.password,
      required this.phoneNumber,
      required this.name,
      this.city = 'Al Riyadh',
      required this.userType});
}

class ClientUser extends AppUser {
  ClientUser(
      {required super.email,
      required super.password,
      required super.phoneNumber,
      required super.name,
      super.userType = 'ClientUser'});
}

class WorkshopUser extends AppUser {
  WorkshopUser({
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.name,
    super.userType = 'WorkshopUser',
  });
}

class AdminUser extends AppUser {
  AdminUser(
      {required super.email,
      required super.password,
      required super.phoneNumber,
      required super.name,
      super.userType = 'AdminUser'});
}

class Workshop {
  late String? uid;
  late String name;
  late String location;

  Workshop({
    required this.uid,
    required this.name,
    required this.location,
  });
}
