
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
   const Services({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Services();
  }

}

class _Services extends State<Services> {

  // static const dark = Color(0xFF333A47);
  // static const double leftPadding = 9;

  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Text("Services"),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        foregroundColor:Colors.black,
        elevation: 0,
        iconTheme:IconThemeData(
            color: Colors.lightBlue[300],size: 24
        ),
      ),

      body: const UpdateSch()
    );
  }
}


class UpdateSch extends StatefulWidget {
   const UpdateSch({Key? key}) : super(key: key);

  @override
  State<UpdateSch> createState() => UpdateScheduleSec();

}

class UpdateScheduleSec extends State<UpdateSch> {

  bool gotPath = false;

  // The data for the objects
  late List<Map<String, dynamic>> _objects;

  // The controller for the text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var s;
  Future call() async {
    final User user = _auth.currentUser!;
    final ser = await _firestore.collection('workshops').doc('1XWv9DLGRETIgbzzhGzO').get();
    setState(() {
      print(ser['services']);
      s = ser['services'] as List<Map<String, dynamic>>;
      // temp = ser['services'] as Map<String, dynamic>;
      print(s);
      // _objects.add(s as Map<String, dynamic>);
      _objects = s;
      print(s);
      // var a = '["one", "two", "three", "four"]';
      // var ab = json.decode(temp).cast<String>().toList();
      // print(ab);
      // print(ab[1]);
    });
    // _objects = ser['services'] as List<Map<String, dynamic>>;
    // final ser = await _firestore.collection('workshops').where(
    //     'adminEmail', isEqualTo: user.email).get().then((value) {
    //   value.docs.forEach((element) {
    //     s = _firestore.collection('workshops').doc(element.id).get();
    //     _objects = s['services'] as List<Map<String, dynamic>>;
    //   });
    //   //.doc(user.email).get();
    //
    //   // _objects = s['services'] as List<Map<String, dynamic>>;
    // });
    gotPath = true;
  }

  @override
  void initState() {
    call();
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        body: ListView.builder(
          itemCount: _objects.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> object = _objects[index];
            return ListTile(
              title: Text(object['name']),
              subtitle: Text(object['price'].toString()),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) =>
                [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) {
                  // Edit or delete the selected object
                  if (value == 'edit') {
                    // Show the modal bottom sheet to edit the object
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        // Set the initial value of the text fields to the current name and price
                        _nameController.text = object['name'];
                        _priceController.text = object['price'].toString();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // The form with the text fields
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _priceController,
                                    decoration: const InputDecoration(
                                      labelText: 'Price',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // The save button
                            ElevatedButton(
                              onPressed: () {
                                // Update the name and price of the selected object
                                setState(() {
                                  _objects[index]['name'] =
                                      _nameController.text;
                                  _objects[index]['price'] =
                                      int.parse(_priceController.text);

                                  FirebaseFirestore.instance.collection(
                                      'workshops').doc(user.email).update({
                                    'services': _objects as String
                                  });
                                });
                                // Close the modal bottom sheet
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (value == 'delete') {
                    // Remove the selected object from the list
                    setState(() {
                      _objects.removeAt(index);

                      FirebaseFirestore.instance.collection('workshops').doc(
                          user.email).update({
                        'services': _objects as String
                      });
                    });
                  }
                },
              ),
            );
          },
        ),
        // Add the floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The form with the text fields
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // The save button
                      ElevatedButton(
                        onPressed: () {
                          // Add a new object to the list
                          setState(() {
                            _objects.add({
                              'name': _nameController.text,
                              'price': _priceController.text,
                            });

                            FirebaseFirestore.instance.collection('workshops')
                                .doc(user.email)
                                .update({
                              'services': _objects as String
                            });
                          });
                          // Clear the text fields
                          _nameController.clear();
                          _priceController.clear();
                          // Close the modal bottom sheet
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}
