import 'package:flutter/material.dart';
import '../../Services/Auth/auth.dart';

class Services extends StatefulWidget {
   const Services({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Services();
  }
}

class _Services extends State<Services> {

  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  // The controller for the text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // The data for the objects
  late List<Map<String, String>> _objects;
  bool gotPath = false;
  late List<Map<String, String>> xx = [];

  Future call() async {
    final serv = await AuthService().getServices();
    setState(() {
      List ser = serv['ser'] as List;
      List pri = serv['pri'] as List;

      for (int i=0; i< ser.length; i++){
        Map<String, String> temp = {ser[i].toString():pri[i].toString()};
        xx.add(temp);
        _objects = xx;
      }
      gotPath = true;
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
      return Scaffold(
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

        body: ListView.builder(
          itemCount: _objects.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, String> object = _objects[index];
            return ListTile(
              title: Text(object.keys.join(', ')),
              subtitle: Text(object.values.join(', ')),
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
                        _nameController.text =object.keys.join(', ');
                        _priceController.text = object.values.join(', ');
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
                                  List keys = _objects[index].keys.toList();
                                  List values = _objects[index].values.toList();

                                  keys[0] = _nameController.text;
                                  values[0] = _priceController.text;
                                  Map<String, String> temp = {keys[0]:values[0]};
                                  _objects[index] = temp;
                                  Map<String, String> temp2 = {};
                                  for (int i=0; i<_objects.length; i++) {
                                    temp2.addAll(_objects[i]);
                                  }
                                  object = temp2;

                                  List tempSer = object.keys.toList();
                                  List tempPri = object.values.toList();
                                  AuthService().updateServices(tempSer, tempPri);
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
                      Map<String, String> temp = {};
                      _objects.removeAt(index);
                      for (int i=0; i<_objects.length; i++) {
                        temp = _objects[i];
                      }
                      object = temp;

                      List tempSer = object.keys.toList();
                      List tempPri = object.values.toList();
                      AuthService().updateServices(tempSer, tempPri);
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
                          _objects.add({_nameController.text: _priceController.text});
                          Map<String, String> object = {};
                          for (var temp in _objects) {
                            object.addAll(temp);
                          }
                          List tempSer = object.keys.toList();
                          List tempPri = object.values.toList();
                          AuthService().updateServices(tempSer, tempPri);
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
