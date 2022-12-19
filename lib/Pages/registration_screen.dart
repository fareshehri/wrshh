import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String selectedType = 'Client';

  bool showSpinner = false;
  late String email;
  late String password;
  late String username;
  late String phoneNumber;
  late String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                decoration:
                    kTextFieldDecoratopn.copyWith(hintText: 'Enter your email'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your password'),
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration:
                    kTextFieldDecoratopn.copyWith(hintText: 'Enter your name'),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your phone number'),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your username'),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: selectedType,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Client'),
                      value: 'Client',
                    ),
                    DropdownMenuItem(
                      child: Text('Workshop'),
                      value: 'Workshop',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        selectedType = value!;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: selectedType,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Client'),
                      value: 'Client',
                    ),
                    DropdownMenuItem(
                      child: Text('Workshop'),
                      value: 'Workshop',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        selectedType = value!;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  var newUser;
                  if (selectedType == 'Client') {
                    newUser = ClientUser(
                        username: username,
                        email: email,
                        password: password,
                        phoneNumber: phoneNumber,
                        name: name);
                  } else if (selectedType == 'Workshop') {
                    newUser = WorkshopUser(
                        username: username,
                        email: email,
                        password: password,
                        phoneNumber: phoneNumber,
                        name: name);
                  }
                  try {
                    var user = await AuthService().signUpUser(newUser);
                    print(user);
                    if (user != null) {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
