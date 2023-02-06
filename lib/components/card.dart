// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rate/rate.dart';
import 'package:wrshh/Models/appointment.dart';
import 'package:wrshh/Pages/client/client_home.dart';
import 'package:wrshh/Pages/client/payment_page.dart';
import 'package:wrshh/Pages/workshopTechnician/report_pages.dart';
import 'package:wrshh/components/pdf_page.dart';
import '../Services/Auth/client_database.dart';

class AppointmentsCard extends StatefulWidget {
  final String? logoURL;
  final String? itemName;
  final String? itemID;
  final double? itemHeight;
  final Appointment appointment;

  final String cardType;

  const AppointmentsCard({
    super.key,
    this.logoURL,
    required this.itemName,
    required this.appointment,
    required this.itemID,
    required this.cardType,
    this.itemHeight,
  });

  @override
  State<AppointmentsCard> createState() => _AppointmentsCardState();
}

class _AppointmentsCardState extends State<AppointmentsCard> {
  late String logoURL = '';
  late double rate = 0;
  late String serialOrWorkshop = '';
  bool isRated = false;
  bool isReported = false;
  bool isPaid = false;
  bool gotPath = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
    if (widget.cardType == 'WorkshopInvoice' || widget.cardType == 'Workshop') {
      serialOrWorkshop = 'Serial Number:';
    } else {
      serialOrWorkshop = 'Workshop Name:';
    }
  }

  _asyncMethod() async {
    var appointmentlogo = await getWorkshopLogoFromDB(widget.itemID!);
    isReported = await checkReportStatus(widget.appointment.appointmentID);
    isRated = await checkRateStatus(widget.appointment.appointmentID);
    isPaid = await checkPaymentStatus(widget.appointment.appointmentID);
    setState(() {
      logoURL = appointmentlogo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.itemHeight,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: FittedBox(
                fit: BoxFit.fill,
                child: ClipOval(
                  child: Image.network(
                    logoURL,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/loading.png',
                        width: 80,
                        height: 80,
                      );
                    },
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(widget.itemName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        const SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  widget.appointment.datetime,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 10),
                              FittedBox(
                                  alignment: Alignment.centerRight,
                                  fit: BoxFit.fitWidth,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 16,
                                                left: 16,
                                                right: 16,
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    16),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: ClipOval(
                                                          child: Image.network(
                                                        logoURL,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/loading.png',
                                                            width: 130,
                                                            height: 130,
                                                          );
                                                        },
                                                        width: 130,
                                                        height: 130,
                                                        fit: BoxFit.cover,
                                                      )),
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 250,
                                                            child: ListView(
                                                              children: [
                                                                const SizedBox(
                                                                    height: 10),
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  child: Text(
                                                                    '$serialOrWorkshop ${widget.itemName}',
                                                                    style:
                                                                        kTextStyle,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    'Date & Time: ${widget.appointment.datetime}',
                                                                    style:
                                                                        kTextStyle,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                const Center(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      'Services',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  height: 100,
                                                                  child: ListView
                                                                      .builder(
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Text(
                                                                        '${widget.appointment.service[index]}',
                                                                        style:
                                                                            kTextStyle,
                                                                      );
                                                                    },
                                                                    itemCount: widget
                                                                        .appointment
                                                                        .service
                                                                        .length,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: getButtons(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.pink,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    child: const Text('Show Details'),
                                  )),
                            ],
                          ),
                        ),
                      ])),
            ),
          ]),
    );
  }

  ButtonStyle kButtonsStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.pink,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );

  List<Widget> getButtons() {
    List<Widget> buttons = [];
    var payButton = Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PaymentPage()));
        },
        style: kButtonsStyle,
        child: const Text('Pay'),
      ),
    );

    var cancelButton = Expanded(
        child: ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmation"),
                content: const Text(
                    "Are you sure you want to cancel this appointment?"),
                actions: [
                  TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      cancelAppointment(widget.appointment.appointmentID);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                  ),
                ],
              );
            });
      },
      style: kButtonsStyle,
      child: const Text('Cancel Booking'),
    ));

    var rateButton = Expanded(
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                child: Container(
                    // height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text('Rate this appointment',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 10),
                        Rate(
                          iconSize: 40,
                          color: Colors.green,
                          allowHalf: true,
                          allowClear: true,
                          initialValue: rate,
                          readOnly: false,
                          onChange: (value) => setState(() {
                            rate = value;
                          }),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (rate != 0) {
                              rateAppointment(widget.appointment.appointmentID,
                                  widget.appointment.workshopID, rate);
                              Navigator.pop(context);
                            }
                          },
                          style: kButtonsStyle,
                          child: const Text('Submit'),
                        )
                      ],
                    )),
              ),
            ),
          );
        },
        style: kButtonsStyle,
        child: const Text('Rate'),
      ),
    );

    var reportButton = Expanded(
      child: ElevatedButton(
        onPressed: () async {
          var reportURL =
              await getAppointmentReport(widget.appointment.appointmentID);
          if (reportURL != "" && reportURL != null ) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PDFPage(reportURL: reportURL)));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Center(
                    child: Column(children: const [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Report is not ready yet',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]),
                  ));
                });
            Future.delayed(
                const Duration(seconds: 2), () => Navigator.pop(context));
          }
        },
        style: kButtonsStyle,
        child: const Text(
          'Show Report',
          textAlign: TextAlign.center,
        ),
      ),
    );

    var uploadReportButton = Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportPage(
                app: widget.appointment,
              ),
            ),
          );
        },
        style: kButtonsStyle,
        child: const Text('Upload Report'),
      ),
    );

    if (widget.cardType == 'Bookings') {
      if (widget.appointment.status == 'booked') {
        buttons.add(cancelButton);
      } else if (widget.appointment.status == 'finished') {
        if (!isRated) {
          buttons.add(rateButton);
        }
        if (isReported) {
          buttons.add(reportButton);
        }
        if (!isPaid) {
          buttons.add(payButton);
        }
      }
    } else if (widget.cardType == 'HistorySerial') {
      if (isReported) {
        buttons.add(reportButton);
      }
    } else if (widget.cardType == 'WorkshopInvoice') {
      if (!isReported) {
        buttons.add(uploadReportButton);
      }
    } else if (widget.cardType == 'Workshop') {
      if (widget.appointment.status == 'booked') {
        buttons.add(cancelButton);
      }
    }
    if (buttons.length > 1) {
      buttons.insert(1, const SizedBox(width: 10));
    }
    if (buttons.length > 2) {
      buttons.insert(3, const SizedBox(width: 10));
    }
    if (buttons.length > 5) {
      buttons.insert(6, const SizedBox(width: 10));
    }

    return buttons;
  }

  var kTextStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
}
