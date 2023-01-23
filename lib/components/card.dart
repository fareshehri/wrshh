import 'package:flutter/material.dart';

import 'package:rate/rate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:wrshh/Models/appointment.dart';
import 'package:wrshh/Pages/client/Home.dart';

import 'package:wrshh/Services/Auth/db.dart';

import '../Pages/workshopTechnical/Report.dart';

class AppointmentsCard extends StatefulWidget {
  final String? logoURL;
  final String? itemName;
  final String? itemID;
  final double? itemHeight;
  final Appointment? appointment;

  final Function? onPay;
  final Function? onCancel;
  final Function? onRate;
  final Function? onShowReport;
  final Function? onUploadReport;
  final String cardType;

  const AppointmentsCard(
      {this.logoURL,
      required this.itemName,
      required this.appointment,
      required this.itemID,
      required this.cardType,
      this.itemHeight,
      this.onPay,
      this.onCancel,
      this.onRate,
      this.onShowReport,
      this.onUploadReport});

  @override
  State<AppointmentsCard> createState() => _AppointmentsCardState();
}

class _AppointmentsCardState extends State<AppointmentsCard> {
  late String logoURL = '';
  late double rate = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var appointmentlogo = await getWorkshopLogoFromDB(widget.itemID!);
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
                        'assets/images/FFFF.jpg',
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
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  widget.appointment!.datetime,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.grey, width: 2),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.fill,
                                                        // TODO: add image from database
                                                        child: ClipOval(
                                                            child: Image.network(
                                                          logoURL,
                                                          errorBuilder: (context,
                                                              error, stackTrace) {
                                                            return Image.asset(
                                                              'assets/images/FFFF.jpg',
                                                              width: 160,
                                                              height: 160,
                                                            );
                                                          },
                                                          width: 160,
                                                          height: 160,
                                                          fit: BoxFit.cover,
                                                        )),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 10),
                                                            FittedBox(
                                                              fit: BoxFit.fitHeight,
                                                              child: Text(
                                                                'Workshop Name: ${widget.itemName}',
                                                                style: kTextStyle,
                                                              ),
                                                            ),
                                                            SizedBox(height: 10),
                                                            FittedBox(
                                                              fit: BoxFit.fitHeight,
                                                              child: Text(
                                                                'Date & Time: ${widget.appointment!.datetime}',
                                                                style: kTextStyle,
                                                              ),
                                                            ),
                                                            SizedBox(height: 10),
                                                            FittedBox(
                                                              fit: BoxFit.fitHeight,
                                                              child: Text(
                                                                  'Service & Price: ${widget.appointment!.service} - ${widget.appointment!.price} SR',
                                                                  style: kTextStyle
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
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
                                        ),
                                      );
                                    },
                                    child: Text('Show Details'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.pink,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32.0),
                                      ),
                                    ),
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
    primary: Colors.pink,
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );

  List<Widget> getButtons() {
    List<Widget> buttons = [];
    var payButton =   Expanded(
      child: ElevatedButton(
        onPressed: () {
          widget.onPay!();
        },
        child: Text('Pay'),
        style: kButtonsStyle,
      ),
    );

    var cancelButton = Expanded(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content:
                    Text("Are you sure you want to cancel this appointment?"),
                    actions: [
                      TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          cancelAppointment(widget.appointment!.appointmentID);
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                    ],
                  );
                });
          },
          child: Text('Cancel Booking'),
          style: kButtonsStyle,
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
                        Text('Rate this appointment',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(height: 10),
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
                              rateAppointment(widget.appointment!.appointmentID,
                                  widget.appointment!.workshopID, rate);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                          style: kButtonsStyle,
                        )
                      ],
                    )),
              ),
            ),
          );
        },
        child: Text('Rate'),
        style: kButtonsStyle,
      ),
    );

    var reportButton = Expanded(
      child: ElevatedButton(
        onPressed: () async {
          var reportURL =
          await getAppoitmetReport(widget.appointment!.appointmentID);
          if (reportURL != null) {
            print('reportURL: $reportURL');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Report'),
                  ),
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: SfPdfViewer.network(
                          reportURL,
                          enableDoubleTapZooming: true,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Download'),
                        style: kButtonsStyle,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
        child: Text('Show Report'),
        style: kButtonsStyle,
      ),
    );

    var uploadReportButton = Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportPage(vin: widget.appointment!.VIN, Wid: widget.appointment!.workshopID,
              ),
            ),
          );
        },
        child: Text('Upload Report'),
        style: kButtonsStyle,
      ),
    );


    if (widget.cardType == 'Bookings') {
      if (widget.appointment!.status == 'booked') {
          buttons.add(payButton);
          buttons.add(SizedBox(width: 10));
          buttons.add(cancelButton);
    } else if (widget.appointment!.status == 'finished') {
        //buttons.add(uploadReportButton);
        buttons.add(rateButton);
        buttons.add(SizedBox(width: 10));
        buttons.add(reportButton);
      }
    } else if (widget.cardType == 'HistoryVIN') {
      buttons.add(reportButton);
    }
    else if (widget.cardType == 'Workshop') {
      buttons.add(uploadReportButton);
    }

    return buttons;
  }


  var kTextStyle = TextStyle(
      fontSize: 20,
      fontWeight:
      FontWeight.bold,
      color:
      Colors.black);
}
