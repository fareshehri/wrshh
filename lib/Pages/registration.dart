import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Models/user.dart';
import '../Services/Auth/auth.dart';
import '../Services/Maps/googleMapMyLoc.dart';
import '../components/avatar_upload.dart';
import '../components/icon_content.dart';
import '../components/reusable_card.dart';
import '../components/roundedButton.dart';
import '../components/validators.dart';
import '../constants.dart';
import 'Home.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

enum accType {
  client,
  workshop,
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  accType selectedType = accType.client;

  bool showSpinner = false;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String workshop;

  late File _pickedImage;
  bool _load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(size: 24),
        title: Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkColor, size: 24),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            height: 200.0,
                            child: Image.asset('assets/images/Logo.png'),
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 48.0,
                ),
                const Text('Select your account type',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    )),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          setState(() {
                            selectedType = accType.client;
                          });
                        },
                        colour: selectedType == accType.client
                            ? kDarkColor
                            : kLightColor,
                        cardChild: IconContent(
                          // client icon
                          icon: IconData(0xeb93, fontFamily: 'MaterialIcons'),
                          label: 'Client',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          setState(() {
                            selectedType = accType.workshop;
                          });
                        },
                        colour: selectedType == accType.workshop
                            ? kDarkColor
                            : kLightColor,
                        cardChild: IconContent(
                          icon: IconData(0xe83a, fontFamily: 'MaterialIcons'),
                          label: 'Workshop',
                        ),
                      ),
                    ),
                  ],
                )),
                gap,
                Visibility(
                  visible: accType.workshop == selectedType,
                  child: Column(
                    children: [
                      AvatarPhoto(
                        onImageSelected: (image) {
                          setState(() {
                            _load = true;
                            _pickedImage = image;
                          });
                        },
                      ),
                      gap,
                    ],
                  ),
                ),

                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your email'),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: emailValidator,
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your password'),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  validator: passwordValidator,
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your name'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: nameValidator,
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your phone number'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  validator: phoneNumberValidator,
                ),
                gap,
                Visibility(
                  visible: accType.workshop == selectedType,
                  child: TextFormField(
                    decoration: kTextFieldDecoratopn.copyWith(
                        hintText: 'Workshop name'),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      workshop = value;
                    },
                    validator: workshopNameValidator,
                  ),
                ),
                RoundedButton(
                  title: 'Register',
                  colour: kLightColor,
                  onPressed: () async {
                    if (!_load && accType.workshop == selectedType) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please upload your logo'),
                        ),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      var newUser;
                      if (accType.client == selectedType) {
                        newUser = ClientUser(
                          email: email,
                          password: password,
                          phoneNumber: phoneNumber,
                          name: name,
                        );
                        try {
                          var user = await AuthService().signUpUser(newUser);
                          if (user.user?.uid != null) {
                            Navigator.pushNamed(context, Home.id);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Something went wrong, Email may be already in use'),
                            ),
                          );
                        } finally {
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } else if (accType.workshop == selectedType) {
                        newUser = WorkshopUser(
                          email: email,
                          password: password,
                          phoneNumber: phoneNumber,
                          name: name,
                        );
                        showSpinner = false;
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(MaterialPageRoute(
                          builder: (BuildContext context) => googleMapMyLoc(
                            userInfo: newUser,
                            workshopName: workshop,
                            logo: _pickedImage,
                          ),
                        ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
