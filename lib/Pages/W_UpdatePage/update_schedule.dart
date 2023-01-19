import 'package:flutter/material.dart';
import 'package:wrshh/Pages/W_UpdatePage/schedule_data.dart';
import 'package:intl/intl.dart';
import 'package:wrshh/components/roundedButton.dart';
import 'package:wrshh/constants.dart';

import '../../Services/Auth/db.dart';
import '../../components/booking_slot.dart';

class UpdateSchedule extends StatefulWidget {
  const UpdateSchedule({Key? key}) : super(key: key);

  @override
  State<UpdateSchedule> createState() => _UpdateScheduleState();
}

class _UpdateScheduleState extends State<UpdateSchedule> {
  late List<TimeOfDay> startTime;
  late TimeOfDay? start = null;
  late TimeOfDay? end = null;
  late int? capacity = null;
  late Map selectedDays = {};

  // create a method to convert TimeOfDay to String using the format HH:MM AM/PM
  String convertTimeOfDayToHHMM(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final now = DateTime.now();


    var date = DateTime(now.year, now.month+1, 0).toString();
  print(DateTime.daysPerWeek);
    print(Duration(days: now.weekday));
  }

  Container buildDaysCard(day) {
    return Container(
      child: DaySlot(
        onTap: () {
          setState(() {
            if (selectedDays[day] == true) {
              selectedDays[day] = false;
            } else {
              selectedDays[day] = true;
            }
          });
        },
        isSelected: selectedDays[day] ?? false,
        isPauseTime: false,
        isBooked: false,
        child: Center(
          child: Text(
            day,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<TimeOfDay>> timeDropdown() {
    List<DropdownMenuItem<TimeOfDay>> dropdownItems = [];
    for (TimeOfDay time in timeRange) {
      var newItem = DropdownMenuItem(
          child: Text(convertTimeOfDayToHHMM(time)), value: time);
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  List<DropdownMenuItem<int>> capacityDropdown() {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (int c in capacityList) {
      var newItem = DropdownMenuItem(child: Text(c.toString()), value: c);
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Expanded(
                child: GridView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    return buildDaysCard(days[index]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Start Time:',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                      menuMaxHeight: 300,
                      value: start,
                      items: timeDropdown(),
                      onChanged: (value) {
                        setState(() {
                          start = value as TimeOfDay?;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('End Time:',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                      value: end,
                      items: timeDropdown(),
                      onChanged: (value) {
                        setState(() {
                          end = value as TimeOfDay?;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text('Capacity:',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  value: capacity,
                  items: capacityDropdown(),
                  onChanged: (value) {
                    setState(() {
                      capacity = value as int;
                    });
                  },
                ),

              ],
            ),
            RoundedButton(
                title: 'Update',
                colour: kDarkColor,
                onPressed: () {
                  if (start == null ||
                      end == null ||
                      capacity == null ||
                      selectedDays.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                  } else if (end!.hour < start!.hour ||
                      (end!.hour == start!.hour &&
                          end!.minute < start!.minute)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('End time should be greater than start time'),
                      ),
                    );
                  } else {
                    List daysList = [];
                    selectedDays.forEach((key, value) {
                      if (value == true) {
                        daysList.add(key);
                      }
                    });
                    addAppointmentsTable(
                        start!, end!, capacity!, daysList, 'test');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
