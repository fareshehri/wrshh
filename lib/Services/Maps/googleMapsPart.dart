import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

import 'upperPill.dart';
import 'BottomPill.dart';

/// Best Coverage on whole city
const LatLng cityCenter = LatLng(24.708371, 46.716766);
/// Show pin info part speed
const double pinVisiblePosition = 20;
/// Hide pin info part speed
const double pinInvisiblePosition = -250;
/// Adjust zoom (still not working)
const double zoomLevels = 10.75;


class googleMaps extends StatefulWidget {
  const googleMaps({super.key});

  @override
  _googleMapsState createState() => _googleMapsState();
}


class _googleMapsState extends State<googleMaps> {

  /// Google Map Package Controller
  late final Completer<GoogleMapController> _controller = Completer();
  /// To attack showPinsOnMap() method to the widget
  final Set<Marker> _markers = <Marker> {};
  /// Primarily Hide Pins
  double pinPillPosition = pinInvisiblePosition;
  /// Adjust zoom (still not working)
  double zoomLevel = zoomLevels;


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
              initialCameraPosition:   const CameraPosition(
                /// Target area (coordinates)
                target: cityCenter,
                /// Zoom level
                zoom: 10.75,
              ),
              /// On Map Creates
              onMapCreated: (GoogleMapController controller) {
                /// Attack Previously Stated Controller
                _controller.complete(controller);
                /// showPinsOnMap() Method call
                showPinsOnMap();
              },
              /// On Map tap (Anywhere than the pins)
              onTap: (LatLng loc) {
                setState(() {
                  /// Hide pin info
                  pinPillPosition = pinInvisiblePosition;
                  /// Adjust zoom (still not working)
                  zoomLevel = 10.75;
                  const CameraPosition(zoom: 9, target: cityCenter);
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
void showPinsOnMap() {

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
            /// Adjust zoom (still not working)
            zoomLevel = 9;
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
            /// Adjust zoom (still not working)
            zoomLevel = 9;
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
            /// Adjust zoom (still not working)
            zoomLevel = 9;
          });
        }
    ),);
  });
}

}