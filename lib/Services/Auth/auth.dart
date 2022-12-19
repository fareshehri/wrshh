import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //signin

  void signInUser(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // register
  Future<UserCredential> signUpUser(AppUser user) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
    print(newUser);
    if (newUser.user != null) {
      if (user.userType == 'ClientUser') {
        _firestore.collection('clients').add(
          {
            'uid': newUser.user?.uid,
            'username': user.username,
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'name': user.name,
            'city': user.city,
          },
        );
      } else if (user.userType == 'WorkshopUser') {
        _firestore.collection('workshopAdmin').add(
          {
            'uid': user.uid,
            'username': user.username,
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'adminName': user.name,
            'city': user.city,
          },
        );

        // TODO: change this
        _firestore.collection('workshops').add(
          {
            'uid': user.uid,
            'workshopName': user.name,
            'location': user.city,
            'overAllRate': 0,
          },
        );
      } else if (user.userType == 'AdminUser') {
        _firestore.collection('admins').add(
          {
            'uid': user.uid,
            'username': user.username,
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

  //signout

}
