import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'show CalendarCarousel, EventList;

import 'package:wrshh/Pages/Home.dart';

/// Book Page (Calendar)
class bookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<bookPage> {

  DateTime _currentDate = DateTime.now();

  // EventList<Event> _markedDateMap = new EventList<Event>(
  //   events: {
  //     new DateTime(2019, 2, 10): [
  //       new Event(
  //         date: new DateTime(2019, 2, 10),
  //         title: 'Event 1',
  //         icon: _eventIcon,
  //         dot: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 1.0),
  //           color: Colors.red,
  //           height: 5.0,
  //           width: 5.0
  //         ),
  //       ),
  //     ],
  //   },
  // );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,

      body: Stack (
          children: [
            //Cancel button
            Positioned(
              bottom:50,
              left: 30,
              child: Container(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context, false);
                    },
                    child: const Text("cancel"),
                  )
              ),
            ),
            // Book button
            Positioned(
              bottom:50,
              right: 30,
              child: Container(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Home()));
                    },
                    child: const Text("book"),
                  )
              ),
            ),
            //Calendar shit
            Positioned(
              top: 250,
              right: 80,
              child: Container(
                margin: const EdgeInsets.all(12.0),
                width: 260,
                child: CalendarCarousel(
                  onDayPressed: (DateTime date, List events) {
                    setState(() => _currentDate = date);
                  },
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  customDayBuilder: (   /// you can provide your own build function to make custom day containers
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                      ) {
                        return null;

                    /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                    /// This way you can build custom containers for specific days only, leaving rest as default.
                  },
                  weekFormat: false,
                  // markedDatesMap: _markedDateMap,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                ),
              ),
            )
          ]
      ),
    );
  }
}