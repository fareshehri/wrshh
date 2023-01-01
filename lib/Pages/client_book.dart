import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/components/booking_slot.dart';
import 'package:intl/intl.dart';
import '../Services/Auth/db.dart';
import '../components/Calendar_Timeline.dart';

class ClientBooking extends StatefulWidget {
  final List appointments;
  ClientBooking({required this.appointments});

  @override
  State<ClientBooking> createState() =>
      _ClientBookingState(appointments: appointments);
}

class _ClientBookingState extends State<ClientBooking> {
  List appointments;
  Map selectedList = {};
  _ClientBookingState({required this.appointments});

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      selectedDate = DateTime.now();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        shadowColor: Colors.transparent,
      ),
      body: Column(children: [
        Container(
          height: 120,
          color: Colors.pink,
          child: CalendarTimeline(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 60)),
            onDateSelected: (date) {
              // setState(() {
                selectedDate = date;
                (context as Element).reassemble();
              // });
            },
            leftMargin: 20,
            monthColor: Colors.white,
            dayColor: Colors.white,
            activeDayColor: Colors.pink,
            activeBackgroundDayColor: Colors.white,
            dotsColor: Color(0xFF333A47),
            selectableDayPredicate: (date) => date.day != 23,
            locale: 'en_ISO',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Expanded(
            child: buildAppointmentList(appointments),
          ),
        )
      ]),
    );
  }

  Container buildAppointmentList(List appointments) {
    List dayAppointments = [];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedNow = formatter.format(selectedDate!);
    for (var i = 0; i < appointments.length; i++) {
      var appointmentDate = DateTime.fromMillisecondsSinceEpoch(
          appointments[i]['datetime'].seconds * 1000);
      String formattedAppointmentDate = formatter.format(appointmentDate);
      if (formattedAppointmentDate == formattedNow) {
        dayAppointments.add(appointments[i]);
      }
    dayAppointments.sort((a, b) => a['datetime'].compareTo(b['datetime']));
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: dayAppointments.length,
              itemBuilder: (context, index) {
                return buildAppointmentCard(dayAppointments[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildAppointmentCard(appointment) {
    bool booked = appointment['booked'];
    var timestamp = appointment['datetime'];
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

    return Container(
      child: BookingSlot(
        onTap: () {
          setState(() {
            selectedList = {};
            selectedList[appointment.id] = true;
          });
        },
        isBooked: booked,
        isSelected: selectedList[appointment.id] ?? false,
        isPauseTime: false,
        child: Center(
          child: Text(
            date.hour.toString() + ':' + date.minute.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
