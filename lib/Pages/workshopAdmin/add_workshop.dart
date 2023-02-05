// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wrshh/Services/Auth/auth.dart';

import '../../Models/user.dart';
import '../../Services/Auth/workshop_admin_database.dart';
import '../../Services/Maps/google_map_my_loc.dart';
import '../../components/rounded_button.dart';
import '../../components/validators.dart';
import '../../constants.dart';

class AddWorkshop extends StatefulWidget {
  const AddWorkshop({Key? key}) : super(key: key);

  @override
  State<AddWorkshop> createState() => _AddWorkshopState();
}

enum AccType {
  client,
  workshop,
}

class _AddWorkshopState extends State<AddWorkshop> {
  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  AccType selectedType = AccType.client;

  bool showSpinner = false;
  late String adminEmail;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String workshop;
  String logoURL = '';
  bool gotPath = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var logo = await getWorkshopLogoURL();
    setState(() {
      logoURL = logo;
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(size: 24),
        title: const Text('Add Workshop'),
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
                        child: SizedBox(
                          height: 200.0,
                          child: Image.network(
                            logoURL,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/FFFF.jpg',
                                width: 80,
                                height: 80,
                              );
                            },
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter technician email',
                    labelText: 'Technician email',
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
                      hintText: 'Enter technician password',
                      labelText: 'Technician password',
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
                      hintText: 'Enter technician name',
                      labelText: 'Technician name',
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
                      hintText: 'Enter technician phone number',
                      labelText: 'Technician phone Number',
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
                    hintText: 'Branch name',
                    labelText: 'Branch Name',
                    prefixIcon: const Icon(Icons.car_repair),
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    workshop = value;
                  },
                  validator: workshopNameValidator,
                ),
                const SizedBox(
                  height: 24.0,
                ),
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
                    title: 'Add Workshop',
                    colour: kLightColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        WorkshopTech newUser;
                        newUser = WorkshopTech(
                          email: email,
                          password: password,
                          phoneNumber: phoneNumber,
                          name: name,
                        );
                        showSpinner = false;
                        String adminEmail =
                            await AuthService().getCurrentUserEmail();
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(MaterialPageRoute(
                          builder: (BuildContext context) => GoogleMapMyLoc(
                            adminEmail: adminEmail,
                            userInfo: newUser,
                            workshopName: workshop,
                          ),
                        ));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
