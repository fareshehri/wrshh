import 'package:flutter/material.dart';

import '../../Services/Auth/workshop_technician_database.dart';
import '../../components/build_cards.dart';

class MakeInvoice extends StatefulWidget {
  const MakeInvoice({Key? key}) : super(key: key);

  @override
  State<MakeInvoice> createState() => _MakeInvoiceState();
}

class _MakeInvoiceState extends State<MakeInvoice> {
  late Map appointments = {};
  // late List workshops = [];
  late List<Widget> widgets = [];
  @override
  void initState() {
    // TODO: implement initState
    _asyncMethod();
    super.initState();
  }

  _asyncMethod() async {
    var appointmentsDB = await getWorkshopFinishedAppointments();

    setState(() {
      appointments = appointmentsDB;
      widgets = buildAppointmentsCards(appointments, 'WorkshopInvoice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: widgets.isEmpty
                  ? [
                      const Center(
                          child: Text(
                        'No Appointments Found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ))
                    ]
                  : widgets,
            ),
          ),
        ],
      ),
    );
  }
}
