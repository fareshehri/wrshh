import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

void bookAppointmentByAdmin(String id, Map user, List selectedServices) async {
  print(id);
  _firestore.collection('Appointments').doc(id).update({
    'clientID': user['email'],
    'serial': user['serial'],
    'status': 'booked',
    'services': selectedServices,
  });
}

getUserWorkshopsFromDB() async {
  Map workshopsMap = {};
  var workshopsDB = await _firestore
      .collection('workshops')
      .where('adminEmail', isEqualTo: _auth.currentUser!.email)
      .get();

  // loop through the workshopsDB and add them to the workshopsMap with the workshopID as the key and workshop.data() as the value

  for (var workshop in workshopsDB.docs) {
    workshopsMap[workshop.id] = workshop.data();
  }
  return workshopsMap;
}

getWorkshopLogoFromDB(String workshopID) async {
  var workshopLogo = '';
  await await _firestore
      .collection('workshops')
      .doc(workshopID)
      .get()
      .then((value) => workshopLogo = value.data()!['logoURL']);
  return workshopLogo;
}

getWorkshopAdminInfo(String email) async {
  return await _firestore.collection('workshopAdmins').doc(email).get();
}

Future<String> updateWorkshopAdminInfo(Map userData) async {
  String result = 'success';
  try {
    await _firestore.collection('workshopAdmins').doc(userData['email']).update(
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

// update workshop name where technicianEmail = technicianEmail
updateWorkshopName(String name, String technicianEmail) async {
  var result = 'success';
  try {
    await _firestore.collection('workshops').doc(technicianEmail).update(
      {
        'workshopName': name,
      },
    );
  } catch (e) {
    result = e.toString();
  }
  return result;
}

Future<String> updateWorkshopAdminEmail(String email, Map data) async {
  String result = 'success';
  try {
    await _auth.currentUser!.updateEmail(email);
    _firestore.collection('workshopAdmins').doc(data['email']).delete();
    _firestore.collection('workshopAdmins').doc(email).set({
      'email': email,
      'name': data['name'],
      'phoneNumber': data['phoneNumber'],
      'city': data['city'],
      'services': data['services'],
    });
    var workshops = await _firestore
        .collection('workshops')
        .where('adminEmail', isEqualTo: data['email'])
        .get();
    for (var workshop in workshops.docs) {
      await _firestore.collection('workshops').doc(workshop.id).update(
        {
          'adminEmail': email,
        },
      );
    }
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

Future<LinkedHashMap<String, dynamic>> getServices() async {
  final user = _auth.currentUser;
  final time =
      await _firestore.collection('workshopAdmins').doc(user?.email).get();
  var services = time['services'];

  return services;
}

Future<void> updateServices(LinkedHashMap<String, dynamic> services) async {
  final user = _auth.currentUser;
  FirebaseFirestore.instance
      .collection('workshopAdmins')
      .doc(user?.email)
      .update({'services': services});
}

getTechnicianNameFromDB(String technicianID) async {
  try {
    var technicianName = '';
    await _firestore
        .collection('workshopTechnicians')
        .doc(technicianID)
        .get()
        .then((value) => technicianName = value.data()?['name']);
    return technicianName;
  } catch (e) {}
  return '';
}

getTechnicianInfoFromDB(String technicianID) async {
  var technicianInfo = {};
  await _firestore
      .collection('workshopTechnicians')
      .doc(technicianID)
      .get()
      .then((value) => technicianInfo = value.data()!);
  return technicianInfo;
}

getWorkshopLogoURL() async {
  String url = '';
  String email = _auth.currentUser!.email!;
  try {
    await FirebaseStorage.instance
        .ref()
        .child('workshopLogo')
        .child(email)
        .getDownloadURL()
        .then((value) => url = value);
  } catch (e) {
    await FirebaseStorage.instance
        .ref()
        .child('workshopLogo')
        .child('loading.png')
        .getDownloadURL()
        .then((value) => url = value);
  }
  return url;
}

updateWorkshopLogo(File logo) async {
  String email = _auth.currentUser!.email!;
  String result = 'success';
  try {
    FirebaseStorage.instance.ref().child('workshopLogo').child(email).delete();
    final ref =
        FirebaseStorage.instance.ref().child('workshopLogo').child(email);
    await ref.putFile(logo);
    String url = await ref.getDownloadURL();
    var workshops = await _firestore
        .collection('workshops')
        .where('adminEmail', isEqualTo: email)
        .get();
    for (var workshop in workshops.docs) {
      await _firestore.collection('workshops').doc(workshop.id).update(
        {
          'logoURL': url,
        },
      );
    }
  } catch (e) {
    result = e.toString();
  }
  return result;
}
