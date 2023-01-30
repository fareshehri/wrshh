import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Pages/workshopAdmin/schedule_data.dart';

final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> addAppointmentsTable(
    int capacity,
    Map<String, DateTime> selectedDates,
    LinkedHashMap<String, dynamic> datesHours, int duration) async {
  final user = _auth.currentUser;
  // LinkedHashMap<String, dynamic> services = {
  //   'service': [],
  //   'price': [],
  // } as LinkedHashMap<String, dynamic>;

  try {
    for (var key in datesHours.keys) {
      for (var isin in selectedDates.keys) {
        for (var day in days) {
          if (datesHours[day][0] && isin == key) {
            DateTime? dateTimeTemp = selectedDates[isin];
            Map<String, dynamic> wp = {
              'workshopID': user?.uid,
              'serial': '',
              'clientID': '',
              'status': 'available',
              'services': [],
              'price': 0,
              'datetime': dateTimeTemp,
              'rate': 0,
              'reportURL': '',
              // update this
              'odometer': '',
            };
            for (int c = 0; c < capacity; c++) {
              FirebaseFirestore.instance
                  .collection('Appointments')
                  .doc()
                  .set(wp);
            }
            break;
          }
        }
      }
    }
  } catch (e) {
    print('THIS IS THE ERROR: $e');
  }
}

Future<void> handleAppointmentsInDB() async {
  final user = _auth.currentUser;
  Query query = _firestore
      .collection("Appointments")
      .where("workshopID", isEqualTo: user?.uid);

  query.get().then((querySnapshot) {
    for (var document in querySnapshot.docs) {
      if (!document.metadata.hasPendingWrites) {
        document.reference.delete();
      }
    }
  });
}

Future<LinkedHashMap<String, dynamic>> getDatesHours() async {
  final user = _auth.currentUser;
  print('THIS IS THE USER: $user');
  final time = await _firestore.collection('workshops').doc(user?.uid).get();
  var hours = time['Hours'];

  return hours;
}

Future<void> updateDatesHours(LinkedHashMap<String, dynamic> datesHours) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance
      .collection('workshops')
      .doc(user?.uid)
      .update({'Hours': datesHours});
}

Future<void> updateCapacity(int c) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance
      .collection('workshops')
      .doc(user?.uid)
      .update({'capacity': c});
}

Future<int> getCapacity() async {
  final user = _auth.currentUser;
  print('THIS IS THE USER: ${user?.uid}');
  final cap = await _firestore.collection('workshops').doc(user?.uid).get();
  return cap['capacity'] as int;
}

Future<String> getWorkshopNameFromDB(String workshopID) async {
  String workshopName = '';
  await _firestore
      .collection('workshops')
      .doc(workshopID)
      .get()
      .then((value) => workshopName = value.data()!['workshopName']);
  return workshopName;
}

// Future<Map> getBookedAppointmentsFromDB(String email) async {
//   Map appointments = {};
//   final Appointmentss = await _firestore.collection('Appointment').get();
//   for (var appointment in Appointmentss.docs) {
//     if (appointment.data()['booked'] == true) {
//       var workshopName =
//       await getWorkshopNameFromDB(appointment.data()['workshopID']);
//       if (!appointments.keys.contains(workshopName)) {
//         appointments[workshopName] = [];
//       }
//       appointments[workshopName].add(appointment.data());
//     }
//   }
//   return appointments;
// }

getWorkshopAppointmentsByDate(DateTime date) async {
  Map appointments = {};
  final AppointmentsDB = await _firestore
      .collection('Appointments')
      .where('workshopID', isEqualTo: _auth.currentUser!.uid)
      .get();
  for (var appointment in AppointmentsDB.docs) {
    var appointmentDate = appointment.data()['datetime'].toDate();
    if (appointmentDate.year == date.year &&
        appointmentDate.month == date.month &&
        appointmentDate.day == date.day) {
      var workshopName =
          await getWorkshopNameFromDB(appointment.data()['workshopID']);
      // if workshopName is not in appointments.keys add it
      if (!appointments.keys.contains(workshopName)) {
        appointments[workshopName] = [];
      }
      // add the appointment to the list of appointments
      appointments[workshopName].add(appointment);
    }
  }
  return appointments;
}

getWorkshopFinishedAppointments() async {
  Map appointments = {};
  final AppointmentsDB = await _firestore
      .collection('Appointments')
      .where('workshopID', isEqualTo: _auth.currentUser!.uid)
      .where('status', isEqualTo: 'finished')
      .get();
  var workshopName = await getWorkshopNameFromDB(
      AppointmentsDB.docs.first.data()['workshopID']);
  for (var appointment in AppointmentsDB.docs) {
// if workshopName is not in appointments.keys add it
    if (!appointments.keys.contains(workshopName)) {
      appointments[workshopName] = [];
    }
// add the appointment to the list of appointments
    appointments[workshopName].add(appointment);
  }
  return appointments;
}


// get workshop from workshopID
Future<String> getAdminEmailfromDB(String workshopID) async {
  final workshopDB = await _firestore.collection('workshops').doc().get();
  var email = workshopDB.data()!['adminEmail'];
  return email;
}
