import 'package:wrshh/Pages/guest/welcome.dart';
import 'package:wrshh/Services/Auth/auth.dart';
import 'package:wrshh/Services/Maps/google_maps_part.dart';
import 'package:wrshh/Pages/client/Account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../Services/Auth/client_database.dart';
import '../../components/build_cards.dart';
import '../../constants.dart';
import 'client_appointments.dart';

class Home extends StatefulWidget {
  static const String id = 'Home_screen';
  final int index;
  const Home({Key? key, this.index = 0}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//serial
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

  bool serialChecker = false;

  var titlename = ['Home', 'Maintenance', 'Bookings'];

  late Map appointments = {};
  var serial = '';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w400);
  int _selectedIndex = 0;

//date picker
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index;
    super.initState();
  }

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
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const WelcomeScreen()), (Route<dynamic> route) => false);
                });
              },
            )
          ],
        )),
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
                    'assets/images/wallpaper.jpg',
                    fit: BoxFit.contain,
                  )),
                  // const SizedBox(height: 1,),
                  // SizedBox(child: Image.asset('images/wallpaper2.jpg',fit: BoxFit.contain,)),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: kTextFieldDecoratopn.copyWith(
                              hintText: 'Enter any serial number',
                              labelText: 'Serial number',
                              prefixIcon: const Icon(Icons.search)),
                          maxLength: 9,
                          onChanged: (val) {
                            setState(() {
                              serial = val;
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(9),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Serial Number';
                            } else if (value.length < 9 || value.length > 10) {
                              return 'Please enter a valid Serial Number';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              // FIX Change getAppointmentsByVIN to getAppointmentsBySerial
                              Map appointmentsDB =
                                  await getAppointmentsBySerial(serial);
                              setState(() {
                                if (appointmentsDB.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                            title: Text(
                                                'Serial Number Don\'t Exist in Our Database'),
                                            icon: Icon(Icons.warning),
                                            iconColor: Colors.red);
                                      });
                                  serialChecker = false;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                  appointments = appointmentsDB;
                                  serialChecker = true;
                                }
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                          ),
                          label: const Text('Search'),
                        )
                        // Delete This please
                        ,
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: serialChecker,
                          child: Column(
                            children: buildAppointmentsCards(
                                appointments, 'HistorySerial'),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              );
            }

            if (_selectedIndex == 1) {
              return const MyGoogleMaps();
            } else {
              return const ClientAppointments();
            }
          },
        )),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: bbcolor[_selectedIndex],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Maintenance',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Bookings',
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
