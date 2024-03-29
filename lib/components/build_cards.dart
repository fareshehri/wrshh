import 'package:flutter/cupertino.dart';
import 'package:wrshh/Models/workshop.dart';
import 'package:wrshh/components/workshops_cards.dart';

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
      var serialNumber = appointment.data()['serial'];
      if (serialNumber == null || serialNumber == '') {
        serialNumber = 'Not Booked';
      }
      cards.add(
        AppointmentsCard(
          itemID: appointment.data()['workshopID'],
          itemName: cardType == 'Workshop'
              ? serialNumber
              : cardType == 'WorkshopInvoice'
                  ? serialNumber
                  : workshopName,
          cardType: cardType,
          appointment: Appointment(
            appointmentID: appointment.id,
            workshopID: appointment.data()['workshopID'],
            serial: appointment.data()['serial'],
            clientID: appointment.data()['clientID'],
            status: appointment.data()['status'],
            service: appointment.data()['services'],
            price: double.parse(appointment.data()['price'].toString()),
            datetime: dateFormatted,
            rate: double.parse(appointment.data()['rate'].toString()),
            reportURL: appointment.data()['reportURL'],
            odometer: '',
          ),
        ),
      );
      cards.add(const SizedBox(
        height: 10,
      ));
    }
  }

  return cards;
}

List<Widget> buildWorkshopsCards(Map workshops) {
  List<Widget> cards = [];

  // loop through the workshops and create a card for each one
  for (var workshop in workshops.keys) {
    cards.add(
      WorkshopsCard(
        workshopID: workshop,
        workshopName: workshops[workshop]['workshopName'],
        workshop: Workshop(
          workshopUID: workshop,
          adminEmail: workshops[workshop]['adminEmail'],
          technicianEmail: workshops[workshop]['technicianEmail'],
          workshopName: workshops[workshop]['workshopName'],
          location: workshops[workshop]['location'],
          overallRate:
              double.parse(workshops[workshop]['overallRate'].toString()),
          logoURL: workshops[workshop]['logoURL'],
          numOfRates: workshops[workshop]['numberOfRates'] ?? 0,
        ),
      ),
    );
    cards.add(const SizedBox(
      height: 10,
    ));
  }

  return cards;
}
