
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

// Data class for the cards
class CardData {
  late final String title;
  late final String subtitle;

  CardData({required this.title, required this.subtitle});
}

class UpdateSch extends StatefulWidget {
   const UpdateSch({Key? key}) : super(key: key);

  @override
  State<UpdateSch> createState() => UpdateScheduleSec();

}

class UpdateScheduleSec extends State<UpdateSch> {

  // The data for the objects
  List<Map<String, dynamic>> _objects = [
    {'name': 'Object 1', 'price': 100},
    {'name': 'Object 2', 'price': 200},
    {'name': 'Object 3', 'price': 300},
  ];

  // The controller for the text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
      itemCount: _objects.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> object = _objects[index];
        return ListTile(
          title: Text(object['name']),
          subtitle: Text(object['price'].toString()),
          trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) => [
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
                              _objects[index]['name'] = _nameController.text;
                              _objects[index]['price'] = int.parse(_priceController.text);
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
              } else if (value == 'delete') {
                // Remove the selected object from the list
                setState(() {
                  _objects.removeAt(index);
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
