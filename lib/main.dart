import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/Pages/client/client_home.dart';
import 'package:wrshh/Pages/guest/welcome.dart';
import 'Pages/workshopAdmin/workshop_admin_home.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    initialRoute: Wrapper.id,
    routes: {
      Wrapper.id: (context) => const Wrapper(),
      LoginScreen.id: (context) => const LoginScreen(),
      RegistrationScreen.id: (context) => const RegistrationScreen(),
      Home.id: (context) => const Home(),
      WorkshopAdminHome.id: (context) => const WorkshopAdminHome(),
      WorkshopTechnicianHome.id: (context) => const WorkshopTechnicianHome(),
      // AHome.id: (context) => AHome(),
    },
    home: const Wrapper(),
  ));
}

class Wrapper extends StatefulWidget {
  static const String id = 'Landing';

  const Wrapper({super.key});

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
              return const Home();
            } else if (snapshot.data == 'workshopAdmin') {
              return const WorkshopAdminHome();
            } else if (snapshot.data == 'workshopTechnician') {
              return const WorkshopTechnicianHome();
            } else {
              return const LoginScreen();
            }
          } else {
            return const WelcomeScreen();
          }
        });
  }

  Future<String> getUserType() async {
    final User user = FirebaseAuth.instance.currentUser!;
    String userType = await AuthService().getUserType(user.email);
    return userType;
  }
}
