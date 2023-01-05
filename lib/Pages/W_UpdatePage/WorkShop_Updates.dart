import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';

import '../../Services/Auth/auth.dart';


class WorkshopUpdate extends StatelessWidget {
  WorkshopUpdate({Key? key}) : super(key: key);

  final titles = ["Services",
    "Capacity",
    "Working Hours",
    "Break Dates",
    "Break Hours"];
  final subtitles = [
    "Update services provided",
    "Update working capacity",
    "Update shift time",
    "Update Break days",
    "Update break hours"];
  final icons = [
    Icons.category_rounded,
    Icons.reduce_capacity,
    Icons.punch_clock,
    Icons.calendar_month,
    Icons.event_busy];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: titles.length, itemBuilder: (context, index) {

      return Card(
        child: ListTile(
          title: Text(titles[index]),
          subtitle: Text(subtitles[index]),
          leading: Icon(icons[index]),
          onTap: () {
            if (index == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Services()));
            }
            if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Capacity()));
            }
            if (index == 2) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShiftHours()));
            }
            if (index == 3) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BreakDates()));
            }
            if (index == 4) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BreakHours()));
            }
          },
        ),
      );
    }
    );
  }
}

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
                        temp.addAll(_objects[i]);
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

class Capacity extends StatefulWidget {
  const Capacity({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Capacity();
  }
}
class _Capacity extends State<Capacity> {

  static const dark = Color(0xFF333A47);
  static const double leftPadding = 9;
  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  late int capacity;
  late List<DropdownMenuItem<int>> _items;
  bool gotPath = false;

  Future call() async {
    capacity = await AuthService().getCapacity();
    setState(() {
      gotPath = true;
    });
  }

