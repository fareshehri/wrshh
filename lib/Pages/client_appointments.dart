import 'package:flutter/material.dart';

import '../Services/Auth/db.dart';
import '../components/card.dart';

class ClientAppointments extends StatefulWidget {
  @override
  State<ClientAppointments> createState() => _ClientAppointmentsState();
}

class _ClientAppointmentsState extends State<ClientAppointments> {
  late Map appointments = {};
  late List workshops = [];

  @override
  void initState() {
    // TODO: implement initState
    _asyncMethod();
    // _asyncMethod().then((value) {
    //   setState(() {
    //     appointments = value;
    //   });
    // });
    super.initState();
  }

  _asyncMethod() async {
    var appointmentsDB = await getBookedAppointmentsFromDB('email');

    setState(() {
      appointments = appointmentsDB;
    });
    // (context as Element).reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: buildAppointmentsCards(appointments),
      ),
    );
  }

  List<Widget> buildAppointmentsCards(Map appointments) {
    List<Widget> cards = [];

    // loop through the appointments and create a card for each one
    for (var appointment in appointments.keys) {
      for (var workshop in appointments[appointment]) {
        cards.add(
          AppointmentsCard(
            itemTitle: appointment,
            itemSubtitle: workshop['booked'].toString(),
          ),
        );
        cards.add(SizedBox(height: 10,));
      }
    }

// loop over appointments and create a card for each appointment
//
//     for (var i = 0; i < appointments.length;  i++){
//       var timestamp = appointments[i]['datetime'];
//       var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       cards.add(AppointmentsCard(
//         itemTitle: appointments,
//         itemSubtitle: date.toString(),
//       ));
//       cards.add(SizedBox(height: 10,));
//
//     }

    return cards;
  }
}
