import 'package:flutter/material.dart';

import 'package:rate/rate.dart';
import 'package:wrshh/Models/workshop.dart';
import 'package:wrshh/Pages/workshopAdmin/workshop_details.dart';

import '../Services/Auth/workshopAdmin_database.dart';


class WorkshopsCard extends StatefulWidget {
  final String? workshopName;
  final String? workshopID;
  final double? itemHeight;
  final Workshop workshop;

  const WorkshopsCard({
    required this.workshopName,
    required this.workshop,
    required this.workshopID,
    this.itemHeight,
  });

  @override
  State<WorkshopsCard> createState() => _WorkshopsCardState();
}

class _WorkshopsCardState extends State<WorkshopsCard> {
  late String logoURL = '';
  late double rate = 0;
  var technicianName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var appointmentlogo = await getWorkshopLogoFromDB(widget.workshopID!);
    var technicianNameDB = await getTechnicianNameFromDB(widget.workshop.technicianEmail);
    setState(() {
      logoURL = appointmentlogo;
      technicianName = technicianNameDB;
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
                  widget.workshop!.logoURL,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(widget.workshop!.workshopName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(technicianName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Rate(
                      iconSize: 20,
                      color: Colors.green,
                      allowHalf: true,
                      allowClear: true,
                      initialValue: widget.workshop!.overallRate,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text('based on ${widget.workshop!.numOfRates} rates',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.black)),
                  ),
                ],
              ),
              FittedBox(
                alignment: Alignment.bottomRight,
                fit: BoxFit.fitWidth,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkshopDetails(
                            workshop: widget.workshop,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View Details',
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ButtonStyle kButtonsStyle = ElevatedButton.styleFrom(
    primary: Colors.pink,
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );

  var kTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
}
