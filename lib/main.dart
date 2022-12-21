import 'package:flutter/material.dart';
import 'package:wrshh/Pages/Home.dart';
import 'package:wrshh/Pages/W_home.dart';


void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
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
