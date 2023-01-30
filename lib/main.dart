
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/Pages/client/Home.dart';
import 'package:wrshh/Pages/guest/welcome.dart';
import 'Pages/workshopAdmin/workshopAdmin_Home.dart';
import 'Pages/workshopTechnician/technician_home.dart';
import 'Services/Auth/auth.dart';
import 'firebase_options.dart';

import 'Pages/guest/login.dart';
import 'Pages/guest/registration.dart';

// void main() async{
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MaterialApp(
//     home: Wrapper(),
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    initialRoute: Wrapper.id,
    routes: {
      Wrapper.id: (context) => Wrapper(),
      LoginScreen.id: (context) => LoginScreen(),
      RegistrationScreen.id: (context) => RegistrationScreen(),
      Home.id: (context) => Home(),
      WorkshopAdminHome.id: (context) => WorkshopAdminHome(),
      WorkshopTechnicianHome.id: (context) => WorkshopTechnicianHome(),
      // AHome.id: (context) => AHome(),
    },
    home: Wrapper(),
  ));
}



class Wrapper extends StatefulWidget {
  static const String id = 'Landing';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getUserType(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'ClientUser') {
              return Home();
            } else if (snapshot.data == 'workshopAdmin') {
              return WorkshopAdminHome();
            } else if (snapshot.data == 'workshopTechnician') {
              return WorkshopTechnicianHome();
            } else {
              return LoginScreen();
            }
          } else {
            return WelcomeScreen();
          }
        });
  }

  Future<String> getUserType() async {
    final User user = await FirebaseAuth.instance.currentUser!;
    String userType = await AuthService().getUserType(user.email);
    return userType;
  }
}
