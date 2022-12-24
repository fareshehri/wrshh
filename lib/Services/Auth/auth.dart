import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isAuth() {
    final user = _auth.currentUser;
    print(user);
    if (user?.uid != null) {
      return true;
    } else {
      return false;
    }
  }

  void signInUser(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // register
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

  void addWorkshop(Workshop workshop) {
    _firestore.collection('workshops').add(
      {
        'uid': workshop.uid,
        'workshopName': workshop.name,
        'location': workshop.location,
        'overAllRate': 0,
      },
    );
  }
}
