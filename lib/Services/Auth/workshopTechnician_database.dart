import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> addAppointmentsTable(
    int capacity,
    Map<String, DateTime> selectedDates,
    LinkedHashMap<String, dynamic> datesHours,
    int duration) async {
  final user = _auth.currentUser;
  try {
    for (var day in datesHours.keys) {
      if (datesHours[day][0] && selectedDates[day] != null) {
        DateTime startTime = selectedDates[day] as DateTime;
        DateTime endTime = DateTime(startTime.year, startTime.month,
            startTime.day, datesHours[day][3], datesHours[day][4]);
        var endTimeF = DateFormat('yyyy-MM-dd hh:mm').parse(endTime.toString());
        DateTime appEndTime = startTime.add(Duration(minutes: duration));
        var appEndTimeF =
            DateFormat('yyyy-MM-dd hh:mm').parse(appEndTime.toString());
        while (startTime.isBefore(endTimeF) ||
            startTime.isAtSameMomentAs(endTimeF)) {
          for (int c = 0; c < capacity; c++) {
            Map<String, dynamic> wp = {
              'workshopID': user?.uid,
              'serial': '',
              'clientID': '',
              'status': 'available',
              'paid': false,
              'services': [],
              'price': 0,
              'datetime': startTime,
              'rate': 0,
              'reportURL': '',
              'odometer': '',
            };
            FirebaseFirestore.instance.collection('Appointments').doc().set(wp);
          }
          startTime = appEndTime;
          appEndTime = appEndTime.add(Duration(minutes: duration));
          appEndTimeF =
              DateFormat('yyyy-MM-dd hh:mm').parse(appEndTime.toString());
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
      .where('status', whereIn: ['finished', 'booked']).get();

  if (AppointmentsDB.size == 0) {
    return appointments;
  }
  var workshopName = await getWorkshopNameFromDB(
      AppointmentsDB.docs.first.data()['workshopID']);
  var dateFormat = DateFormat('yyyy-MM-dd');
  var today = dateFormat.format(DateTime.now());
  var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1)));
  var tomorrow = dateFormat.format(DateTime.now().add(Duration(days: 1)));

  for (var appointment in AppointmentsDB.docs) {
    var appointmentDate =
        dateFormat.format(appointment.data()['datetime'].toDate());
    if (appointmentDate == today ||
        appointmentDate == yesterday ||
        appointmentDate == tomorrow) {
      if (!appointments.keys.contains(workshopName)) {
        appointments[workshopName] = [];
      }
      appointments[workshopName].add(appointment);
    }
  }
  return appointments;
}

// get workshop from workshopID
Future<String> getAdminEmailfromDB(String workshopID) async {
  final workshopDB = await _firestore.collection('workshops').doc().get();
  var email = workshopDB.data()!['adminEmail'];
  return email;
}

Future<bool> checkReportStatus(String appointmentID) async {
  final appointmentDB =
      await _firestore.collection('Appointments').doc(appointmentID).get();
  var reportURL = appointmentDB.data()!['reportURL'];
  return reportURL != '';
}

Future<bool> checkRateStatus(String appointmentID) async {
  final appointmentDB =
      await _firestore.collection('Appointments').doc(appointmentID).get();
  var rate = appointmentDB.data()!['rate'];
  return rate != 0;
}

// change this
Future<bool> checkPaymentStatus(String appointmentID) async {
  final appointmentDB =
      await _firestore.collection('Appointments').doc(appointmentID).get();
  var payment = appointmentDB.data()!['payment'];
  return payment != 0;
}
