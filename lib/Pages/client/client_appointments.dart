import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Services/Auth/client_database.dart';
import '../../Services/Auth/workshopTechnician_database.dart';
import '../../components/buildCards.dart';

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
      child: getBody(),
    );
  }

  Widget getBody(){
    if (appointments.isEmpty) {
      return const Center(
        child: Text('You have no appointments',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
            )),
      );
    }
    else{
      return ListView(
        children: buildAppointmentsCards(appointments, 'Bookings'),
      );
    }
  }

}
