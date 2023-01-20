import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';


final DateFormat formatter = DateFormat('yyyy-MM-dd');

class ReportPage extends StatefulWidget {
  final String vin;
  final String Wid;
  const ReportPage({Key? key,required this.vin, required this.Wid}) : super(key: key);

  @override
  State<ReportPage> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String selectedDate = formatter.format(DateTime.now());
  //DateTime selectedDate = DateTime.now();
  final myController = TextEditingController(text:formatter.format(DateTime.now()));
  late var finalfile;
  late var uploadfile;
  late var extFile;
  bool gotFile=false;
  bool gotPath = true;
  bool gotExt = true;


    var mileage;
  
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    
    var vin = widget.vin;//vin number
    var wid = widget.vin;//workshop id

    Widget cancelButton = TextButton(child: Text("No"),onPressed:  () {Navigator.pop(context);},);
    Widget continueButton = TextButton(child: Text("Yes"),onPressed:  ()async {
                          // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      try {
                        if(gotFile==true){
                        print('Looking for Folder');
      final ref = FirebaseStorage.instance.ref().child('Reports').child(vin.toString()).child(mileage+'.'+extFile);
      print('Loading the file');
      //Mobile Check This
      if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){await ref.putFile(File(finalfile));}
      //Web
      else{await ref.putData(uploadfile);}
      
      final url = await ref.getDownloadURL();
      print('Saving the Url');
          _firestore.collection('vin').doc(vin).update(
            {
              'history': url,
            },
          ).onError((error, stackTrace) => null);
        
       print('Done');
    }

    } catch (e) {
      print(e);
    }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report uploaded successfully')),);
                        Future.delayed(Duration(seconds: 1),() => Navigator.pop(context),);
                        
      
      
    });
      

    AlertDialog alert = AlertDialog(title: Text("Confirmation"),
    content: Text("Is the maintenance information correct?"),
    actions: [
      cancelButton,
      continueButton,
    ],);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = formatter.format(picked);
        myController.text=selectedDate.toString();

      });
    }
    }
    if (!gotPath){
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(),
      ),
    );
  }

//when values are stored
  else{
        return Scaffold(
     appBar: AppBar(title: Text('Report'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),)
     ,
     body: Container(margin: EdgeInsets.fromLTRB(25,50,25,50),
       child: ListView(children: [
        Container(
          child: Form(key: _formKey,child: Column(children: <Widget>[
              TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Vin Number'),border: OutlineInputBorder(),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              
              const SizedBox(height: 20,),

              //TextFormField(controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),icon:IconButton(icon:Icon(Icons.calendar_month_outlined,),onPressed:() => _selectDate(context) , ),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              //TextFormField(onTap: () => _selectDate(context),controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),suffixIcon:Icon(Icons.calendar_month_outlined,),contentPadding: EdgeInsets.zero),),
              
              TextFormField(onChanged:(value) => mileage=value,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Mileage'),border: OutlineInputBorder(),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2),hintText: 'Enter Mileage'
              ),
              validator: (value) {
                    if (value == null || value.isEmpty ) {return 'Please enter Mileage Details';}
                    return null;
                    }
              ,inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly  ],
),
              
              const SizedBox(height: 20,),


              const Text('Details'),
              TextFormField(maxLines: 6,decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Enter Maintenance Details'),validator: (value) {
                    if (value == null || value.isEmpty ) {return 'Please enter Maintenance Details';}
                    return null;
                    },),
              const SizedBox(height: 20,),

              const Text('Upload'),
              //TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(border: OutlineInputBorder(),hintText: vin,contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              ElevatedButton(onPressed: () async{
                result = await FilePicker.platform.pickFiles(allowMultiple: false ,type: FileType.custom,allowedExtensions: ['pdf','doc','docx']);
                      if (result == null) {
                          print("No file selected");
                          gotFile=false;
                        } else {
                        PlatformFile file = result!.files.single;
                        if(file.extension=='pdf'||file.extension=='docx'||file.extension=='doc'){
                          gotExt=true;
                          print(file.name);
                          //do something here to upload to firestore
                          setState(() {
                            if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){finalfile=result!.files.single.path;}
                            else{uploadfile = result?.files.single.bytes;}
                            extFile=file.extension;
                            gotFile=true;

                        });
                          }
                        else{
                          gotExt=false;
                          gotFile=false;
                          print("Incorrect Extension");
                        }
                        }
              }, child: const Text("File Picker"),),
              
              const SizedBox(height: 20,),
              const SizedBox(height: 20,),
              ElevatedButton.icon(onPressed: () async {
                    //in try we want to change the car to registered car 
                    //in catch we will add a new car to database
                    try {
                      //final x = await FirebaseFirestore.instance.collection('vin').doc(_vin).get();
                    if(gotExt==false){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The file Extension is incorrect')),);
                      }
                      else{
                        if (_formKey.currentState!.validate()) {
                      showDialog(context: context,builder: (BuildContext context) {return alert;},
                      );}
                      }
                    } catch (e) {
                        print(e);
                    }
                    },
                        icon: Icon(Icons.save), label: Text('Save'),)
                    
                    
                    ])
                    
          ),
        )
       ])
     )
        );
  }
  }
}