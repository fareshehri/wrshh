import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'upperPill.dart';
import 'BottomPill.dart';

/// Best Coverage on whole city
const LatLng cityCenter = LatLng(24.736034794755817,46.70245822383719);
/// Show pin info part speed
const double pinVisiblePosition = 20;
/// Hide pin info part speed
const double pinInvisiblePosition = -250;


class MyGoogleMaps extends StatefulWidget {
  const MyGoogleMaps({super.key});

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}


class _GoogleMapsState extends State<MyGoogleMaps> {

  /// Google Map Package Controller
  // late final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;
  /// To attack showPinsOnMap() method to the widget
  // final Set<Marker> _markers = <Marker> {};
  final Set<Marker> _markers = {};
  /// Primarily Hide Pins
  double pinPillPosition = pinInvisiblePosition;

  // save all workshop information on this map
  Map<String, dynamic> workshopInfo = {'workshopName': '', 'adminEmail': '', 'logo': '', 'overAllRate': 0};

  void showPinsOnMap11() async{

    FirebaseFirestore.instance.collection('workshops').snapshots().listen((snapshot) {


      var count = 0;
      for (var document in snapshot.docs) {
        String email = document['adminEmail'];
        String loc = document['location'] as String;
        List Loc = loc.split(',');
        double lat = double.parse(Loc[1]);
        double lng = double.parse(Loc[0]);
        workshopInfo[email] = document.data();
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(count.toString()),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: document['workshopName'],
                snippet: document['location']),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              setState(()  {
                workshopInfo =  document.data();
                print(workshopInfo);
                pinPillPosition = pinVisiblePosition;

                _controller.animateCamera(
                    CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18));
              });
            },
          ));
        });


      }
    });
  }

  @override
  void initState() {
    super.initState();

    showPinsOnMap11();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// The map
          Positioned.fill (
            child: GoogleMap(
              /// Attack _markers to Google map's markers
              markers: _markers,
              /// Map type (satellite, etc..)
              mapType: MapType.normal,
              /// Enable zoom
              zoomControlsEnabled: true,
              /// Remove the Device Location button
              myLocationButtonEnabled: false,
              /// Initial Camera Position
              initialCameraPosition:  const CameraPosition(
                /// Target area (coordinates)
                target: cityCenter,
                /// Zoom level
                zoom: 11.75,
              ),
              /// On Map Create
              onMapCreated: (GoogleMapController controller) {
                /// Attach Previously Stated Controller
                _controller = controller;
                /// showPinsOnMap() Method call
                // showPinsOnMap();
              },
              /// On Map tap (Anywhere than the pins)
              onTap: (LatLng loc) {
                setState(() {
                  /// Hide pin info
                  pinPillPosition = pinInvisiblePosition;
                });
              },
            ),
          ),
          /// Upper pill
          const upperPill(),

          /// Bottom pill
          BottomPill(pinPillPosition: pinPillPosition, workshopInfo: workshopInfo),
        ],
      ),
    );
  }

}