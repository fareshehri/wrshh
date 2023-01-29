import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Models/workshop.dart';
import '../../Services/Auth/workshopAdmin_database.dart';
import '../../Services/Maps/googleMapsPart.dart';
import '../../Services/Maps/WorkshopGoogleMaps.dart';
import '../../constants.dart';

class WorkshopDetails extends StatefulWidget {
  final Workshop workshop;

  const WorkshopDetails({
    required this.workshop,
  });

  @override
  State<WorkshopDetails> createState() =>
      _WorkshopDetailsState(workshop: workshop);
}

class _WorkshopDetailsState extends State<WorkshopDetails> {
  Workshop workshop;
  _WorkshopDetailsState({required this.workshop});

  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);
  late var technicianInfo;
  bool showSpinner = false;
  late String logoURL = workshop.logoURL;
  bool gotPath = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var technicianInfoDB =
        await getTechnicianInfoFromDB(widget.workshop.technicianEmail);
    setState(() {
      technicianInfo = technicianInfoDB;
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title:
              Text('${workshop.workshopName.toString().toUpperCase()} Details'),
        ),
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
                      labelText: 'Technical email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: technicianInfo['email'],
                    enabled: false,
                  ),

                  gap,
                  TextFormField(
                    decoration: kTextFieldDecoratopn.copyWith(
                        labelText: 'Technical name',
                        prefixIcon: Icon(Icons.person)),
                    initialValue: technicianInfo['name'],
                    enabled: false,
                    textAlign: TextAlign.center,
                  ),
                  gap,
                  IntlPhoneField(
                    decoration: kTextFieldDecoratopn.copyWith(
                        labelText: 'Technical phone Number',
                        prefixIcon: Icon(Icons.phone)),
                    countries: const ['SA'],
                    initialCountryCode: 'SA',
                    initialValue: technicianInfo['phoneNumber']
                        .toString()
                        .replaceAll('+966', ''),
                    enabled: false,
                  ),
                  gap,
                  TextFormField(
                    decoration: kTextFieldDecoratopn.copyWith(
                      labelText: 'Branch Name',
                      prefixIcon: const Icon(Icons.car_repair),
                    ),
                    initialValue: workshop.workshopName,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoratopn.copyWith(
                        hintText: 'Enter your city',
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city)),
                    textAlign: TextAlign.center,
                    enabled: false,
                    initialValue: 'Al Riyadh',
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  // location from google maps

                  SizedBox(
                    height: 400.0,
                    child: WorkshopGoogleMaps(
                      location: workshop.location,
                    ),
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
