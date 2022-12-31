import 'package:booking_calendar/booking_calendar.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/Services/Auth/db.dart';

class ClientBooking extends StatefulWidget {
  final List appointments;
  ClientBooking({required this.appointments});

  @override
  State<ClientBooking> createState() => _ClientBookingState(appointments: appointments);
}

class _ClientBookingState extends State<ClientBooking> {
  final List appointments;
  _ClientBookingState({required this.appointments});

  var _selectedDate = DateTime.now().add(Duration(days: 1));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedDate = _selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        onDateChanged: (value) {
          setState(() {
            _selectedDate = value;
            print('Selected Date: $_selectedDate');
          });
        },
        selectedDate: _selectedDate,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 30)),

      ),
      body: buildAppointmentList(appointments),
    );
  }

  Container buildAppointmentList(List appointments) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return buildAppointmentCard(appointments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildAppointmentCard(appointment) {
    // appointment['start'] = DateTime.parse(appointment['start']);
    // appointment['end'] = DateTime.parse(appointment['end']);
    appointment['workshopID'] = appointment['workshopID'];
    bool booked = appointment['booked'];
    bool selected = false;
    Color color = selected ? Colors.yellow : booked ? Colors.red : Colors.green;

    return Container(
      child: Card(
        child: ListTile(
          title: Text(appointment['workshopID'].toString()),
          onTap: (){
            setState(() {
              selected = !selected;
              color = selected ? Colors.yellow : booked ? Colors.red : Colors.green;
              print('selected $selected');
            });
          },
        ),
      ),
    );
  }
}
