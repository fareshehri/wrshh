import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<AppUser> getUser() async {
    final User user = _auth.currentUser!;
    final client = await _firestore.collection('clients').doc(user.email).get();
    final workshop = await _firestore.collection('workshopAdmin').doc(user.email).get();
    if(client.exists){
      return ClientUser(
        email: client['email'],
        name: client['name'],
        phoneNumber: client['phoneNumber'],
        password: '',
      );
    }
    else if(workshop.exists){
      return WorkshopUser(
        email: workshop['email'],
        name: workshop['name'],
        phoneNumber: workshop['phoneNumber'],
        password: '',
      );
    }
    else{
      return AppUser(
        email: 'user.email',
        name: 'user.displayName',
        phoneNumber: 'user.phoneNumber', password: '', userType: '',

      );
    }
  }

  Future<UserCredential> signInUser(String email, String password) async {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }

  Future<String> getUserType() async {
    final user = _auth.currentUser;
    final client = await _firestore.collection('clients').doc(user!.email).get();
    final workshop = await _firestore.collection('workshopAdmin').doc(user.email).get();
    return client.exists ? 'ClientUser' : workshop.exists ? 'WorkshopUser' : 'none';
  }

  Future<UserCredential> signUpUser(AppUser user) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
    if (newUser.user?.email != null) {
      if (user.userType == 'ClientUser') {
        _firestore.collection('clients').doc(user.email).set(
          {
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
            'vin': '',
          },
        );
      } else if (user.userType == 'WorkshopUser') {
        _firestore.collection('workshopAdmin').doc(user.email).set(
          {
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'adminName': user.name,
            'city': user.city,
          },
        );
      } else if (user.userType == 'AdminUser') {
        _firestore.collection('admins').doc(user.email).set(
          {
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
          },
        );
      }
    }
     return newUser;
  }

  void logOut() {
    _auth.signOut();
  }

  Future<void> addWorkshop(Workshop workshop, String email) async {
    /// Make variables for user to set
    final user = _auth.currentUser;
    LinkedHashMap<String, dynamic> Hours = {
      'sunday': [false,0,0,0,0],
      'monday': [false,0,0,0,0],
      'tuesday': [false,0,0,0,0],
      'wednesday': [false,0,0,0,0],
      'thursday': [false,0,0,0,0],
      'friday': [false,0,0,0,0],
      'saturday': [false,0,0,0,0],
    } as LinkedHashMap<String, dynamic>;
    LinkedHashMap<String, dynamic> services = {
      'service': ['Check Up', 'Oil Change'],
      'price': [0,120],
    } as LinkedHashMap<String, dynamic>;
    Map<String,dynamic> wp={
      'adminEmail': email,
      'workshopName': workshop.name,
      'location': workshop.location,
      'overAllRate': 0,
      'Hours': Hours,
      'services': services,
      'capacity': 1
    };
    FirebaseFirestore.instance.collection('workshops').doc(user?.email).set(wp);

   try {
      final ref = FirebaseStorage.instance.ref().child('workshopLogo').child(email);
      await ref.putFile(workshop.logo);
      final url = await ref.getDownloadURL();
      _firestore.collection('workshops').where('adminEmail', isEqualTo: email).get().then((value) {
        for (var element in value.docs) {
          _firestore.collection('workshops').doc(element.id).update(
            {
              'logo': url,
            },
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

}
