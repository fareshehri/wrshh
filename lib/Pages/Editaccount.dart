import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class Editaccount extends StatefulWidget {
  const Editaccount({Key? key}) : super(key: key);

  @override
  State<Editaccount> createState() => _EditaccountState();
}
var name;
var email;
var phoneNumber;
var city;
var car;
var uid;

class _EditaccountState extends State<Editaccount> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Edit Account'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),),

    body: Center(child: Container(padding:EdgeInsets.all(50) ,
      child: Form(key: _formKey,child: Column(children: <Widget>[
                    Text('Name'),
                    TextFormField(decoration: const InputDecoration(contentPadding: EdgeInsets.zero),inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(17)],validator: (value) {if (value == null || value.isEmpty ) {return 'Please enter VIN Number';}return null;},),
                    SizedBox(height: 20,),
                    Text('Email'),
                    TextFormField(),
                    SizedBox(height: 20,),
                    Text('Phone'),
                    TextFormField(),
                    SizedBox(height: 20,),
                    Text('City'),
                    TextFormField(),
                    SizedBox(height: 20,),
                    Text('Car'),
                    TextFormField(),
                    SizedBox(height: 20,),
                    ElevatedButton.icon(onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),);}},
                          icon: const Icon(Icons.save_as,), label: const Text('Edit'),)
          
                  ],
        ),
        ),
    )),

    );
    
  }
}