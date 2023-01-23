
import 'package:flutter/cupertino.dart';

import '../Models/appointment.dart';
import 'card.dart';
import 'package:intl/intl.dart';

List<Widget> buildAppointmentsCards(Map appointments, String cardType) {
  List<Widget> cards = [];

  // loop through the appointments and create a card for each one
  for (var workshopName in appointments.keys) {
    for (var appointment in appointments[workshopName]) {
      final DateFormat formatter = DateFormat.yMd().add_jm();
      var date = DateTime.fromMillisecondsSinceEpoch(
          appointment.data()['datetime'].seconds * 1000);
      final String dateFormatted = formatter.format(date);
      cards.add(
        AppointmentsCard(
          // logoURL: workshopName.first,
          itemID: appointment.data()['workshopID'],
          itemName: workshopName,
          cardType: cardType,
          appointment: Appointment(
            appointmentID: appointment.id,
            workshopID: appointment.data()['workshopID'],
            VIN: appointment.data()['VIN'],
            clientID: appointment.data()['clientID'],
            status: appointment.data()['status'],
            service: appointment.data()['service'],
            price: double.parse(appointment.data()['price'].toString()),
            datetime: dateFormatted,
            rate: double.parse(appointment.data()['rate'].toString()),
            reportURL: appointment.data()['reportURL'],
            reportDetails: '',
          ),

        ),
      );
      cards.add(SizedBox(
        height: 10,
      ));
    }
  }

  return cards;
}