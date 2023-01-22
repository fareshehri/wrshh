import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
//
// // add cars to the database
// Future<void> addCar(String carName, String carModel, String carYear, String carColor, String carPlate, String carType, String carImage, String carPrice, String carDescription, String carOwner) async {
//   await _firestore.collection('cars').doc(vin).add({
//     'carName': carName,
//     'carModel': carModel,
//     'carYear': carYear,
//     'carColor': carColor,
//     'carPlate': carPlate,
//     'carType': carType,
//     'carImage': carImage,
//     'carPrice': carPrice,
//     'carDescription': carDescription,
//     'carOwner': carOwner,
//   });
//
//
// }
//
// // retive woskshops data from the database
// Future<void> getWorkshops() async {
//   final workshops = await _firestore.collection('workshops').get();
//   for (var workshop in workshops.docs) {
//     print(workshop.data());
//   }
// }
//

// retrieve appointments from firestore where adminEmail == email
Future<List> getAppointmentsFromDB(String email) async {
  List appointments = [];
  _firestore
      .collection('Appointment')
      .where('workshopID', isEqualTo: email)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      appointments.add(element);
    });
  });
  return appointments;
}

// final appointmentsDB = await _firestore.collection('Appointments').where('workshopID', isEqualTo: email).get();
//
// print('appointmentsDB: $appointmentsDB.docs');
// var count = 0;
// for (var appointment in appointmentsDB.docs) {
//   count++;
//   appointments.add(appointment.data());
//   print('appointments: $appointments');
// }
// print('count: $count');
// print('appointments: $appointments');
// return appointments;
// }





// get workshop name from firestore where workshopID == workshopID
Future<String> getWorkshopNameFromDB(String workshopID) async {
  String workshopName = '';
  await _firestore
      .collection('workshops')
      .doc(workshopID)
      .get()
      .then((value) => workshopName = value.data()!['workshopName']);
  return workshopName;
}


void bookAppointment(String id) {
  _firestore.collection('Appointment').doc(id).update({
    'booked': true,
  });
}

Future<Map> getBookedAppointmentsFromDB(String email) async {
  Map appointments = {};
  final Appointmentss = await _firestore.collection('Appointment').get();
  for (var appointment in Appointmentss.docs) {
    if (appointment.data()['booked'] == true) {
      var workshopName = await getWorkshopNameFromDB(appointment.data()['workshopID']);
      // if workshopName is not in appointments.keys add it
      if (!appointments.keys.contains(workshopName)) {
        appointments[workshopName] = [];
      }
      // add the appointment to the list of appointments
      appointments[workshopName].add(appointment.data());
    }
  }
  print('appointments: $appointments');
  return appointments;
}


void addAppointmentsTable(TimeOfDay startTime, TimeOfDay endTime, int capacity, List dates) {
  final user = _auth.currentUser;

  for (int i=0; i < dates.length; i++) { /// Go over selected days
    for (int j=0; j <= capacity; j++) { /// Repeat addition for capacity size
      dates[i] = DateTime(dates[i].year, dates[i].month, dates[i].day, startTime.hour, startTime.minute);
      // dates[i].withMinute(startTime.minute);
      // print(dates[i].runtimeType);
      Map<String,dynamic> wp={
        'workshopID': user?.email,
        'booked': false,
        'datetime': dates[i]
      };
      FirebaseFirestore.instance.collection('Appointment').add(wp);
    }
  }
}


Future<LinkedHashMap<String,dynamic>> getDatesHours() async {
  final user = _auth.currentUser;
  final time = await _firestore.collection('workshops').doc(user?.email).get();
  var hours = time['Hours'];

  return hours;

}
Future<void> updateDatesHours(LinkedHashMap<String,dynamic> datesHours) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'Hours': datesHours
  });
}

Future<void> updateCapacity(int c) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'capacity': c
  });
}
Future<int> getCapacity() async {
  final user = _auth.currentUser;
  final cap = await _firestore.collection('workshops').doc(user?.email).get();
  return cap['capacity'] as int;
}

Future<void> updateServices(LinkedHashMap<String,dynamic> services) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'services': services
  });
}
Future<LinkedHashMap<String,dynamic>> getServices() async {

  final user = _auth.currentUser;
  final time = await _firestore.collection('workshops').doc(user?.email).get();
  var services = time['services'];
  // print(services.runtimeType);
  // print(services['price'][0]);

  return services;

}

