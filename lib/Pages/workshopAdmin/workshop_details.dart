import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Models/workshop.dart';

import '../../Services/Auth/auth.dart';
import '../../Services/Auth/client_database.dart';
import '../../components/validators.dart';
import '../../constants.dart';

class WorkshopDetails extends StatefulWidget {
  final Workshop workshop;
  const WorkshopDetails({required this.workshop});

  @override
  State<WorkshopDetails> createState() =>
      _WorkshopDetailsState(workshop: workshop);
}

class _WorkshopDetailsState extends State<WorkshopDetails> {
  Workshop workshop;
  _WorkshopDetailsState({required this.workshop});

  final _formKey = GlobalKey<FormState>();

  var gap = const SizedBox(height: 8.0);

  bool showSpinner = false;
  late String? adminEmail = workshop.adminEmail;
  late String email = workshop.technicianEmail;
  late String phoneNumber = workshop.technicianEmail;
  late String name = workshop.technicianEmail;
  // late String workshop;
  late String logoURL = workshop.logoURL;
  bool gotPath = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _asyncMethod();
  }

  _asyncMethod() async {
    String adminEmail = await AuthService().getCurrentUserEmail();
    var logo = await getWorkshopLogoFromDB(adminEmail);

    setState(() {
      logoURL = logo;
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${workshop.workshopName} Details'),
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
                    hintText: 'Enter technical email',
                    labelText: 'Technical email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: emailValidator,
                ),

                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter technical name',
                      labelText: 'Technical name',
                      prefixIcon: Icon(Icons.person)),
                  initialValue: name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: nameValidator,
                ),
                gap,
                IntlPhoneField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter technical phone number',
                      labelText: 'Technical phone Number',
                      prefixIcon: Icon(Icons.phone)),
                  countries: const ['SA'],
                  initialCountryCode: 'SA',
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Branch name',
                    labelText: 'Branch Name',
                    prefixIcon: const Icon(Icons.car_repair),
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    // workshop = value;
                  },
                  validator: workshopNameValidator,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
