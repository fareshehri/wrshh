// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Services/Auth/client_database.dart';
import '../../constants.dart';
import 'cars_info.dart';

class EditCarInfo extends StatefulWidget {
  const EditCarInfo({Key? key}) : super(key: key);

  @override
  State<EditCarInfo> createState() => _EditCarInfoState();
}

class _EditCarInfoState extends State<EditCarInfo> {
  late String title;
  late String welcomeMsg;
  bool serialExists = false;
  //get data
  late String name;
  late String email;
  late String carSerial;

  //set values
  var ob = "";
  var oc = "";
  String _selectedB = 'Chevrolet';
  String _selectedC = 'Groove';
  late String _serial;
  var _currentSelectedYear = 2023;

  //set views
  var visCar = true;
  var visIn = false;
  bool gotPath = false;

//Get data from fireStore
  Future _getData() async {
    final client = await getUserInfo();
    setState(() {
      name = client!['name'];
      carSerial = client['serial'];
      email = client['email'];
    });
    await _getCar();
  }

//Get data from fireStore
  Future _getCar() async {
    if (carSerial != "") {
      serialExists = true;
      title = "Change Car";
      welcomeMsg = "Hello $name, Here is your car information ($carSerial)";
      final serial =
          await getCarInfoBySerial(carSerial); //get car info by serial
      setState(() {
        _selectedB = serial!['carManufacturer'];
        _selectedC = serial['carModel'];
        _currentSelectedYear = int.parse(serial['carYear']);
        ob = serial['otherBrand'];
        oc = serial['otherCar'];
        _serial = carSerial;
        gotPath = true;
        if (_selectedB == 'Other') {
          visCar = false;
          visIn = true;
        }
      });
    } else {
      title = "Add Car Information";
      welcomeMsg = "Hello $name, Please add your car information";
      setState(() {
        gotPath = true;
      });
    }
  }

  //car info validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        //add to db
        if (_formKey.currentState!.validate()) {
          //if brand is chosen clear ob
          if (_selectedB != 'Other') {
            ob = "";
            oc = "";
          }
          Map<String, String> saved = {
            'carManufacturer': _selectedB,
            'carModel': _selectedC,
            'carYear': _currentSelectedYear.toString(),
            'otherBrand': ob,
            'otherCar': oc,
          };
          FirebaseFirestore.instance
              .collection('serial')
              .doc(_serial)
              .set(saved);
          FirebaseFirestore.instance
              .collection('clients')
              .doc(email)
              .update({'serial': _serial});
          // If the form is valid, display a snackBar. In the real world,
          // you'd often call a server or save the information in a database.
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
          Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.pop(context),
          );
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Is the vehicle information correct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //dropdown fill
    List<int> year = [for (var i = 1960; i <= 2023; i++) i];

//wait for values from fireStore
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

//when values are stored
    else {
      //set initial dropdown values
      var selectBrand = cars.keys;
      var selectCar = cars[_selectedB];

      return Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
          ),
          body: Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 50),
              child: ListView(children: [
                Text(
                  welcomeMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: serialExists,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red[700],
                          size: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const Text(
                            "You can't change it but you can add another car information",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //select brand
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Car Brand',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                                menuMaxHeight: 200,
                                value: _selectedB,
                                borderRadius: BorderRadius.circular(16),
                                items: selectBrand
                                    .map(
                                      (map) => DropdownMenuItem(
                                          value: map, child: Text(map)),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    //set first dropdown
                                    _selectedB = val.toString();
                                    //set final based on first dropdown
                                    //set second dropdown
                                    _selectedC = cars[_selectedB]!.first;
                                    //set final based on second dropdown
                                    //change views
                                    if (_selectedB == "Other") {
                                      visCar = false;
                                      visIn = true;
                                      _selectedB = val.toString();
                                    } else {
                                      visCar = true;
                                      visIn = false;
                                    }
                                  });
                                }),
                          ),
                        ],
                      ),

                      //select car
                      //if car brand is chosen
                      Visibility(
                        visible: visCar,
                        child: Row(
                          children: [
                            const Text('Car Model',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DropdownButton(
                                  menuMaxHeight: 200,
                                  borderRadius: BorderRadius.circular(16),
                                  value: _selectedC,
                                  items: selectCar!
                                      .map(
                                        (map) => DropdownMenuItem(
                                            value: map, child: Text(map)),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      //set second dropdown
                                      _selectedC = val.toString();
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),

                      //if Other is chosen
                      Visibility(
                          visible: visIn,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: kTextFieldDecoratopn.copyWith(
                                    hintText: 'Enter Car Brand',
                                    labelText: 'Car Brand'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a car brand';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    ob = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                decoration: kTextFieldDecoratopn.copyWith(
                                    hintText: 'Enter Car Model',
                                    labelText: 'Car Model'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a car model';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    oc = value;
                                  });
                                },
                              ),
                            ],
                          )),

                      //Year Of Make Selection
                      Row(
                        children: [
                          const Text('Year Of Make',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                                borderRadius: BorderRadius.circular(16),
                                menuMaxHeight: 200,
                                value: _currentSelectedYear,
                                items: year
                                    .map(
                                      (map) => DropdownMenuItem(
                                          value: map,
                                          child: Text(map.toString())),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _currentSelectedYear = val as int;
                                  });
                                }),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //get stored serial number ( carSerial ) and updated when changed with new serial number ( _serial )
                      TextFormField(
                        initialValue: carSerial,
                        onChanged: (value) => _serial = value,
                        decoration: kTextFieldDecoratopn.copyWith(
                            hintText: 'Car Serial Number',
                            labelText: 'Car Serial Number'),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 9,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 9) {
                            return 'Please enter Serial Number';
                          }
                          return null;
                        },
                      ),

                      ElevatedButton.icon(
                        onPressed: () async {
                          //in try we want to change the car to registered car
                          //in catch we will add a new car to database
                          try {
                            bool isBooked = await checkFutureAppointment();
                            if (isBooked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You can not change your car because you have an appointment')));
                            } else {
                              final x = await FirebaseFirestore.instance
                                  .collection('serial')
                                  .doc(_serial)
                                  .get();

                              if (x.exists &&
                                  (x['carModel'] != _selectedC ||
                                      x['carManufacturer'] != _selectedB ||
                                      x['otherBrand'] != ob ||
                                      x['otherCar'] != oc)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'The serial is already registered and the data is not matching or please contact us')),
                                );
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  //if brand is chosen clear ob
                                  if (_selectedB != 'Other') {
                                    ob = "";
                                    oc = "";
                                  }
                                  Map<String, String> saved = {
                                    'carManufacturer': _selectedB,
                                    'carModel': _selectedC,
                                    'carYear': _currentSelectedYear.toString(),
                                    'otherBrand': ob,
                                    'otherCar': oc,
                                  };
                                  FirebaseFirestore.instance
                                      .collection('serial')
                                      .doc(_serial)
                                      .set(saved);
                                  FirebaseFirestore.instance
                                      .collection('clients')
                                      .doc(email)
                                      .update({'serial': _serial});
                                  // If the form is valid, display a snackBar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Car Changed')),
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () => Navigator.pop(context),
                                  );
                                }
                              }
                            }
                          } catch (e) {
                            //show add car confirmation
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }

                          // Validate returns true if the form is valid, or false otherwise.
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      )
                    ],
                  ),
                )
              ])));
    }
  }
}
