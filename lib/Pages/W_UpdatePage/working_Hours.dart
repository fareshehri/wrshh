import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

import '../../Services/Auth/auth.dart';


class WorkingHours extends StatefulWidget {
  const WorkingHours({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkingHours();
  }

}

class _WorkingHours extends State<WorkingHours> {

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

  Future<void> call() async {
    _timeRange = await AuthService().getWorkingHours();
    print(_timeRange);
    gotPath = true;
  }

  @override
  void initState() {
    super.initState();
    // AuthService().getWorkingHours(_timeRange, gotPath);
    // _timeRange = AuthService().getWorkingHours() as TimeRangeResult;
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
