// ignore_for_file: file_names

import 'package:wrshh/Pages/Newcar.dart';
import 'package:flutter/material.dart';



class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: const Text('Account'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),)
     ,
     body: Container(margin: const EdgeInsets.fromLTRB(25,50,25,50),
       child: ListView(children: [
        ListTile(leading: Icon(Icons.car_rental,color: Colors.pink[400]),title: const Text('Add Car'),subtitle: const Text('Here you can save your Car Info'),trailing: const Icon(Icons.arrow_forward),hoverColor:Colors.lightBlue[300] ,iconColor: Colors.black,onTap: () {
          setState(() {Navigator.of(context,rootNavigator: true,).push(MaterialPageRoute(builder: (BuildContext context) => const Newcar()));});})   
     ,
        ListTile(leading: Icon(Icons.note_alt,color: Colors.pink[400]),title: const Text('Edit Account'),subtitle: const Text('Here you can edit your Account Info'),trailing: const Icon(Icons.arrow_forward),hoverColor:Colors.lightBlue[300] ,iconColor: Colors.black,onTap: () {
          
        },),
       ],
    ),
     ));
    }
    }