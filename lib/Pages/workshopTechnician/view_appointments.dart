import 'package:flutter/material.dart';

import '../../Services/Auth/workshop_technician_database.dart';
import '../../components/calendar_time_line.dart';
import '../../components/build_cards.dart';

class ViewAppoinments extends StatefulWidget {
  const ViewAppoinments({Key? key}) : super(key: key);

  @override
  State<ViewAppoinments> createState() => _ViewAppoinmentsState();
}

class _ViewAppoinmentsState extends State<ViewAppoinments> {
  DateTime selectedDate = DateTime.now();
  late Map appointments = {};
  bool gotPath = false;
  late List<Widget> widgets = [];
  @override
  void initState() {
    // TODO: implement initState
    _asyncMethod();
    super.initState();
  }

  _asyncMethod() async {
    var appointmentsDB = await getWorkshopAppointmentsByDate(selectedDate);

    setState(() {
      appointments = appointmentsDB;
      widgets = buildAppointmentsCards(appointments, 'Workshop');
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              height: 160,
              width: MediaQuery.of(context).size.width ,
              child: CalendarTimeline(
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now().add(const Duration(days: 7)),
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                    gotPath = false;
                    _asyncMethod();
                  });
                },
                leftMargin: 20,
                monthColor: Colors.pink,
                dayColor: Colors.pink,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.pink,
                dotsColor: const Color(0xFF333A47),
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ),
            )
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: gotPath
                ? ListView(
                    children: widgets.isEmpty
                        ? [
                            const Center(
                                child: Text(
                              'No Appointments Found for this Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey,
                              ),
                            ))
                          ]
                        : widgets,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