  @override
  void initState() {
    super.initState();
    call();
    _items = [
      const DropdownMenuItem(
        value: 0,
        child: Text('0'),
      ),
    ];
    _items.addAll(List.generate(20, (index) {
      return DropdownMenuItem(
        value: index + 1,
        child: Text('${index + 1}'),
      );
    }));
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
          title: const Text("Capacity"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.lightBlue[300], size: 24
          ),
        ),

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              /// Selected Range & Default button
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Capacity: $capacity',
                      style: const TextStyle(fontSize: 20, color: dark),
                    ),
                  ],
                ),
              ),

              /// TimeRange Wheel
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                        value: capacity,
                        items: _items,
                        onChanged: (value) {
                          setState(() {
                            capacity = value as int;
                          });
                        }
                    )
                  ],
                ),
              ),

              /// Done Button
              const SizedBox(height: 500, width: 20),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthService().updateCapacity(capacity);
                        });

                        Navigator.pop(context);
                      },

                      /// Button Style
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 13.0, right: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)
                        ),
                      ),
                      child: const Text("Done", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

class ShiftHours extends StatefulWidget {
  const ShiftHours({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShiftHours();
  }

}
class _ShiftHours extends State<ShiftHours> {

  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 9;

  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  final _defaultTimeRange = TimeRangeResult(
    const TimeOfDay(hour: 8, minute: 00),
    const TimeOfDay(hour: 16, minute: 00),
  );

  late TimeRangeResult _timeRange;
  bool gotPath = false;

  Future call() async {
    _timeRange = await AuthService().getWorkingHours();
    setState(() {
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
          title: const Text("Working Hours"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.lightBlue[300], size: 24
          ),
        ),

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              /// Selected Range & Default button
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Range: ${_timeRange.start.format(
                          context)} - ${_timeRange.end.format(context)}',
                      style: const TextStyle(fontSize: 20, color: dark),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _timeRange = _defaultTimeRange;
                        }
                        );
                      },
                      color: orange,
                      child: const Text('Default'),
                    )
                  ],
                ),
              ),

              /// Opening Times Part
              Padding(
                padding: const EdgeInsets.only(top: 16, left: leftPadding),
                child: Text(
                  'Opening Times',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold, color: dark),
                ),
              ),

              /// TimeRange Wheel
              const SizedBox(height: 20),
              TimeRange(
                fromTitle: const Text(
                  'FROM',
                  style: TextStyle(
                    fontSize: 14,
                    color: dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                toTitle: const Text(
                  'TO',
                  style: TextStyle(
                    fontSize: 14,
                    color: dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                titlePadding: leftPadding,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: dark,
                ),
                activeTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
                borderColor: dark,
                activeBorderColor: dark,
                backgroundColor: Colors.transparent,
                activeBackgroundColor: dark,
                firstTime: _timeRange.start,
                lastTime: _timeRange.end,
                initialRange: _timeRange,
                timeStep: 30,
                timeBlock: 30,
                onRangeCompleted: (range) {
                  _timeRange = range!;
                },
                onFirstTimeSelected: (startHour) {},
              ),

              /// Done Button
              const SizedBox(height: 290, width: 20),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthService().updateWorkingHours(_timeRange);
                        });
                        Navigator.pop(context);
                      },
                      /// Button Style
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 13.0, right: 13),
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)
                        ),
                      ),
                      child: const Text("Done", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

class BreakDates extends StatefulWidget {
  const BreakDates({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BreakDates();
  }
}
class _BreakDates extends State<BreakDates> {
  var bbcolor = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];
  var gotPath = false;

  late final List<DateTime> _breakDates = [];
  final _formatter = DateFormat('MMM d, yyyy');

  Future call() async {
    List breaks = await AuthService().getBreakDates();
    setState(() {
      for (int i = 0; i < breaks.length; i++) {
        DateTime temp = DateTime.fromMillisecondsSinceEpoch(breaks[i]);
        _breakDates.add(temp);
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Break days"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
        ),
        body: Column(
          children: [
            Expanded(
              ////
              child: ListView.builder(
                  itemCount: _breakDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    var breakDate = _breakDates[index];
                    // for (final breakDate in _breakDates)
                    return ListTile(
                        title: Text(_formatter.format(breakDate)),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            )
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editBreakDate(breakDate);
                            } else if (value == 'delete') {
                              setState(() {
                                _breakDates.removeAt(index);
                                AuthService().updateBreakDates(_breakDates);
                              });
                            }
                          },
                        )
                    );
                  }),
            ),
            Container(
              child: ListTile(
                title: const Text("Add Break Date"),
                trailing: const Icon(Icons.add),
                onTap: _addBreakDate,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _addBreakDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        _breakDates.add(date);
        AuthService().updateBreakDates(_breakDates);
      });
    }
  }

  void _editBreakDate(DateTime breakDate) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: breakDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        _breakDates.remove(breakDate);
        _breakDates.add(date);
        AuthService().updateBreakDates(_breakDates);
      });
    }
  }
}

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
  late final List<DateTime> _breakDates = [];

  Future call() async {
    List breaks = await AuthService().getBreakHours();
    setState(() {
      for (int i = 0; i < breaks.length; i++) {
        DateTime temp = DateTime.fromMillisecondsSinceEpoch(breaks[i]);
        _breakDates.add(temp);
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
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
            Expanded(
              child: ListView.builder(
                  itemCount: _breakDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    var breakDate = _breakDates[index];
                    String temp = '${DateFormat.MMMMEEEEd().format(breakDate)} - ${DateFormat.Hm().format(breakDate)}';
                    if (int.tryParse(DateFormat.m().format(breakDate)) == 0)
                      {
                        temp = DateFormat.MMMMEEEEd().format(breakDate);
                      }
                    return ListTile(
                        title: Text(temp),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            )
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editBreakHour(breakDate);
                            } else if (value == 'delete') {
                              setState(() {
                                _breakDates.removeAt(index);
                                AuthService().updateBreakHours(_breakDates);
                              });
                            }
                          },
                        )
                    );
                  }),
            ),
            ListTile(
              title: const Text("Add Break Date"),
              trailing: const Icon(Icons.add),
              onTap: _addBreakDate,
            ),
            ListTile(
              title: const Text("Add Break Hour"),
              trailing: const Icon(Icons.add),
              onTap: _addBreakHour,
            ),
          ],
        ),
      );
    }
  }

  void _addBreakHour() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        final DateTime breakDate = DateTime(
          date!.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _breakDates.add(breakDate);
        AuthService().updateBreakHours(_breakDates);
      });
    }
  }

  void _editBreakHour(DateTime breakDate) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: breakDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: breakDate.hour,
        minute: breakDate.minute,
      ),
    );

    if (time != null) {
      setState(() {
        final DateTime updatedBreakDate = DateTime(
          date!.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        final int index = _breakDates.indexOf(breakDate);
        _breakDates.removeAt(index);
        _breakDates.insert(index, updatedBreakDate);
        AuthService().updateBreakHours(_breakDates);
      });
    }
  }

  void _addBreakDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        _breakDates.add(date);
        AuthService().updateBreakDates(_breakDates);
      });
    }
  }

}
