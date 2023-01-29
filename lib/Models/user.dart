import 'dart:io';

class AppUser {
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String city;
  late String userType;

  AppUser(
      {required this.email,
      required this.phoneNumber,
      required this.name,
      required this.password,
      this.city = 'Al Riyadh',
      required this.userType});


}

class ClientUser extends AppUser {
  ClientUser(
      {required super.email,
      required super.phoneNumber,
      required super.name,
      required super.password,
      super.userType = 'ClientUser'});

}

class WorkshopAdmin extends AppUser {
  WorkshopAdmin({
    required super.email,
    required super.phoneNumber,
    required super.name,
    required super.password,
    super.userType = 'WorkshopAdmin',
  });
}

class WorkshopTech extends AppUser {
  WorkshopTech({
    required super.email,
    required super.phoneNumber,
    required super.name,
    required super.password,
    super.userType = 'WorkshopTech',
  });

}

class AdminUser extends AppUser {
  AdminUser(
      {required super.email,
      required super.phoneNumber,
      required super.name,
      required super.password,
      super.userType = 'AdminUser'});

}

// class Workshop {
//   late String? uid;
//   late String name;
//   late String location;
//   late File logo;
//
//   Workshop({
//     required this.name,
//     required this.location,
//     required this.logo,
//   });
// }
