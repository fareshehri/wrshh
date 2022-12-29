
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

      body: UpdateSch()
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

  List<CardData> _cards = [
    CardData(title: 'Check up', subtitle: 'FREE'),
    CardData(title: 'Oil change', subtitle: '120SAR'),
    CardData(title: 'Air Filter change', subtitle: '100SAR'),
  ];

  // The index of the selected card
  late int _selectedCardIndex;

  // The controller for the text field
  TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    CardData card = _cards[index];
                    return Card(
                        child: ListTile(
                            title: Text(card.title),
                            subtitle: Text(card.subtitle),
                            onTap: () {
                              // Show the edit/delete options
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  // Set the initial value of the text field to the current subtitle
                                  _subtitleController.text = card.subtitle;
                                  _selectedCardIndex = index;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // The form with the text field
                                      Form(
                                        child: TextFormField(
                                          controller: _subtitleController,
                                          decoration: const InputDecoration(
                                            labelText: 'Title',
                                          ),
                                        ),
                                      ),
                                      // The save button
                                      ElevatedButton(
                                        onPressed: () {
                                          // Update the subtitle of the selected card
                                          setState(() {
                                            _cards[_selectedCardIndex].title =
                                                _subtitleController.text;

                                            // Close the modal bottom sheet
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                      // The delete option
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          // Remove the selected card from the list
                                          setState(() {
                                            _cards.removeAt(_selectedCardIndex);
                                          });
                                          // Close the modal bottom sheet
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                        )
                    );
                  }
              ),
            )
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    // Display the dialog to add a new card
                    Map<String, String> values = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // The form with the text fields
                        TextEditingController titleController = TextEditingController();
                        TextEditingController subtitleController = TextEditingController();
                        return AlertDialog(
                          title: const Text('Add Service'),
                          content: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Service name',
                                  ),
                                  validator: (value) {
                                    // Validate the text field
                                  },
                                ),
                                TextFormField(
                                  controller: subtitleController,
                                  decoration: const InputDecoration(
                                    labelText: 'price',
                                  ),
                                  validator: (value) {
                                    // Validate the text field
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            // The save button
                            ElevatedButton(
                              onPressed: () {
                                // Return the values to the caller
                                Navigator.of(context).pop({
                                  'title': titleController.text,
                                  'subtitle': subtitleController.text,
                                });
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );

                    // Add the new card to the list
                    if (values != null) {
                      setState(() {
                        _cards.add(CardData(
                          title: values['title'] as String,
                          subtitle: values['subtitle'] as String,
                        ));
                      });
                    }
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
          )
        ]
    );
  }
}
