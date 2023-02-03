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
  var carsserial;

  //set values
  var ob = "";
  var oc = "";
  String _selectedB = 'Chevrolet';
  String _selectedC = 'Groove';
  var _serial;
  var _currentSelectedYear = 2023;

  //set views
  var viscar = true;
  var visin = false;
  bool gotPath = false;

//Get data from firestore
  Future _getData() async {
    final client = await getUserInfo();
    setState(() {
      name = client!['name'];
      carsserial = client['serial'];
      email = client['email'];
    });
    await _getCar();
  }

//Get data from firestore
  Future _getCar() async {
    if (carsserial != "") {
      serialExists = true;
      title = "Change Car";
      welcomeMsg = "Hello $name, Here is your car information ($carsserial)";
      final serial =
          await getCarInfoBySerial(carsserial); //get car info by serial
      setState(() {
        _selectedB = serial!['carManufacturer'];
        _selectedC = serial['carModel'];
        _currentSelectedYear = int.parse(serial['carYear']);
        ob = serial['otherBrand'];
        oc = serial['otherCar'];
        _serial = carsserial;
        gotPath = true;
        if (_selectedB == 'Other') {
          viscar = false;
          visin = true;
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
          // If the form is valid, display a snackbar. In the real world,
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

//wait for values from firestore
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

//when values are stored
    else {
      //set inital dropdown values
      var _selectbrand = cars.keys;
      var _selectcar = cars[_selectedB];

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
              margin: EdgeInsets.fromLTRB(25, 50, 25, 50),
              child: ListView(children: [
                Text(
                  welcomeMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: serialExists,
                  child: Container(
                    padding: EdgeInsets.all(10),
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
                        SizedBox(
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
                SizedBox(
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
                                items: _selectbrand
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
                                      viscar = false;
                                      visin = true;
                                      _selectedB = val.toString();
                                    } else {
                                      viscar = true;
                                      visin = false;
                                    }
                                  });
                                }),
                          ),
                        ],
                      ),

                      //select car
                      //if car brand is chosen
                      Visibility(
                        visible: viscar,
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
                                  items: _selectcar!
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
                          visible: visin,
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
                                          child: Text(map.toString()),
                                          value: map),
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

                      SizedBox(
                        height: 20,
                      ),

                      //get stored serial number ( carsserial ) and updated when changed with new serial number ( _serial )
                      TextFormField(
                        initialValue: carsserial,
                        onChanged: (value) => _serial = value,
                        decoration: kTextFieldDecoratopn.copyWith(
                            hintText: 'Car Serial Number',
                            labelText: 'Car Serial Number'),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                  // If the form is valid, display a snackbar. In the real world,
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
