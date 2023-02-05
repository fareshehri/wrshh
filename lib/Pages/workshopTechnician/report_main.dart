// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class ReportPage1 extends StatefulWidget {
  final String vin;
  final String wid;
  const ReportPage1({Key? key, required this.vin, required this.wid})
      : super(key: key);

  @override
  State<ReportPage1> createState() => ReportPage1State();
}

class ReportPage1State extends State<ReportPage1> {
  final fireStore = FirebaseFirestore.instance;
  String selectedDate = formatter.format(DateTime.now());
  //DateTime selectedDate = DateTime.now();
  final myController =
      TextEditingController(text: formatter.format(DateTime.now()));
  late String finalFile;
  late Uint8List uploadFile;
  late var exitFile;
  bool gotFile = false;
  bool gotPath = true;
  bool gotExt = true;

  late String mileage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var vin = widget.vin; //vin number

    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: const Text("Yes"),
        onPressed: () async {
          // If the form is valid, display a snackBar. In the real world,
          // you'd often call a server or save the information in a database.
          try {
            if (gotFile == true) {
              // print('Looking for Folder');
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('Reports')
                  .child(vin.toString())
                  .child('$mileage. + $exitFile');
              // print('Loading the file');
              //Mobile Check This
              if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android) {
                await ref.putFile(File(finalFile));
              }
              //Web
              else {
                await ref.putData(uploadFile);
              }

              final url = await ref.getDownloadURL();
              // print('Saving the Url');
              fireStore.collection('vin').doc(vin).update(
                {
                  'history': url,
                },
              ).onError((error, stackTrace) => null);

              // print('Done');
            }
          } catch (e) {
            // print(e);
          }

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report uploaded successfully')),
          );
          Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.pop(context),
          );
        });

    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Is the maintenance information correct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

//when values are stored
    else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Report'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
          ),
          body: Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 50),
              child: ListView(children: [
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        readOnly: true,
                        initialValue: vin,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            label: Text('Vin Number'),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //TextFormField(controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),icon:IconButton(icon:Icon(Icons.calendar_month_outlined,),onPressed:() => _selectDate(context) , ),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
                      //TextFormField(onTap: () => _selectDate(context),controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),suffixIcon:Icon(Icons.calendar_month_outlined,),contentPadding: EdgeInsets.zero),),

                      TextFormField(
                        onChanged: (value) => mileage = value,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            label: Text('Mileage'),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                            hintText: 'Enter Mileage'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Mileage Details';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text('Details'),
                      TextFormField(
                        maxLines: 6,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Maintenance Details'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Maintenance Details';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(border: OutlineInputBorder(),hintText: vin,contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
                      // ElevatedButton(onPressed: () async{
                      //   result = await FilePicker.platform.pickFiles(allowMultiple: false ,type: FileType.custom,allowedExtensions: ['pdf',]);
                      //         if (result == null) {
                      //             print("No file selected");
                      //             gotFile=false;
                      //           } else {
                      //           PlatformFile file = result!.files.single;
                      //           if(file.extension=='pdf'){
                      //             gotExt=true;
                      //             print(file.name);
                      //             //do something here to upload to fireStore
                      //             setState(() {
                      //               if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){finalFile=result!.files.single.path;}
                      //               else{uploadFile = result?.files.single.bytes;}
                      //               extFile=file.extension;
                      //               gotFile=true;

                      //           });
                      //             }
                      //           else{
                      //             gotExt=false;
                      //             gotFile=false;
                      //             print("Incorrect Extension");
                      //              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The file Extension is incorrect')),);
                      //           }
                      //           }
                      // }, child: const Text("File Picker"),),

                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              //Navigator.of(context,rootNavigator: true,).push(MaterialPageRoute(builder: (BuildContext context) => const CreatePdf(Wid:"btest6w@gmail.com")));
                            });
                          },
                          icon: const Icon(Icons.abc),
                          label: const Text('h')),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          //in try we want to change the car to registered car
                          //in catch we will add a new car to database
                          try {
                            //final x = await FirebaseFireStore.instance.collection('vin').doc(_vin).get();
                            if (gotExt == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'The file Extension is incorrect')),
                              );
                            } else {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }
                            }
                          } catch (e) {
                            // print(e);
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      )
                    ]))
              ])));
    }
  }
}
