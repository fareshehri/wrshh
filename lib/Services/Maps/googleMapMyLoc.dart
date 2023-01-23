import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrshh/Services/Maps/googleMapsPart.dart';

import '../../Models/user.dart';
import '../../Pages/workshopAdmin/workshop_Home.dart';
import '../../components/roundedButton.dart';
import '../Auth/auth.dart';

class googleMapMyLoc extends StatefulWidget {
  late WorkshopUser userInfo;
  late String workshopName;
  late File logo;
  googleMapMyLoc({required this.userInfo, required this.workshopName, required this.logo});

  @override
  _googleMapsMyLocState createState() => _googleMapsMyLocState(
        userInfo: userInfo,
        workshopName: workshopName,
        logo: logo,
      );
}

class _googleMapsMyLocState extends State<googleMapMyLoc> {
  late WorkshopUser userInfo;
  late String workshopName;
  late File logo;
  _googleMapsMyLocState({required this.userInfo, required this.workshopName, required this.logo});

  /// Google Map Package Controller
  late final Completer<GoogleMapController> _controller = Completer();

  late Set<Marker> _myMarkers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(size: 24),
        title: Text('Map'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
      ),
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
                target: LatLng(24.708371, 46.716766),

                /// Zoom level
                zoom: 11.75,
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
                                        Text(loc.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),

                                        RoundedButton(
                                          title: 'Register',
                                          colour: Colors.blueAccent,
                                          onPressed: () async {
                                            String LOCA = '${loc.longitude},${loc.latitude}';
                                            try {
                                              var user = await AuthService()
                                                  .signUpUser(userInfo);
                                              if (user.user?.uid != null) {
                                                Workshop workshop = Workshop(
                                                  name: workshopName,
                                                  location: LOCA,
                                                  logo: logo,
                                                );
                                                AuthService()
                                                    .addWorkshop(workshop, userInfo.email);
                                              }

                                              Navigator.pushNamed(
                                                  context, WHome.id);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Something went wrong, Email may be already in use'),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ));
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
