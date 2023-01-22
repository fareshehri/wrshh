import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrshh/Models/appointment.dart';
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
    var appointmentsDB = await getUserAppointmentsFromDB();

    setState(() {
      appointments = appointmentsDB;
      print('appointments: $appointments');
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
    for (var workshopName in appointments.keys) {
      print('workshopName: $workshopName');
      for (var appointment in appointments[workshopName]) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        var date = DateTime.fromMillisecondsSinceEpoch(
            appointment.data()['datetime'].seconds * 1000);
        final String dateFormatted = formatter.format(date);
        cards.add(
          AppointmentsCard(
            // logoURL: workshopName.first,
            itemID: appointment.data()['workshopID'],
            itemName: workshopName,
            cardType: 'Client',
            appointment: Appointment(
                appointmentID: appointment.id,
                workshopID: appointment.data()['workshopID'],
                VIN: '',
                clientID: '',
                status: 'available',
                service: '',
                price: 0,
                datetime: dateFormatted,
                rate: 0,
                reportURL: '',
              reportDetails: '',
            ),

          ),
        );
        cards.add(SizedBox(
          height: 10,
        ));
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
