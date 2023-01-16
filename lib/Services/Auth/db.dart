import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

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

void bookAppointment(String id) {
  _firestore.collection('Appointment').doc(id).update({
    'booked': true,
  });
}

Future<List> getBookedAppointmentsFromDB(String email) async {
  List appointments = [];
  print('email: $email');
  final Appointmentss = await _firestore.collection('Appointment').get();
  for (var appointment in Appointmentss.docs) {
    if (appointment.data()['booked'] == true) {
      appointments.add(appointment);
    }
  }
  // _firestore.collection('Appointment').where('clientID', isEqualTo: email).get().then((value) {
  //   value.docs.forEach((element) {
  //     appointments.add(element);
  //   });
  // });

  print('appointments: $appointments');
  return appointments;
}

//

Future<void> updateWorkingHours(TimeRangeResult R) async {
  final user = _auth.currentUser;
  List hours = [R.start.hour, R.start.minute, R.end.hour, R.end.minute];
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'workingHours': hours
  });
}
Future<TimeRangeResult> getWorkingHours() async {
  final user = _auth.currentUser;
  final time = await _firestore.collection('workshops').doc(user?.email).get();
  List hours = time['workingHours'];

  TimeRangeResult timeRange = TimeRangeResult(
      TimeOfDay(hour: hours[0], minute: hours[1]),
      TimeOfDay(hour: hours[2], minute: hours[3])
  );

  return timeRange;
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

Future<void> updateServices(List services, List prices) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'ser': services,
    'pri': prices
  });
}
Future<DocumentSnapshot<Map<String, dynamic>>> getServices() async {
  final user = _auth.currentUser;
  final ser = await _firestore.collection('workshops').doc(user?.email).get();
  return ser;

}

Future<void> updateBreakDates(List<DateTime> breakDates) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = _auth.currentUser;
  List tem = [];
  for (int i=0; i < breakDates.length; i++) {
    tem.add(breakDates[i].millisecondsSinceEpoch);
  }
  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'breakDates': tem
  });
}
Future<List<dynamic>> getBreakDates() async {
  final user = _auth.currentUser;
  final time = await _firestore.collection('workshops').doc(user?.email).get();
  return time['breakDates'] as List<dynamic>;
}

Future<void> updateBreakHours(List<DateTime> breakHours) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = _auth.currentUser;
  List tem = [];
  for (int i=0; i < breakHours.length; i++) {
    tem.add(breakHours[i].millisecondsSinceEpoch);
  }

  FirebaseFirestore.instance.collection('workshops').doc(user?.email).update({
    'breakHours': tem
  });
}
Future<List> getBreakHours() async {
  final user = _auth.currentUser;
  final time = await _firestore.collection('workshops').doc(user?.email).get();
  return time['breakHours'];
}
