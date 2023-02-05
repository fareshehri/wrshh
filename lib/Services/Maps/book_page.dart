import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  // Specify current Date/Time
  final now = DateTime.now();
  // Create Mock Booking Schedule
  late BookingService mockBookingService;

  // Hourly Appointments Set
  @override
  void initState() {
    super.initState();
    mockBookingService = BookingService(
      serviceName: 'Mock Service',
      // Appointments length
      serviceDuration: 30,
      //  Appointments Start time
      bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
      // Appointments End time (next day IDK why)
      bookingEnd: DateTime(now.year, now.month, now.day, 24, 0),
    );
  }

  // Get The Specified Hourly Appointments Set
  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  // Upload The Selected Appointment to "DB"
  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    // print('${newBooking.toJson()} has been uploaded');
  }

  // List to add Booking Picked/Unavailable Periods
  List<DateTimeRange> converted = [];

  // Add Mock Picked Bookings
  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamResult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    DateTime first = now;
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));
    return converted;
  }

  // Add Mock Unavailable Periods Bookings
  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '"Insert WS Name here"',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Insert WS Name here'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Center(
            child: BookingCalendar(
              // Create Mock Booking Schedule
              bookingService: mockBookingService,
              // Add Mock Picked Bookings
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              // Get The Specified Hourly Appointments Set
              getBookingStream: getBookingStreamMock,
              // Upload The Selected Appointment to "DB"
              uploadBooking: uploadBookingMock,
              // Add Mock Unavailable Periods Bookings
              pauseSlots: generatePauseSlots(),
              pauseSlotText: 'Break',
              hideBreakTime: false,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              disabledDays: const [5, 6],
              lastDay: DateTime(now.year, 12, 29),
            ),
          ),
        ));
  }
}
