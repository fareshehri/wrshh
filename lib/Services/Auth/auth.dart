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

  Future<void> addWorkshop(Workshop workshop, String email) async {
    final defaultWorkingHours = [8, 0, 16, 0];
    final defaultServices = ['Check up', 'Oil change'];
    final defaultPrices = ['Free', '120'];
    final List defaultBreakDates = [DateTime(2023,4,9).millisecondsSinceEpoch, DateTime(2023,4,10).millisecondsSinceEpoch];
    final List defaultBreakHours = [DateTime(2023,5,9,19,30).millisecondsSinceEpoch, DateTime(2023,6,9,10).millisecondsSinceEpoch];
    final user = _auth.currentUser;
    Map<String,dynamic> wp={
      'adminEmail': email,
      'workshopName': workshop.name,
      'location': workshop.location,
      'overAllRate': 0,
      'ser': defaultServices,
      'pri': defaultPrices,
      'capacity': 1,
      'workingHours': defaultWorkingHours,
      'breakDates': defaultBreakDates,
      'breakHours': defaultBreakHours
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
}
