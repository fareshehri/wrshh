import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/Pages/Home.dart';
import 'package:wrshh/Pages/welcome.dart';
import 'firebase_options.dart';

import 'Pages/login.dart';
import 'Pages/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(
    initialRoute: Wrapper.id,
    routes: {
      Wrapper.id: (context) => Wrapper(),
      LoginScreen.id: (context) => LoginScreen(),
      RegistrationScreen.id: (context) => RegistrationScreen(),
      Home.id: (context) => Home()
    },
    home: Wrapper(),
  ));
}

class Wrapper extends StatefulWidget {
  static const String id = 'start';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return WelcomeScreen();
          }
        });
  }

  Future<User> getUser() async {
    final User user = await FirebaseAuth.instance.currentUser!;
    return user;
  }
}
// void main() async{
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MaterialApp(
//     home: Wrapper(),
//   ));
// }
// class Wrapper extends StatefulWidget {
//   const Wrapper({Key? key}) : super(key: key);

//   @override
//   State<Wrapper> createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> {

//   @override
//       Widget build(BuildContext context){
//         return FutureBuilder<User>(
//           future:getUser(),
//             builder: (BuildContext context, AsyncSnapshot<User> snapshot){
//                        if (snapshot.hasData){
//                         print('1');
//                            return const Home();
//                         }
//                         else{
//                         print('2');
//                         return const signIn();}
//              }
//           );
//     }
// }

// //firebase Old

// Future<User> getUser() async {
//   final User user = await FirebaseAuth.instance.currentUser!;
//   return user;
//   }

//     Future signinAnnon() async{
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     try {
//       UserCredential result = await _auth.signInAnonymously();
//       User user = result.user!;
//       print(user.uid);
//       return user;

//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //sign in email

//   //sign in phone

//   //register email
//   Future registerEmail(String email, String password)async{
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     User user = result.user!;
//     return user;
//   } catch (e) {
//     print(e.toString());
//     return null;
// }
//   }
//   //register phone

//   //signout
//   logOut(){
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//     try{
//       _auth.signOut();
//     }
//     catch(e){
//       print(e.toString());
//     }
//   }
