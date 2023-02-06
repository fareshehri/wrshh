import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';

import '../../Models/user.dart';
import '../../Models/workshop.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isAuth() {
    final user = _auth.currentUser;
    if (user?.email != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getCurrentUserEmail() async {
    final user = _auth.currentUser;
    return user!.email!;
  }

  Future<UserCredential?> signInUser(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
    }
    return userCredential!;
  }

  Future<String> getUserType(String? email) async {
    final user = _auth.currentUser;
    final client = await _firestore
        .collection('clients')
        .doc(user!.email?.toLowerCase())
        .get();
    final workshopAdmin = await _firestore
        .collection('workshopAdmins')
        .doc(user.email?.toLowerCase())
        .get();
    final workshopTechnician = await _firestore
        .collection('workshopTechnicians')
        .doc(user.email?.toLowerCase())
        .get();

    return client.exists
        ? 'ClientUser'
        : workshopAdmin.exists
            ? 'workshopAdmin'
            : workshopTechnician.exists
                ? 'workshopTechnician'
                : 'none';
  }

  Future<UserCredential?> signUpUser(AppUser user) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: user.email.toLowerCase(), password: user.password);
    if (newUser.user?.email != null) {
      if (user.userType == 'ClientUser') {
        _firestore.collection('clients').doc(user.email).set(
          {
            'email': user.email.toLowerCase(),
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
            'serial': '',
          },
        );
      } else if (user.userType == 'WorkshopAdmin') {
        LinkedHashMap<String, dynamic> services = {
          'service': ['Check Up'],
          'price': [0],
          'SubPrices': {
            'Check Up': [0]
          },
          'SubServices': {
            'Check Up': ['Tyre Pressure']
          }
        } as LinkedHashMap<String, dynamic>;
        _firestore
            .collection('workshopAdmins')
            .doc(user.email.toLowerCase())
            .set(
          {
            'email': user.email.toLowerCase(),
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
            'services': services,
          },
        );
      }
      return newUser;
    }
    return null;
  }

  Future<UserCredential?> signUpTech(AppUser user) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);

      if (userCredential.user?.email != null) {
        _firestore
            .collection('workshopTechnicians')
            .doc(user.email.toLowerCase())
            .set(
          {
            'email': user.email.toLowerCase(),
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
          },
        );
        app.delete();
        return userCredential;
      }
    } catch (e) {
      //
    }
    return null;
  }

  void logOut() {
    _auth.signOut();
  }

  Future<void> addWorkshop(Workshop workshop) async {
    /// Make variables for user to set
    LinkedHashMap<String, dynamic> hoursAndAvailability = {
      'sunday': [false, 0, 0, 0, 0],
      'monday': [false, 0, 0, 0, 0],
      'tuesday': [false, 0, 0, 0, 0],
      'wednesday': [false, 0, 0, 0, 0],
      'thursday': [false, 0, 0, 0, 0],
      'friday': [false, 0, 0, 0, 0],
      'saturday': [false, 0, 0, 0, 0],
    } as LinkedHashMap<String, dynamic>;
    Map<String, dynamic> wp = {
      'adminEmail': workshop.adminEmail?.toLowerCase(),
      'technicianEmail': workshop.technicianEmail.toLowerCase(),
      'workshopName': workshop.workshopName,
      'location': workshop.location,
      'city': 'Al Riyadh',
      'overallRate': 0,
      'numberOfRates': 0,
      'Hours': hoursAndAvailability,
      'capacity': 1,
      'logoURL': workshop.logoURL,
    };
    FirebaseFirestore.instance
        .collection('workshops')
        .doc(workshop.workshopUID)
        .set(wp);
  }

  void uploadLogo(File logo, String email) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('workshopLogo')
          .child(email.toLowerCase());
      await ref.putFile(logo);
    } catch (e) {
      //
    }
  }

  getLogoURL(String email) async {
    String url = '';
    try {
      await FirebaseStorage.instance
          .ref()
          .child('workshopLogo')
          .child(email.toLowerCase())
          .getDownloadURL()
          .then((value) => url = value);
    } catch (e) {
      await FirebaseStorage.instance
          .ref()
          .child('workshopLogo')
          .child('waleed5@gmail.co')
          .getDownloadURL()
          .then((value) => url = value);
    }
    return url;
  }
}
