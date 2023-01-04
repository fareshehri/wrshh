import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WorkingDates extends StatefulWidget {
  const WorkingDates({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkingDates();
  }

}

class _WorkingDates extends State<WorkingDates> {

  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];
  var gotPath = false;

  final List<DateTime> _breakDates = [];
  final _formatter = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    // if (!gotPath) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    // else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Break days"),
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
              for (final breakDate in _breakDates)
                ListTile(
                  title: Text(_formatter.format(breakDate)),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editBreakDate(breakDate),
                  ),
                ),
              ListTile(
                title: const Text("Add Break Date"),
                trailing: const Icon(Icons.add),
                onTap: _addBreakDate,
              ),
            ],
          ),
      );
    // }
  }

  void _addBreakDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => _breakDates.add(date));
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
      });
    }
  }
}