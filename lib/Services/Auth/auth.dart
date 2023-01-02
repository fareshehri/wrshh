import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

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

  final defaultServices =
      '[{\'name\': \'Check up\', \'price\': 0},]';

  Future<void> addWorkshop(Workshop workshop, String email) async {
    _firestore.collection('workshops').add(
      {
        'adminEmail': email,
        'workshopName': workshop.name,
        'location': workshop.location,
        'overAllRate': 0,
        'services': defaultServices,
        'capacity': 1,
        'startTimeH': 8,
        'startTimeM': 0,
        'finishTimeH': 16,
        'finishTimeM': 0
      },
    );

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


  Future<void> updateWorkingHours(TimeRangeResult R) async {
    FirebaseFirestore.instance.collection('workshops').doc('aAo2kkYXxx5WIF66wSBt').update({
      'startTimeH': R.start.hour,
      'startTimeM': R.start.minute,
      'finishTimeH': R.end.hour,
      'finishTimeM': R.end.minute
    });
  }
  Future<TimeRangeResult> getWorkingHours() async {

    final time = await _firestore.collection('workshops').doc('aAo2kkYXxx5WIF66wSBt').get();
      int sth = time['startTimeH'];
      int stm = time['startTimeM'];
      int fth = time['finishTimeH'];
      int ftm = time['finishTimeM'];

      TimeRangeResult timeRange = TimeRangeResult(
        TimeOfDay(hour: sth, minute: stm),
        TimeOfDay(hour: fth, minute: ftm)
      );

    return timeRange;
  }

  Future<void> updateCapacity(int c) async {
    FirebaseFirestore.instance.collection('workshops').doc('aAo2kkYXxx5WIF66wSBt').update({
      'capacity': c
    });
  }
  Future<int> getCapacity() async {
    final cap = await _firestore.collection('workshops').doc('aAo2kkYXxx5WIF66wSBt').get();
    return cap['capacity'] as int;
  }

}
