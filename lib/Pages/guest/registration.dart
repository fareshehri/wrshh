// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Models/user.dart';
import '../../Services/Auth/auth.dart';
import '../../components/avatar_upload.dart';
import '../../components/icon_content.dart';
import '../../components/reusable_card.dart';
import '../../components/rounded_button.dart';
import '../../components/validators.dart';
import '../../constants.dart';
import '../client/client_home.dart';
import '../workshopAdmin/workshop_admin_home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

enum AccType {
  client,
  workshop,
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  AccType selectedType = AccType.client;

  bool showSpinner = false;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String workshop;

  late File _pickedImage;
  bool _load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(size: 24),
        title: const Text('Register'),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          child: SizedBox(
                            height: 200.0,
                            child: Image.asset('assets/images/Logo.png'),
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 48.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          setState(() {
                            selectedType = AccType.client;
                          });
                        },
                        colour: selectedType == AccType.client
                            ? kDarkColor
                            : kLightColor,
                        cardChild: const IconContent(
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
                            selectedType = AccType.workshop;
                          });
                        },
                        colour: selectedType == AccType.workshop
                            ? kDarkColor
                            : kLightColor,
                        cardChild: const IconContent(
                          icon: IconData(0xe83a, fontFamily: 'MaterialIcons'),
                          label: 'Workshop',
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                      'Sign Up as a ${selectedType == AccType.client ? 'Client' : 'Workshop Admin'}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      )),
                ),
                gap,
                Visibility(
                  visible: AccType.workshop == selectedType,
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
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
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
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock)),
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
                      hintText: 'Enter your name',
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person)),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: nameValidator,
                ),
                gap,
                IntlPhoneField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your phone number',
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone)),
                  countries: const ['SA'],
                  initialCountryCode: 'SA',
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your city',
                      labelText: 'City',
                      prefixIcon: const Icon(Icons.location_city)),
                  textAlign: TextAlign.center,
                  enabled: false,
                  initialValue: 'Al Riyadh',
                ),
                RoundedButton(
                  title: 'Register',
                  colour: kLightColor,
                  onPressed: () async {
                    if (!_load && AccType.workshop == selectedType) {
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
                      AppUser newUser;
                      if (AccType.client == selectedType) {
                        newUser = ClientUser(
                          email: email.toLowerCase(),
                          password: password,
                          phoneNumber: phoneNumber,
                          name: name,
                        );
                        try {
                          var user = await AuthService().signUpUser(newUser);
                          if (user!.user?.uid != null) {
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
                      } else if (AccType.workshop == selectedType) {
                        newUser = WorkshopAdmin(
                          email: email.toLowerCase(),
                          password: password,
                          phoneNumber: phoneNumber,
                          name: name,
                        );
                        showSpinner = false;

                        try {
                          var user = await AuthService().signUpUser(newUser);
                          if (user!.user?.uid != null) {
                            AuthService()
                                .uploadLogo(_pickedImage, newUser.email.toLowerCase());
                            Navigator.pushNamed(context, WorkshopAdminHome.id);
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

                        // Navigator.of(
                        //   context,
                        //   rootNavigator: true,
                        // ).push(MaterialPageRoute(
                        //   builder: (BuildContext context) => googleMapMyLoc(
                        //     userInfo: newUser,
                        //     workshopName: workshop,
                        //     logo: _pickedImage,
                        //   ),
                        // ));
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
