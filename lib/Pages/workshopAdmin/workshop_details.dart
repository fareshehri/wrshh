// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Models/workshop.dart';
import '../../Services/Auth/workshop_admin_database.dart';
import '../../Services/Maps/workshop_google_maps.dart';
import '../../components/validators.dart';
import '../../constants.dart';

class WorkshopDetails extends StatefulWidget {
  final Workshop workshop;

  const WorkshopDetails({
    super.key,
    required this.workshop,
  });

  @override
  State<WorkshopDetails> createState() => _WorkshopDetailsState();
}

class _WorkshopDetailsState extends State<WorkshopDetails> {
  late Workshop workshop;

  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);
  late Map technicianInfo;
  bool showSpinner = false;
  late String logoURL = workshop.logoURL;
  bool gotPath = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
    workshop = widget.workshop;
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
            title: Text(
                '${workshop.workshopName.toString().toUpperCase()} Details'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              logoURL,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/loading.png',
                                  width: 200,
                                  height: 200,
                                );
                              },
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ]),
                    const SizedBox(
                      height: 48.0,
                    ),
                    TextFormField(
                      decoration: kTextFieldDecoratopn.copyWith(
                        labelText: 'Technical email',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      textAlign: TextAlign.center,
                      initialValue: technicianInfo['email'],
                      enabled: false,
                    ),

                    gap,
                    TextFormField(
                      decoration: kTextFieldDecoratopn.copyWith(
                          labelText: 'Technical name',
                          prefixIcon: const Icon(Icons.person)),
                      initialValue: technicianInfo['name'],
                      enabled: false,
                      textAlign: TextAlign.center,
                    ),
                    gap,
                    IntlPhoneField(
                      decoration: kTextFieldDecoratopn.copyWith(
                          labelText: 'Technical phone Number',
                          prefixIcon: const Icon(Icons.phone)),
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
                      onChanged: (value) {
                        workshop.workshopName = value;
                      },
                      validator: workshopNameValidator,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    TextFormField(
                      decoration: kTextFieldDecoratopn.copyWith(
                          hintText: 'Enter your city',
                          labelText: 'City',
                          prefixIcon: const Icon(Icons.location_city)),
                      textAlign: TextAlign.center,
                      enabled: false,
                      initialValue: 'Al Riyadh',
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    // location from google maps

                    SizedBox(
                      height: 400.0,
                      child: WorkshopGoogleMaps(
                        location: workshop.location,
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ElevatedButton(
                      child: const Text('Update Branch Name'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Center(child: Text('Confirmaion')),
                                content: const Text(
                                    "Are you sure you want to Update Branch Name?"),
                                actions: [
                                  TextButton(
                                    child: const Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        var result = await updateWorkshopName(
                                            workshop.workshopName,
                                            workshop.workshopUID);
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        if (result == 'success') {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const AlertDialog(
                                                  title: Center(
                                                      child: Text(
                                                    'Name updated successfully',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                                );
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Center(
                                                  child:
                                                      Column(children: const [
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 50,
                                                    ),
                                                    Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'Something went wrong',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ]),
                                                ));
                                              });
                                        }
                                      },
                                      child: const Text("Yes")),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }
}
