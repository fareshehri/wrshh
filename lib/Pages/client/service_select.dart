import 'package:flutter/material.dart';
import 'package:wrshh/constants.dart';

import '../../Services/Auth/client_database.dart';
import '../../components/roundedButton.dart';
import 'client_book.dart';

class SeviceSelection extends StatefulWidget {

  // late Map selectedList;
  late Map workshopInfo;

  SeviceSelection({ required this.workshopInfo});

  @override
  State<SeviceSelection> createState() => _SeviceSelectionState();
}

class _SeviceSelectionState extends State<SeviceSelection> {

  List<String> services = [];
  List selectedServices = [];

  bool gotPath = false;

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
              child: ListView.builder(itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(services[index], style: TextStyle(fontSize: 18),),
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
                  activeColor: kLightColor
                );
              }, itemCount: services.length),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedButton(
                onPressed: () {
                 if (selectedServices.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one service'),
                      ),
                    );
                  } else {
                   for (var i = 0; i < selectedServices.length; i++) {
                     selectedServices[i] = selectedServices[i].toString().split(' | ')[0];
                   }
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => ClientBooking(
                           workshopInfo: widget.workshopInfo,
                           selectedServices: selectedServices),
                     ),
                   );
                 }
                }, title: 'Next', colour: kLightColor,
              ),
            ),
          ],
        )
      );
    }
  }
}
