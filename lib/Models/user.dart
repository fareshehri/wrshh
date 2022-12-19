import 'package:flutter/material.dart';

class AppUser {
  late String uid;
  late String username;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String city;
  late String userType;

  AppUser(
      {
      required this.username,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.name,
      this.city = 'Al Riyadh',
      required this.userType});
}

class ClientUser extends AppUser {
  ClientUser(
      {
      required super.username,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.name,
      super.userType = 'ClientUser'});
}

class WorkshopUser extends AppUser {
  WorkshopUser(
      {
      required super.username,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.name,
      super.userType = 'WorkshopUser'});
}

class AdminUser extends AppUser {
  AdminUser(
      {
      required super.username,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.name,
      super.userType = 'AdminUser'});
}
