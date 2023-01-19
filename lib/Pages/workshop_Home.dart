import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wrshh/Pages/Account.dart';
import 'package:wrshh/Pages/welcome.dart';

import '../Services/Auth/auth.dart';
// import 'W_UpdatePage/break_Hours.dart';
// import 'W_UpdatePage/capacity.dart';
// import 'W_UpdatePage/services.dart';
// import 'W_UpdatePage/working_Dates.dart';
// import 'W_UpdatePage/working_Hours.dart';
import 'W_UpdatePage/WorkShop_Updates.dart';
import 'W_UpdatePage/update_schedule.dart';

class WHome extends StatefulWidget {
  static const String id = 'Workshop_Home';
  const WHome({Key? key}) : super(key: key);

  @override
  State<WHome> createState() => _WHomeState();
}

class _WHomeState extends State<WHome> {
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
  var titlename = ['Upcoming Maintenance', 'Create Booking', 'Update Schedule'];

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
              title: const Text('Account'),
              onTap: () {
                setState(() {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(MaterialPageRoute(
                    builder: (BuildContext context) => const Account(),
                  ));
                });
              },
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
              return SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(padding: const EdgeInsets.all(8), children: [
                  SizedBox(
                      child: Image.asset(
                    'assets/images/wallpaper3.jpg',
                    fit: BoxFit.contain,
                  )),
                ]),
              );
            }

            if (_selectedIndex == 1) {
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(17)
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter VIN Number';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                      ),
                      label: const Text('Search'),
                    )
                  ],
                ),
              );
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
              label: 'Upcoming Maintainance',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Create Booking',
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
