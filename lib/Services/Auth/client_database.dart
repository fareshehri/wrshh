import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String> updateUserEmail(String email, Map data) async {
  String result = 'success';
  try {
    await _auth.currentUser!.updateEmail(email);
    _firestore.collection('clients').doc(data['email']).delete();
    _firestore.collection('clients').doc(email).set({
      'email': email.toLowerCase(),
      'name': data['name'],
      'phoneNumber': data['phoneNumber'],
      'city': data['city'],
      'serial': data['serial'],
    });
  } catch (e) {
    result = e.toString();
  }
  try {
    await _firestore
        .collection('Appointments')
        .where('clientID', isEqualTo: data['email'].toLowerCase())
        .get()
        .then((value) {
      for (var element in value.docs) {
        _firestore.collection('Appointments').doc(element.id).update({
          'clientID': email.toLowerCase(),
        });
      }
    });
  } catch (e) {
    //
  }
  return result;
}

Future<String> updateUserInfo(Map userData) async {
  String result = 'success';
  try {
    await _firestore.collection('clients').doc(userData['email'].toLowerCase()).update(
      {
        'name': userData['name'],
        'phoneNumber': userData['phoneNumber'],
      },
    );
  } catch (e) {
    result = e.toString();
  }
  return result;
}

Future<String> updateUserPassword(String password) async {
  String result = 'success';
  try {
    await _auth.currentUser!.updatePassword(password);
  } catch (e) {
    result = e.toString();
  }
  return result;
}

getClientInfo(String email) async {
  return await _firestore.collection('clients').doc(email.toLowerCase()).get();
}

Future<Map<String, dynamic>> getWorkshopsFromDB() async {
  Map<String, dynamic> workshopsData = {};
  final workshops = await _firestore.collection('workshops').get();
  for (var workshop in workshops.docs) {
    workshopsData[workshop.id] = workshop.data();
  }
  return workshopsData;
}

Future<List> getAppointmentsFromDB(String workshopID) async {
  List appointments = [];
  await _firestore
      .collection('Appointments')
      .where('workshopID', isEqualTo: workshopID)
      .get()
      .then((value) {
    for (var element in value.docs) {
      appointments.add(element);
    }
  });

  return appointments;
}

Future<Map<String, dynamic>?> getUserInfo() async {
  var user = _auth.currentUser;
  var userInfo = await _firestore.collection('clients').doc(user!.email?.toLowerCase()).get();
  return userInfo.data();
}

Future<String> getSerial() async {
  var user = _auth.currentUser;
  var userInfo = await _firestore.collection('clients').doc(user!.email?.toLowerCase()).get();
  var serial = userInfo.data()!['serial'];
  return serial;
}

Future<Map<String, dynamic>?> getCarInfoBySerial(String serial) async {
  var carInfo = await _firestore.collection('serial').doc(serial).get();
  return carInfo.data();
}

Future<String> getSerialFromUserId(String? userID) async {
  String serial = '';
  await _firestore
      .collection('clients')
      .doc(userID)
      .get()
      .then((value) => serial = value.data()!['serial']);
  return serial;
}

void bookAppointment(String id, List selectedServices) async {
  var serial = await getSerialFromUserId(_auth.currentUser!.email?.toLowerCase());
  _firestore.collection('Appointments').doc(id).update({
    'clientID': _auth.currentUser!.email,
    'serial': serial,
    'status': 'booked',
    'services': selectedServices,
  });
}

void rateAppointment(
    String appointmentID, String workshopID, double rating) async {
  _firestore.collection('Appointments').doc(appointmentID).update({
    'rate': rating,
  });
  var workshop = await _firestore.collection('workshops').doc(workshopID).get();
  var oldRate = workshop['overallRate'] as num;
  var oldNumberOfRates = workshop['numberOfRates'] as int;
  var newRate = (oldRate * oldNumberOfRates + rating) / (oldNumberOfRates + 1);
  _firestore.collection('workshops').doc(workshopID).update({
    'overallRate': newRate,
    'numberOfRates': oldNumberOfRates + 1,
  });
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

Future<Map> getUserAppointmentsFromDB() async {
  final User? user = _auth.currentUser;
  Map appointments = {};
  final appointmentsS = await _firestore
      .collection('Appointments')
      .where('clientID', isEqualTo: user!.email?.toLowerCase())
      .get();
  for (var appointment in appointmentsS.docs) {
    var workshopName =
        await getWorkshopNameFromDB(appointment.data()['workshopID']);
    // if workshopName is not in appointments.keys add it
    if (!appointments.keys.contains(workshopName)) {
      appointments[workshopName] = [];
    }
    // add the appointment to the list of appointments
    appointments[workshopName].add(appointment);
  }
  return appointments;
}

cancelAppointment(String appointmentID) async {
  _firestore.collection('Appointments').doc(appointmentID).update({
    'status': 'available',
    'clientID': '',
    'serial': '',
    'services': [],
  });
}

getAppointmentReport(String appointmentID) async {
  String report = '';
  var appointment =
      await _firestore.collection('Appointments').doc(appointmentID).get();
  if (appointment['reportURL'] != "") {
    report = appointment['reportURL'];
  }
  return report;
}

getAppointmentsBySerial(String serial) async {
  Map appointments = {};
  final appointmentsS = await _firestore
      .collection('Appointments')
      .where('serial', isEqualTo: serial)
      .where('status', isEqualTo: 'finished')
      .get();
  for (var appointment in appointmentsS.docs) {
    var workshopName =
        await getWorkshopNameFromDB(appointment.data()['workshopID']);
    // if workshopName is not in appointments.keys add it
    if (!appointments.keys.contains(workshopName)) {
      appointments[workshopName] = [];
    }
    // add the appointment to the list of appointments
    appointments[workshopName].add(appointment);
  }
  return appointments;
}

getWorkshopLogoFromDB(String workshopID) async {
  var workshopLogo = '';
  await _firestore
      .collection('workshops')
      .doc(workshopID)
      .get()
      .then((value) => workshopLogo = value.data()!['logoURL']);
  return workshopLogo;
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
  return appointmentDB.data()!['paid'];
}

Future<List<String>> getServicesFromDB(String adminEmail) async {
  List<String> servicesDB = [];
  final temp =
      await _firestore.collection('workshopAdmins').doc(adminEmail.toLowerCase()).get();
  var counter = 0;
  for (var element in temp["services"]["service"]) {
    servicesDB.add('$element | ${temp["services"]["price"][counter]} SAR');
    counter++;
  }
  return servicesDB;
}

Future<bool> checkFutureAppointment() async {
  final User? user = _auth.currentUser;
  final appointmentsS = await _firestore
      .collection('Appointments')
      .where('clientID', isEqualTo: user!.email?.toLowerCase())
      .where('status', isEqualTo: 'booked')
      .get();
  if (appointmentsS.docs.isEmpty) {
    return false;
  }
  return true;
}

void updateAppointmentPaidStatus(String appointmentID) async {
  _firestore.collection('Appointments').doc(appointmentID).update({
    'paid': true,
  });
}
