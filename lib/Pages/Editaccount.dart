import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';


class Editaccount extends StatefulWidget {
  const Editaccount({Key? key}) : super(key: key);

  @override
  State<Editaccount> createState() => _EditaccountState();
}

//FirebaseFirestore.instance.collection('clients').doc(email).get();

class _EditaccountState extends State<Editaccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late var name;
  late var emaill;
  late var phone;
  late var city;
  var n;
  var e;
  var p;
  var c;
  bool gotPath = false;
  
Future _getData() async {
    final User user = await _auth.currentUser!;
    final client = await _firestore.collection('clients').doc(user!.email).get();
    setState(() {
      name = client['name'];
      emaill=user!.email;
      phone=client['phoneNumber'];
      city=client['city'];
      gotPath = true;
    });
  }
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {

_getData();


if (!gotPath){
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(),
      ),
    );
  }
  else{
    return Scaffold(
    appBar: AppBar(title: const Text('Edit Account'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),),

    body: Center(child: Container(padding:const EdgeInsets.all(50) ,
      child: Form(key: _formKey,child: Column(children: <Widget>[
                    const Text('Name'),
                    //inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(17)],validator: (value) {if (value == null || value.isEmpty ) {return 'Please enter VIN Number';}return null;},
                    TextFormField(onChanged:(value) => n=value,initialValue: name,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(contentPadding: EdgeInsets.zero,hintText: name),),
                    const SizedBox(height: 20,),
                    const Text('Email'),
                    TextFormField(onChanged: (value) => e=value,initialValue: emaill,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(hintText: emaill),),
                    const SizedBox(height: 20,),
                    const Text('Phone'),
                    TextFormField(onChanged: (value) => p=value,initialValue:phone,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(hintText: phone)),
                    const SizedBox(height: 20,),
                    const Text('City'),
                    TextFormField(onChanged: (value) => c=value,initialValue:city,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(hintText: city)),
                    const SizedBox(height: 20,),
                    ElevatedButton.icon(onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        
                        // delete this
                        print(e);print(p);print(n);print(c);print('========');
                        
                        if(e==null){e=emaill;}if(p==null){p=phone;}if(n==null){n=name;}if(c==null){c=city;}
                        FirebaseFirestore.instance.collection('clients').doc(emaill).update({
                          'email': e,
                          'phoneNumber': p,
                          'name': n,
                          'city': c,
                        });

                        // delete this
                        print(e);print(p);print(n);print(c);print('========');
                        
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')),);
                        Future.delayed(Duration(seconds: 1),() => Navigator.pop(context),);
                        
                          }},
                          icon: const Icon(Icons.save_as,), label: const Text('Edit'),)
          
                  ],
        ),
        ),
    )),

    );
    
  }
  }
}