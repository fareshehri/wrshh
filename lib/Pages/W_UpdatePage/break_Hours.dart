import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BreakHours extends StatefulWidget {
  const BreakHours({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BreakHours();
  }
}

class _BreakHours extends State<BreakHours> {
  var bbcolor = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];
  var gotPath = false;


  final TextEditingController _breakHourController = TextEditingController();
  // List of selectable break hours
  final List<DateTime> breakHours = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Break Hours"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Show the modal bottom sheet to enter the break hour
              DateTime? breakHour = await showModalBottomSheet<DateTime>(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The form to enter the break hour
                      Form(
                        child: Column(
                          children: [
                            // The text field to enter the break hour
                            TextFormField(
                              controller: _breakHourController,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                // Only allow the user to enter a valid hour
                                FilteringTextInputFormatter.digitsOnly,
                                // Format the text as an hour,
                              ],
                              validator: (value) {
                                // Validate that the entered value is a valid hour
                                if (!DateFormat('HH:mm').parse(value!).isAtSameMomentAs(_breakHourController.text as DateTime)) {
                                  return 'Enter a valid break hour';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Break hour',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // The button to confirm the break hour
                      ElevatedButton(
                        onPressed: () {
                          // Validate the form and close the modal bottom sheet
                            Navigator.of(context).pop(DateFormat('HH:mm').parse(_breakHourController.text));
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
              // Add the break hour to the list of break hours
              if (breakHour != null) {
                setState(() {
                  breakHours.add(breakHour);
                });
              }
            },
            child: const Text('Add break hour'),
          ),
        ],
      )
    );
  }
}
