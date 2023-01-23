import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/components/booking_slot.dart';
import 'package:intl/intl.dart';
import 'package:wrshh/components/roundedButton.dart';
import 'package:wrshh/constants.dart';
import '../Services/Auth/db.dart';
import '../components/Calendar_Timeline.dart';

class ClientBooking extends StatefulWidget {
  final workshopInfo;
  ClientBooking({required this.workshopInfo});

  @override
  State<ClientBooking> createState() =>
      _ClientBookingState(workshopInfo: workshopInfo);
}

class _ClientBookingState extends State<ClientBooking> {
  final workshopInfo;
  late List appointments;
  bool gotPath = false;
  Map selectedList = {};
  _ClientBookingState({required this.workshopInfo});

  DateTime selectedDate = DateTime(2023,1,21);

  @override
  void initState() {
    // TODO: implement initState
    _asyncMethod();
    super.initState();
  }

  _asyncMethod() async {
    var appointmentsDB =
        await getAppointmentsFromDB(workshopInfo['workshopID']);
    setState(() {
      appointments = appointmentsDB;
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
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
              firstDate: DateTime(2023, 1, 1),
              lastDate: DateTime(2023, 3, 3),
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
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green[800],
              ),
              SizedBox(
                width: 5,
              ),
              Text('Available'),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red[800],
              ),
              SizedBox(
                width: 5,
              ),
              Text('Booked'),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.grey,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Selected'),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: buildAppointmentList(appointments),
          ),
          RoundedButton(
            title: 'Book',
            colour: kDarkColor,
            onPressed: () {
              if (selectedList.isNotEmpty) {
                selectedList.forEach((key, value) {
                  bookAppointment(key);
                });
                Navigator.pop(context);
              } else {
                print('No appointment selected');
              }
            },
          ),
        ]),
      );
    }
  }

  Container buildAppointmentList(List appointments) {
    List dayAppointments = [];
    Map allDayAppointments = {};
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedNow = formatter.format(selectedDate);
    // appointments.sort((a, b) => a['datetime'].compareTo(b['datetime']));
    for (var i = 0; i < appointments.length; i++) {
      var appointmentDate = DateTime.fromMillisecondsSinceEpoch(
          appointments[i]['datetime'].seconds * 1000);
      String formattedAppointmentDate = formatter.format(appointmentDate);
      if (formattedAppointmentDate == formattedNow) {
        var timestamp = appointments[i]['datetime'];
        var date =
            DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
        if (allDayAppointments.containsKey(date)) {
          allDayAppointments[date].add(appointments[i]);
        } else {
          allDayAppointments[date] = [appointments[i]];
        }
      }
    }
    for (appointments in allDayAppointments.values) {
      var availableIndex = [];
      var bookedCounter = 0;
      for (var i = 0; i < appointments.length; i++) {
        if (appointments[i]['status'] != 'available') {
          bookedCounter++;
        } else {
          availableIndex.add(i);
        }
      }
      if (bookedCounter == appointments.length) {
        dayAppointments.add(appointments[0]);
      } else {
        dayAppointments.add(appointments[availableIndex[0]]);
      }
    }
    if (dayAppointments.isEmpty) {
      return Container(
        child: Center(
          child: Text('No appointments available',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              )),
        ),
      );
    }
    dayAppointments.sort((a, b) => a['datetime'].compareTo(b['datetime']));
    return Container(
      child:
          Expanded(
            child: GridView.builder(
              itemCount: dayAppointments.length,
              itemBuilder: (context, index) {
                return  buildAppointmentCard(dayAppointments[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
            ),
          ),

    );
  }

  Container buildAppointmentCard(appointment) {
    String status = appointment['status'];
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
        isBooked: status == 'available' ? false : true,
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
