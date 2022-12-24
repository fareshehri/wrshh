import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Models/user.dart';
import '../Services/Auth/auth.dart';
import '../Services/Maps/googleMapMyLoc.dart';
import '../components/roundedButton.dart';
import '../components/validators.dart';
import '../constants.dart';
import 'Home.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  String selectedType = 'Client';
  bool isClient = true;
  bool isWorkshop = false;

  bool showSpinner = false;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String workshop;

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
        iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
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
                SizedBox(
                  height: 48.0,
                ),
                Text('Select your account type'),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'Client',
                        ),
                        trailing: Checkbox(
                          activeColor: Colors.lightBlueAccent,
                          value: isClient,
                          onChanged: (checboxState) {
                            setState(() {
                              isClient = checboxState!;
                              if (isWorkshop) {
                                isWorkshop = !isWorkshop;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'Workshop',
                        ),
                        trailing: Checkbox(
                          activeColor: Colors.lightBlueAccent,
                          value: isWorkshop,
                          onChanged: (checboxState) {
                            setState(() {
                              isWorkshop = checboxState!;
                              if (isClient) {
                                isClient = !isClient;
                              }
                              if (!isWorkshop) {
                                isClient = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your email'),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty ||
                        !emailValidator.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value!.trim().isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your name'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty ||
                        !nameValidator.hasMatch(value)) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your phone number'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty ||
                        !phoneValidator.hasMatch(value)) {
                      return 'Please enter a valid phone number start with +966';
                    }
                    return null;
                  },
                ),
                gap,
                Visibility(
                  visible: isWorkshop,
                  child: TextFormField(
                    decoration: kTextFieldDecoratopn.copyWith(
                        hintText: 'Workshop name'),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      workshop = value;
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty ||
                          !nameValidator.hasMatch(value)) {
                        return 'Please enter your workshop name';
                      }
                      return null;
                    },
                  ),
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      var newUser;
                      selectedType = isWorkshop ? 'Workshop' : 'Client';
                      if (selectedType == 'Client') {
                        newUser = ClientUser(
                            email: email,
                            password: password,
                            phoneNumber: phoneNumber,
                            name: name);
                        try {
                          var user = await AuthService().signUpUser(newUser);
                          if (user.user?.uid != null) {
                            Navigator.pushNamed(context, Home.id);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Something went wrong')),
                          );
                        } finally {
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } else if (selectedType == 'Workshop') {
                        newUser = WorkshopUser(
                            email: email,
                            password: password,
                            phoneNumber: phoneNumber,
                            name: name);

                        showSpinner = false;
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(MaterialPageRoute(
                          builder: (BuildContext context) => googleMapMyLoc(
                            userInfo: newUser,
                            workshopName: workshop,
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
