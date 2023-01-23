import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrshh/constants.dart';
import 'package:flutter/services.dart';

import 'workshop_Home.dart';
import '../../components/roundedButton.dart';
import '../../Services/Auth/db.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Services();
  }
}
class _Services extends State<Services> {

  var bColor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  // The controller for the text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool gotPath = false;

  late LinkedHashMap<String,dynamic> services; /// Services DB Variable
  late LinkedHashMap<String,dynamic> tempServices;
  late int count;

  Future call() async {
    services = await getServices();
    setState(() {
      gotPath = true;
      tempServices = services;

      var temp = tempServices.values.toList();
      for (List list in temp) {
        int length = list.length;
        count = length;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Services"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.lightBlue[300], size: 24
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(tempServices['service'][index]),
                    subtitle: Text(tempServices['price'][index]),
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
                              _nameController.text = tempServices['service'][index];
                              _priceController.text = tempServices['price'][index];
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
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                                        tempServices['service'][index] = _nameController.text;
                                        tempServices['price'][index] = _priceController.text;

                                        _nameController.text = '';
                                        _priceController.text = '';
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
                            tempServices['service'].remove(tempServices['service'][index]);
                            tempServices['price'].remove(int.parse(tempServices['price'][index]));
                            count--;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            RoundedButton(
              title: 'Upload',
              onPressed: () {
                checkAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload Done!'),
                  )
                );
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(MaterialPageRoute(
                  builder: (BuildContext context) => const WHome(),
                ));
              },
              colour: kDarkColor,
            )
          ],
        ),
        // Add the floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _nameController.text = '';
            _priceController.text = '';
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
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
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
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
                          tempServices['service'].add(_nameController.text);
                          tempServices['price'].add(_priceController.text);
                          }
                        );
                        // Clear the text fields
                        _nameController.clear();
                        _priceController.clear();
                        // Close the modal bottom sheet
                        Navigator.pop(context);
                        count++;
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    }
  }

  void checkAll() {
    services = tempServices;
    updateServices(services);
  }
}