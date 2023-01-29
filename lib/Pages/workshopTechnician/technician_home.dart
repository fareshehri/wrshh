import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wrshh/Pages/guest/welcome.dart';
import 'package:wrshh/Pages/workshopAdmin/update_schedule.dart';
import 'package:wrshh/Pages/workshopTechnician/view_appointments.dart';

import '../../Services/Auth/auth.dart';
import '../../components/Calendar_Timeline.dart';
import 'make_invoice.dart';

class WorkshopTechnicianHome extends StatefulWidget {
  static const String id = 'WorkshopTechnicianHome';
  const WorkshopTechnicianHome({Key? key}) : super(key: key);

  @override
  State<WorkshopTechnicianHome> createState() => _WorkshopTechnicianHomeState();
}

class _WorkshopTechnicianHomeState extends State<WorkshopTechnicianHome> {
  //vin
  final _formKey = GlobalKey<FormState>();
  //styles
  var tc = [
    Colors.red[400],
    Colors.green[400],
    Colors.blue[400],
    Colors.orange[400]
  ];
  var buttoncolor = [
    Colors.red[300],
    Colors.green[300],
    Colors.blue[300],
    Colors.orange[300]
  ];
  //var bbcolor= [Colors.orange[300],Colors.blue[300],Colors.green[300],Colors.red[300]];
  var bbcolor = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];
  var titlename = ['View Appointments', 'Make Invoice', 'Update Schedule'];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w400);
  int _selectedIndex = 0;

//date picker
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              hoverColor: tc[_selectedIndex],
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Services'),
              onTap: () {},
            ),
            ListTile(
              hoverColor: tc[_selectedIndex],
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                AuthService().logOut();
                setState(() {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen(),
                  ));
                });
              },
            )
          ],
        )),
        //AB:
        //appBar: AppBar(title: Text('Home'),centerTitle: true,backgroundColor:bbcolor[_selectedIndex],) ,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: buttoncolor[_selectedIndex]),
          actionsIconTheme:
              IconThemeData(color: buttoncolor[_selectedIndex], size: 24),
          title: Text(
            titlename[_selectedIndex],
            style: optionStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
        ),

        body: Center(
            child: FutureBuilder(
          initialData: _selectedIndex,
          builder: (context, snapshot) {
            if (_selectedIndex == 0) {
              //Main PAGE after listview try padding: EdgeInsets.all(8)
              return ViewAppoinments();
            }

            if (_selectedIndex == 1) {
              return MakeInvoice();
            } else {
              return UpdateSchedule();
            }
          },
        )),

        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: bbcolor[_selectedIndex],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.upcoming),
              label: 'View Appointments',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Make Invoice',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar),
              label: 'Update Schedule',
              backgroundColor: Colors.blue,
            ),
          ],

          //CI: This will see the button clicked index ex(Home will set index to 0) important on changing the content
          currentIndex: _selectedIndex,
          selectedItemColor: buttoncolor[_selectedIndex],
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
    });
  }
}
