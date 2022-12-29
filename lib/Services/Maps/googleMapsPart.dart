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


class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}


class _GoogleMapsState extends State<GoogleMaps> {

  /// Google Map Package Controller
  // late final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;
  /// To attack showPinsOnMap() method to the widget
  // final Set<Marker> _markers = <Marker> {};
  final Set<Marker> _markers = {};
  /// Primarily Hide Pins
  double pinPillPosition = pinInvisiblePosition;


  @override
  void initState() {
    super.initState();


    FirebaseFirestore.instance.collection('workshops').snapshots().listen((snapshot) {
      setState(() {
        _markers.clear();
        for (var document in snapshot.docs) {

          String loc = document['location'] as String;
          String name = document['workshopName'];
          List Loc = loc.split(',');

          _markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(Loc[0],Loc[1]),
              draggable: false,
              onTap: () {
                setState(() {
                  /// Show pin info
                  pinPillPosition = pinVisiblePosition;

                  _controller.animateCamera(
                      CameraUpdate.newLatLngZoom(LatLng(Loc[0], Loc[1]), 18)
                  );
                });
              }
            )
          );
          print("test");
          print("test");
        }
      });
    });
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
          BottomPill(pinPillPosition: pinPillPosition)
        ],
      ),
    );
  }

  /// Registered Workshops pins
  Future<void> showPinsOnMap() async {


    /// Pin #1
    setState(() {
      _markers.add( Marker(
          markerId: const MarkerId("marker1"),
          position: const LatLng(24.700789, 46.654955),
          draggable: false,
          onTap: () {
            setState(() {
              /// Show pin info
              pinPillPosition = pinVisiblePosition;
              /// Zoom when tapped
              _controller.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(24.700789, 46.654955), 18)
              );
            });
          }
      ),);

    });

    /// Pin #2
    setState(() {
      _markers.add( Marker(
          markerId: const MarkerId("marker2"),
          position: const LatLng(24.700935, 46.654500),
          draggable: false,
          onTap: () {
            setState(() {
              /// Show pin info
              pinPillPosition = pinVisiblePosition;
              /// Zoom when tapped
              _controller.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(24.700935, 46.654500), 18)
              );
            });
          }
      ),);
    });

    /// Pin #3
    setState(() {
      _markers.add( Marker(
          markerId: const MarkerId("marker3"),
          position: const LatLng(24.704790, 46.806561),
          draggable: false,
          onTap: () {
            setState(() {
              /// Show pin info
              pinPillPosition = pinVisiblePosition;
              /// Zoom when tapped
              _controller.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(24.704790, 46.806561), 18)
              );
            });
          }
      ),);
    });
  }

}