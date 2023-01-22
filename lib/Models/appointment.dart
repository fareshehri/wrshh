class Appointment {
  late String appointmentID;
  late String workshopID;
  late String VIN;
  late String clientID;
  late String status;
  late String service;
  late double price;
  late String datetime;
  late double rate;
  late String reportURL;
  late String reportDetails;

  Appointment(
      {required this.appointmentID,
      required this.workshopID,
      required this.VIN,
      required this.clientID,
      required this.status,
      required this.service,
      required this.price,
      required this.datetime,
      required this.rate,
      required this.reportURL
      ,required this.reportDetails});
}
