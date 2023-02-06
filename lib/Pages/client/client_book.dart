// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:wrshh/Pages/client/client_home.dart';
import 'package:wrshh/components/booking_slot.dart';
import 'package:intl/intl.dart';
import 'package:wrshh/components/rounded_button.dart';
import 'package:wrshh/constants.dart';
import '../../Services/Auth/client_database.dart';
import '../../components/calendar_time_line.dart';

class ClientBooking extends StatefulWidget {
  final Map workshopInfo;
  final List selectedServices;
  const ClientBooking(
      {super.key, required this.workshopInfo, required this.selectedServices});

  @override
  State<ClientBooking> createState() => _ClientBookingState();
}

class _ClientBookingState extends State<ClientBooking> {
  late final Map workshopInfo;
  late List appointments;
  bool gotPath = false;
  Map selectedList = {};
  // _ClientBookingState({required this.workshopInfo});

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workshopInfo = widget.workshopInfo;
    _asyncMethod();
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
      return const Scaffold(
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
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateSelected: (date) {
                // setState(() {
                selectedDate = date;
                (context as Element).reassemble();
                // (context as Element)
                // });
              },
              leftMargin: 20,
              monthColor: Colors.white,
              dayColor: Colors.white,
              activeDayColor: Colors.pink,
              activeBackgroundDayColor: Colors.white,
              dotsColor: const Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green[800],
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Available'),
              const SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red[800],
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Booked'),
              const SizedBox(
                width: 10,
              ),
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Selected'),
            ],
          ),
          const SizedBox(
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
                  bookAppointment(key, widget.selectedServices);
                });
                // wait for 2 seconds to execute
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Home(
                              index: 2,
                            )),
                  );
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Center(
                          child: Text('No appointments selected'),
                        ),
                        content: const Text(
                            'Please select a slot to book an appointment'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]);
                  },
                );
              }
            },
          ),
        ]),
      );
    }
  }

  Widget buildAppointmentList(List appointments) {
    List dayAppointments = [];
    Map allDayAppointments = {};
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedNow = formatter.format(selectedDate);
    for (var i = 0; i < appointments.length; i++) {
      var appointmentDate = DateTime.fromMillisecondsSinceEpoch(
          appointments[i]['datetime'].seconds * 1000);
      String formattedAppointmentDate = formatter.format(appointmentDate);
      if (formattedAppointmentDate == formattedNow) {
        if (appointmentDate.isAfter(DateTime.now())) {
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
      return const Center(
        child: Text('No appointments available',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
            )),
      );
    }
    dayAppointments.sort((a, b) => a['datetime'].compareTo(b['datetime']));
    return Expanded(
      child: GridView.builder(
        itemCount: dayAppointments.length,
        itemBuilder: (context, index) {
          return buildAppointmentCard(dayAppointments[index]);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
        ),
      ),
    );
  }

  BookingSlot buildAppointmentCard(appointment) {
    String status = appointment['status'];
    var timestamp = appointment['datetime'];
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

    var dateFormatted = DateFormat.jm().format(DateTime.parse(date.toString()));

    return BookingSlot(
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
          dateFormatted,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
