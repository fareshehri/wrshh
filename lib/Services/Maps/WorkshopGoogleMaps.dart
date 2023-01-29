import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkshopGoogleMaps extends StatefulWidget {
  late final String location;
  WorkshopGoogleMaps({required this.location});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<WorkshopGoogleMaps> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  late LatLng _center;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _center = LatLng(double.parse(widget.location.split(',')[0]),
          double.parse(widget.location.split(',')[1]));
      _markers.add(Marker(
        markerId: MarkerId('1'),
        position: _center,
        infoWindow: InfoWindow(
          title: 'Workshop',
          snippet: 'Workshop',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
      ),
    );
  }
}
