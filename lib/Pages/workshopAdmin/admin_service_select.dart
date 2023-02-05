import 'package:flutter/material.dart';
import 'package:wrshh/constants.dart';
import '../../Services/Auth/client_database.dart';
import '../../components/rounded_button.dart';
import 'book_by_admin.dart';

class AdminSeviceSelection extends StatefulWidget {
  final Map workshopInfo;
  final Map userInformation;

  const AdminSeviceSelection(
      {super.key, required this.workshopInfo, required this.userInformation});

  @override
  State<AdminSeviceSelection> createState() => _SeviceSelectionState();
}

class _SeviceSelectionState extends State<AdminSeviceSelection> {
  List<String> services = [];
  List selectedServices = [];

  bool gotPath = false;

  @override
  initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var servicesDB = await getServicesFromDB(widget.workshopInfo['adminEmail']);
    setState(() {
      services = servicesDB;
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
            title: const Text('Select Services'),
            shadowColor: Colors.transparent,
            backgroundColor: kLightColor,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                          title: Text(
                            services[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                          value: selectedServices.contains(services[index]),
                          onChanged: (bool? value) {
                            if (value == true) {
                              setState(() {
                                selectedServices.add(services[index]);
                              });
                            } else {
                              setState(() {
                                selectedServices.remove(services[index]);
                              });
                            }
                          },
                          checkColor: Colors.white,
                          activeColor: kLightColor);
                    },
                    itemCount: services.length),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  onPressed: () {
                    if (selectedServices.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one service'),
                        ),
                      );
                    } else {
                      for (var i = 0; i < selectedServices.length; i++) {
                        selectedServices[i] =
                            selectedServices[i].toString().split(' | ')[0];
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminBooking(
                            workshopInfo: widget.workshopInfo,
                            selectedServices: selectedServices,
                            userInformation: widget.userInformation,
                          ),
                        ),
                      );
                    }
                  },
                  title: 'Next',
                  colour: kLightColor,
                ),
              ),
            ],
          ));
    }
  }
}
