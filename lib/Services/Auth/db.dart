import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
//
// // add cars to the database
// Future<void> addCar(String carName, String carModel, String carYear, String carColor, String carPlate, String carType, String carImage, String carPrice, String carDescription, String carOwner) async {
//   await _firestore.collection('cars').doc(vin).add({
//     'carName': carName,
//     'carModel': carModel,
//     'carYear': carYear,
//     'carColor': carColor,
//     'carPlate': carPlate,
//     'carType': carType,
//     'carImage': carImage,
//     'carPrice': carPrice,
//     'carDescription': carDescription,
//     'carOwner': carOwner,
//   });
//
//
// }
//
// // retive woskshops data from the database
// Future<void> getWorkshops() async {
//   final workshops = await _firestore.collection('workshops').get();
//   for (var workshop in workshops.docs) {
//     print(workshop.data());
//   }
// }
//

// retrieve appointments from firestore where adminEmail == email
Future<List> getAppointmentsFromDB(String email) async {
  List appointments = [];
  _firestore.collection('Appointment').where('workshopID', isEqualTo: email).get().then((value) {
    value.docs.forEach((element) {
      appointments.add(element);
      print(element.id);
        });
      });
  return appointments;
  }

  // final appointmentsDB = await _firestore.collection('Appointments').where('workshopID', isEqualTo: email).get();
  //
  // print('appointmentsDB: $appointmentsDB.docs');
  // var count = 0;
  // for (var appointment in appointmentsDB.docs) {
  //   count++;
  //   appointments.add(appointment.data());
  //   print('appointments: $appointments');
  // }
  // print('count: $count');
  // print('appointments: $appointments');
  // return appointments;
// }
