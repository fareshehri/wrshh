import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Models/user.dart';
import '../Services/Auth/auth.dart';
import '../Services/Maps/googleMapsPart.dart';
import '../components/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';
import 'Home.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
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
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              Visibility(
                visible: isWorkshop,
                child: TextField(
                  decoration:
                      kTextFieldDecoratopn.copyWith(hintText: 'Workshop name'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    workshop = value;
                  },

                ),
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
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
                      if (user != null) {
                        Navigator.pushNamed(context, Home.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  } else if (selectedType == 'Workshop') {
                    newUser = WorkshopUser(
                        email: email,
                        password: password,
                        phoneNumber: phoneNumber,
                        name: name);

                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: googleMapMyLoc(
                                    userInfo: newUser,
                                    workshopName: workshop,
                                  ),
                                ),
                              ),
                            ));
                  }

                  //
                  // try {
                  //   var user = await AuthService().signUpUser(newUser);
                  //   print(user);
                  //   if (user != null) {
                  //     Navigator.pushNamed(context, LoginScreen.id);
                  //   }
                  //   setState(() {
                  //     showSpinner = false;
                  //   });
                  // } catch (e) {
                  //   print(e);
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class googleMapMyLoc extends StatefulWidget {
  late WorkshopUser userInfo;
  late String workshopName;
  googleMapMyLoc({required this.userInfo, required this.workshopName});

  @override
  _googleMapsMyLocState createState() => _googleMapsMyLocState(
        userInfo: userInfo,
        workshopName: workshopName,
      );
}

class _googleMapsMyLocState extends State<googleMapMyLoc> {
  late WorkshopUser userInfo;
  late String workshopName;
  _googleMapsMyLocState({required this.userInfo, required this.workshopName});

  /// Google Map Package Controller
  late final Completer<GoogleMapController> _controller = Completer();

  late Set<Marker> _myMarkers = <Marker>{};

  /// Adjust zoom (still not working)
  double zoomLevel = zoomLevels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// The map
          Positioned.fill(
            child: GoogleMap(
              markers: _myMarkers,

              /// Map type (satellite, etc..)
              mapType: MapType.normal,

              /// Enable zoom
              zoomControlsEnabled: true,

              /// Remove the Device Location button
              myLocationButtonEnabled: true,
              myLocationEnabled: true,

              /// Initial Camera Position
              initialCameraPosition: const CameraPosition(
                /// Target area (coordinates)
                target: cityCenter,

                /// Zoom level
                zoom: 10.75,
              ),

              /// On Map Creates
              onMapCreated: (GoogleMapController controller) {
                /// Attack Previously Stated Controller
                _controller.complete(controller);
              },

              /// On Map tap (Anywhere than the pins)
              onTap: (LatLng loc) {
                setState(() {
                  _myMarkers = {};
                  _myMarkers.add(Marker(
                    markerId: MarkerId(loc.toString()),
                    position: loc,
                  ));

                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        /// First Line text
                                        Text('${loc.toString()}',
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),

                                        RoundedButton(
                                          title: 'Register',
                                          colour: Colors.blueAccent,
                                          onPressed: () async {
                                            try {
                                              var user = await AuthService()
                                                  .signUpUser(userInfo);
                                              if (user.user?.uid != null) {
                                                Workshop workshop = Workshop(
                                                  uid: user.user?.uid,
                                                  name: workshopName,
                                                  location: loc.toString(),
                                                );
                                                AuthService()
                                                    .addWorkshop(workshop);
                                              }

                                              Navigator.pushNamed(
                                                  context, Home.id);
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ));

                  /// Adjust zoom (still not working)
                  zoomLevel = 10.75;
                  const CameraPosition(zoom: 9, target: cityCenter);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
