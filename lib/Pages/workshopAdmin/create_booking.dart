import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Services/Auth/workshopAdmin_database.dart';
import '../../Services/Maps/googleMapsPartAdmin.dart';
import '../../components/roundedButton.dart';
import '../../components/validators.dart';
import '../../constants.dart';


class CreateBooking extends StatefulWidget {
  const CreateBooking({Key? key}) : super(key: key);

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  bool showSpinner = false;
  late String email;
  late String serial;
  late String phoneNumber;
  late String name;
  late String workshop;
  late String logoURL;
  bool gotPath = false;

  _asyncMethod() async {
    logoURL = await getWorkshopLogoURL();
    setState(() {
      logoURL = logoURL;
      gotPath = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
  if (!gotPath){
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }else{
    return Scaffold(
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
                        child: SizedBox(
                          height: 200.0,
                          child: Image.network(
                            logoURL,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/loading.png',
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
                    hintText: 'Enter client email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
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
                      hintText: 'Enter client name',
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person)),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: nameValidator,
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter car serial number',
                      labelText: 'Serial number',
                      prefixIcon: Icon(Icons.car_repair)),
                  textAlign: TextAlign.center,
                  maxLength: 9,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    serial = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 9) {
                      return 'Please enter a valid Serial Number';
                    }
                    return null;
                  },
                ),
                gap,
                IntlPhoneField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter client phone number',
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone)),
                  countries: const ['SA'],
                  initialCountryCode: 'SA',
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter client city',
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city)),
                  textAlign: TextAlign.center,
                  enabled: false,
                  initialValue: 'Al Riyadh',

                ),
                RoundedButton(
                    title: 'Next',
                    colour: kLightColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        Map userInfo = {
                          'email': email,
                          'phoneNumber': phoneNumber,
                          'name': name,
                          'serial': serial,
                        };
                        print(userInfo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminGoogleMaps(
                              userInfo: userInfo,
                            ),
                          ),
                        );

                      }
                    }

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }
}
