// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wrshh/Services/Maps/google_maps_part.dart';

import '../../Models/user.dart';
import '../../Models/workshop.dart';
import '../../Pages/workshopAdmin/workshop_admin_home.dart';
import '../../components/rounded_button.dart';
import '../../constants.dart';
import '../Auth/auth.dart';

class GoogleMapMyLoc extends StatefulWidget {
  final WorkshopTech userInfo;
  final String workshopName;
  final String adminEmail;
  const GoogleMapMyLoc(
      {super.key,
      required this.userInfo,
      required this.workshopName,
      required this.adminEmail});

  @override
  GoogleMapsMyLocState createState() => GoogleMapsMyLocState();
}

class GoogleMapsMyLocState extends State<GoogleMapMyLoc> {
  late WorkshopTech userInfo;
  late String workshopName;
  late String adminEmail;

  /// Google Map Package Controller
  late final Completer<GoogleMapController> _controller = Completer();

  late Set<Marker> _myMarkers = <Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userInfo = widget.userInfo;
    workshopName = widget.workshopName;
    adminEmail = widget.adminEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(size: 24),
        title: const Text('Map'),
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
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// First Line text
                            Text(workshopName,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),

                            RoundedButton(
                              title: 'Register',
                              colour: kLightColor,
                              onPressed: () async {
                                String local =
                                    '${loc.latitude},${loc.longitude}';
                                try {
                                  String logoURL = await AuthService()
                                      .getLogoURL(adminEmail);
                                  var user =
                                      await AuthService().signUpTech(userInfo);
                                  if (user!.user?.uid != null) {
                                    Workshop workshop = Workshop(
                                      workshopUID: user.user!.uid,
                                      adminEmail: adminEmail,
                                      technicianEmail: userInfo.email,
                                      workshopName: workshopName,
                                      location: local,
                                      overallRate: 0,
                                      numOfRates: 0,
                                      logoURL: logoURL,
                                    );
                                    AuthService().addWorkshop(workshop);
                                  }
                                  Navigator.pushNamed(
                                      context, WorkshopAdminHome.id);
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
                  );
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
