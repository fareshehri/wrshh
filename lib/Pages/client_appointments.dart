import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/Auth/db.dart';
import '../components/buildCards.dart';

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
    super.initState();
  }

  _asyncMethod() async {
    var appointmentsDB = await getUserAppointmentsFromDB();

    setState(() {
      appointments = appointmentsDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: buildAppointmentsCards(appointments, 'Bookings'),
      ),
    );
  }

}
