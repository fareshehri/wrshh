import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Auth/client_database.dart';
import 'bottom_pill.dart';

/// Best Coverage on whole city
const LatLng cityCenter = LatLng(24.736034794755817, 46.70245822383719);

/// Show pin info part speed
const double pinVisiblePosition = 20;

/// Hide pin info part speed
const double pinInvisiblePosition = -250;

class MyGoogleMaps extends StatefulWidget {
  const MyGoogleMaps({super.key});

  @override
  GoogleMapsState createState() => GoogleMapsState();
}

class GoogleMapsState extends State<MyGoogleMaps> {
  /// Google Map Package Controller
  // late final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;

  /// To attack showPinsOnMap() method to the widget
  // final Set<Marker> _markers = <Marker> {};
  final Set<Marker> _markers = {};

  /// Primarily Hide Pins
  double pinPillPosition = pinInvisiblePosition;

  Map<String, dynamic> workshopInfo = {
    'workshopID': '',
    'workshopName': '',
    'overallRate': 0,
    'numberOfRates': 0,
    'logo': '',
    'technicianEmail': '',
    'adminEmail': '',
  };

  var serial = '';
  bool gotPath = false;

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var workshops = await getWorkshopsFromDB();
    final clientSerial = await getSerial();
    setState(() {
      serial = clientSerial;
    });

    _markers.clear();

    for (var workshop in workshops.keys) {
      String loc = workshops[workshop]['location'] as String;
      String name = workshops[workshop]['workshopName'];
      List locL = loc.split(',');
      double lat = double.parse(locL[0]);
      double long = double.parse(locL[1]);

      _markers.add(Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, long),
          draggable: false,
          onTap: () {
            setState(() {
              /// Show pin info
              workshopInfo['workshopID'] = workshop;
              workshopInfo['workshopName'] = name;
              workshopInfo['overallRate'] =
                  double.parse(workshops[workshop]['overallRate'].toString());
              workshopInfo['numberOfRates'] =
                  workshops[workshop]['numberOfRates'] as num;
              workshopInfo['logo'] = workshops[workshop]['logoURL'];
              workshopInfo['technicianEmail'] =
                  workshops[workshop]['technicianEmail'];
              workshopInfo['adminEmail'] = workshops[workshop]['adminEmail'];

              pinPillPosition = pinVisiblePosition;

              _controller.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(lat, long), 18));
            });
          }));
    }
    setState(() {
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (serial == "") {
        return const Scaffold(
          body: Center(
            child: Text(
              "Please add your car information first",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              /// The map
              Positioned.fill(
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
                  initialCameraPosition: const CameraPosition(
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

              /// Bottom pill
              BottomPill(
                pinPillPosition: pinPillPosition,
                workshopInfo: workshopInfo,
                rate: double.parse(workshopInfo['overallRate'].toString()),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Registered Workshops pins
  Future<void> showPinsOnMap() async {
    /// Pin #1
    setState(() {
      _markers.add(
        Marker(
            markerId: const MarkerId("marker1"),
            position: const LatLng(24.700789, 46.654955),
            draggable: false,
            onTap: () {
              setState(() {
                /// Show pin info
                pinPillPosition = pinVisiblePosition;

                /// Zoom when tapped
                _controller.animateCamera(CameraUpdate.newLatLngZoom(
                    const LatLng(24.700789, 46.654955), 18));
              });
            }),
      );
    });

    /// Pin #2
    setState(() {
      _markers.add(
        Marker(
            markerId: const MarkerId("marker2"),
            position: const LatLng(24.700935, 46.654500),
            draggable: false,
            onTap: () {
              setState(() {
                /// Show pin info
                pinPillPosition = pinVisiblePosition;

                /// Zoom when tapped
                _controller.animateCamera(CameraUpdate.newLatLngZoom(
                    const LatLng(24.700935, 46.654500), 18));
              });
            }),
      );
    });

    /// Pin #3
    setState(() {
      _markers.add(
        Marker(
            markerId: const MarkerId("marker3"),
            position: const LatLng(24.704790, 46.806561),
            draggable: false,
            onTap: () {
              setState(() {
                /// Show pin info
                pinPillPosition = pinVisiblePosition;

                /// Zoom when tapped
                _controller.animateCamera(CameraUpdate.newLatLngZoom(
                    const LatLng(24.704790, 46.806561), 18));
              });
            }),
      );
    });
  }
}
