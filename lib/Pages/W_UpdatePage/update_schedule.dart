import 'dart:collection';
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
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0); ///Shift start time
  TimeOfDay endTime = TimeOfDay(hour: 16, minute: 0); ///Shift finish time
  late Map selectedDays = {}; ///Reference for days cards selection

  bool gotPath = false; /// Retrieve from DB var temp
  late int capacity = 0; /// Capacity
  late LinkedHashMap<String,dynamic> datesHours; ///Contains Days and Shift hours
  late List<DateTime> dates = []; /// Check Day of the week, and assign based on it
  late Map<String,DateTime> selectedDates = {}; // Not yet

  /// Retrieve All information from DB
  Future call() async {
    capacity = await getCapacity(); /// Retrieve Capacity
    datesHours = await getDatesHours(); /// Retrieve Days and Shift hours

    setState(() {
      gotPath = true; /// Allow the page to continue, after retrieving from DB
      for (var day in days) {
        if (datesHours[day][0])
          { /// Set Shift Start and End Time, if exists
            startTime = TimeOfDay(hour: datesHours[day][1], minute: datesHours[day][2]);
            endTime = TimeOfDay(hour: datesHours[day][3], minute: datesHours[day][4]);
          }
      }
      /// Assign selected days from DB to selected Days cards reference
      populateDaysNames();
    });
  }

  @override
  void initState() {
    super.initState();
    try{
      call();
      checkDaysDates();
      checkDays();
    }
    catch (e) {
      print(e);
    }

  }

  /// Check Selected "enabled" days from DB and assign it to the list
  void populateDaysNames() {
    setState(() {
      for (var t in days) {
        /// Assign selected days from DB to selected Days cards reference
        selectedDays[t] = datesHours[t][0];
      }
    });
  }

  /// Check day of the week, and assign allowed days given the day
  void checkDaysDates() {
    DateTime temp = DateTime.now().add(Duration());

    // if today is Saturday, get remaining week days(7)
    if (temp.weekday == 6) {
    dates.add(temp.add(const Duration(days: 1)));
    dates.add(temp.add(const Duration(days: 2)));
    dates.add(temp.add(const Duration(days: 3)));
    dates.add(temp.add(const Duration(days: 4)));
    dates.add(temp.add(const Duration(days: 5)));
    dates.add(temp.add(const Duration(days: 6)));
    dates.add(temp.add(const Duration(days: 7)));
    }
    // if today is Sunday, get remaining week days (6)
    else if (temp.weekday == 7) {
      dates.add(temp.add(const Duration(days: 1)));
      dates.add(temp.add(const Duration(days: 2)));
      dates.add(temp.add(const Duration(days: 3)));
      dates.add(temp.add(const Duration(days: 4)));
      dates.add(temp.add(const Duration(days: 5)));
      dates.add(temp.add(const Duration(days: 6)));
    }
    // if today is Monday, get remaining week days (5)
    else if (temp.weekday == 1) {
      dates.add(temp.add(const Duration(days: 1)));
      dates.add(temp.add(const Duration(days: 2)));
      dates.add(temp.add(const Duration(days: 3)));
      dates.add(temp.add(const Duration(days: 4)));
      dates.add(temp.add(const Duration(days: 5)));
    }
    // if today is Tuesday, get remaining week days (4)
    else if (temp.weekday == 2) {
      dates.add(temp.add(const Duration(days: 1)));
      dates.add(temp.add(const Duration(days: 2)));
      dates.add(temp.add(const Duration(days: 3)));
      dates.add(temp.add(const Duration(days: 4)));
    }
    // if today is Wednesday, get remaining week days(3)
    else if (temp.weekday == 3) {
      dates.add(temp.add(const Duration(days: 1)));
      dates.add(temp.add(const Duration(days: 2)));
      dates.add(temp.add(const Duration(days: 3)));
    }
    // if today is Thursday, get remaining week days(2)
    else if (temp.weekday == 4) {
      dates.add(temp.add(const Duration(days: 1)));
      dates.add(temp.add(const Duration(days: 2)));
    }
    // if today is Friday, get remaining week days(1)
    else if (temp.weekday == 5) {
      dates.add(temp.add(const Duration(days: 1)));
    }

  }

  /// Helper Method, to check what days appear on the screen
  void checkDays() {
    List<String> check = [];
    for (var temp in days) {
      for (int i=0; i < dates.length; i++) {
        if (temp == getDayName(dates[i])) {
          check.add(temp);
        }
      }
    }
    days = check;
  }
  /// Check selected days, and Assign Time, and Disable not selected days
  void checkAll(){
    setState(() {
      for (var day in days) {
        if (datesHours[day][0] == true) {
          datesHours[day][1] = startTime.hour;
          datesHours[day][2] = startTime.minute;
          datesHours[day][3] = endTime.hour;
          datesHours[day][4] = endTime.minute;
        }
        else {
          datesHours[day][1] = 0;
          datesHours[day][2] = 0;
          datesHours[day][3] = 0;
          datesHours[day][4] = 0;
        }
      }

      updateCapacity(capacity);
      updateDatesHours(datesHours);

      /// HERE
      selectedDates = {};
      for (var day in days) {
        for (var selDay in selectedDays.keys){
          if (datesHours[day][0] && (day == selDay)){
            for (int i=0; i < dates.length; i++) {
              if (datesHours[selDay][0] && selDay == getDayName(dates[i])) {
                dates[i] = DateTime(dates[i].year,dates[i].month,dates[i].day,startTime.hour,startTime.minute);
                selectedDates[selDay] = dates[i];
              }
            }

          }
        }
      }
      handleAppointmentsInDB().then((_) {
      addAppointmentsTable(capacity, selectedDates, datesHours);
      });
    });
  }

  ///Create a method to convert TimeOfDay to String using the format HH:MM AM/PM
  String convertTimeOfDayToHHMM(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  /// Days cards builder and controller
  DaySlot buildDaysCard(day, index) {
    return DaySlot(
      onTap: () {
        setState(() {
          if (selectedDays[day] == true) {
            selectedDays[day] = false; /// Reference
            datesHours[day][0] = false; /// Actual work
          } else {
            selectedDays[day] = true; /// Reference
            datesHours[day][0] = true; /// Actual work
          }
        });
      },
      isSelected: selectedDays[day] ?? false,
      isPauseTime: false,
      isBooked: false,
      child: Center(
        child: Text(
          '${getDayName(dates[index])}, ${dates[index].day}/${dates[index].month}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Translate DateTime object Day name
  String getDayName(DateTime date) {
    int dayOfWeek = date.weekday;
    switch (dayOfWeek) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'Invalid Day';
    }
  }

  /// Populate Shift time dropdown lists
  List<DropdownMenuItem<TimeOfDay>> timeDropdown() {
    List<DropdownMenuItem<TimeOfDay>> dropdownItems = [];
    for (TimeOfDay time in timeRange) {
      var newItem = DropdownMenuItem(
          value: time,
          child: Text(convertTimeOfDayToHHMM(time)));
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  /// Populate Capacity dropdown list
  List<DropdownMenuItem<int>> capacityDropdown() {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (int c in capacityList) {
      var newItem = DropdownMenuItem(value: c, child: Text(c.toString()));
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    /// To check if DB information have been retrieved
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// Days with dates builder (caller)
            SizedBox(
              height: 160,
              child: GridView.builder(
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  return buildDaysCard(days[index], index);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                ),
              ),
            ),
            /// Start & End Time parts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Start Time Part
                Row(
                  children: [
                    const Text('Start Time:',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                      menuMaxHeight: 300,
                      value: startTime,
                      items: timeDropdown(),
                      onChanged: (value) {
                        setState(() {
                          startTime = value as TimeOfDay;
                        });
                      },
                    ),
                  ],
                ),
                /// End Time Part
                Row(
                  children: [
                    const Text('End Time:',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                      value: endTime,
                      items: timeDropdown(),
                      onChanged: (value) {
                        setState(() {
                          endTime = value as TimeOfDay;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            /// Capacity part
            Row(
              children: [
                const Text('Capacity:',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(
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
            /// Update Button part
            RoundedButton(
                title: 'Update',
                colour: kDarkColor,
                onPressed: () {
                  if (endTime.hour < startTime.hour ||
                       (endTime.hour == startTime.hour &&
                          endTime.minute < startTime.minute)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                        Text('End time should be greater than start time'),
                      ),
                    );
                  }
                  else {
                    checkAll();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Update Done!'),
                        )
                    );
                  }
                }),
          ],
        ),
      );
    }
  }
}
