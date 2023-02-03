import 'dart:io';

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrshh/Models/appointment.dart';

import '/Models/product.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;
  final String vat;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total, this.vat);
}


class PdfInvoiceService {


  Future<Uint8List> createInvoice(List<Product> soldProducts,det,String WorkshopId,String serialNo,var mileage) async {
    var manu;
    var mak;
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
    // Step #################### correct
    final serial = await _firestore.collection('serial').doc(serialNo).get();
    //final workshop =await _firestore.collection('workshops').where('adminEmail', isEqualTo: WorkshopId).get();
     if(serial['carManufacturer']=='other'){
      manu=serial['otherBrand'];
      mak=serial['otherCar'];
    }
    else{
      manu=serial['carManufacturer'];
      mak=serial['carModel'];
    }
    var e="";
    if(det!=""){
      e="Maintenance Details: ";
    }

    final workshop = await _firestore.collection('workshops').doc(WorkshopId).get();
    var email = workshop.data()!['technicianEmail'];
    final workshopt = await _firestore.collection('workshopTechnicians').doc(email).get();


    final pdf = pw.Document();

    // Step Calc
    // Here it will calculate and get sub total vat total and price total
    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount","Vat" , "Total"),
      for (var product in soldProducts)
        CustomRow(
          product.name,
          product.price.toStringAsFixed(2),
          product.amount.toStringAsFixed(2),
          (product.vatInPercent/100 * product.price*product.amount).toStringAsFixed(2),
          (product.price * product.amount+(product.vatInPercent/100 * product.price*product.amount)).toStringAsFixed(2),
        ),
      CustomRow(
        "Sub Total",
        "",
        "",
        "",
        "${getSubTotal(soldProducts)} SAR",
      ),
      CustomRow(
        "Vat Total",
        "",
        "",
        "",
        "${getVatTotal(soldProducts)} SAR",
      ),
      CustomRow(
        "Price Total",
        "",
        "",
        "",
        "${(double.parse(getSubTotal(soldProducts)) + double.parse(getVatTotal(soldProducts))).toStringAsFixed(2)} SAR",
      )
      // ,CustomRow(
      //   "$e",
      //   "$det",
      //   "",
      //   "",
      //   "",
      // ),
      
    ];
  // Step Image
  // Here it will add the image
 final image = (await rootBundle.load("assets/images/Logo.png")).buffer.asUint8List();
 // Step Info
 //Here it will add header info such as client name address and company name address etc...
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image),width: 150, height: 150, fit: pw.BoxFit.cover),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    // Step ####### correct
                    children: [
                      pw.Text("Manufacturer: $manu"),
                      pw.Text("Model: $mak"),
                      pw.Text("Year: ${serial['carYear']}"),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Workshop: ${workshop['workshopName']}"),
                      pw.Text("Technician: ${workshopt['name']}"),
                      pw.Text("Contact: ${workshopt['phoneNumber']}"),
                      pw.Text("Serial Number: $serialNo"),
                      pw.Text("Odometer: $mileage"),
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Dear Customer, thanks for Trusting us at ${workshop['workshopName']}, the list below contains requested Services & Products."),
              pw.SizedBox(height: 25),
              itemColumn(elements),
              pw.Row(children: [
                pw.Text("$e"),
                pw.Text("$det")
              ]
      ),
              pw.SizedBox(height: 25),
              pw.Text(" "),
              pw.SizedBox(height: 25),
              pw.Text(" "),
              pw.SizedBox(height: 25),
              pw.Text("Thanks for your trust, and till the next time.")
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text(element.itemName,
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(
                    child: pw.Text(element.itemPrice,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.total, textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
              ],
            ),
        ],
      ),
    );
  }

// Step Savepdf file and push it 
// Here it will save a pdf version on the device and on the cloud.
    Future<void> savePdfFile(Appointment app,String mileage,List ser,String tot,Uint8List byteList) async {
      final _firestore = FirebaseFirestore.instance;
      var serial=app.serial;
      // Step #################### check ############# update services
      try{
      final ref = FirebaseStorage.instance.ref().child('Reports').child("$serial").child("$mileage"+'.pdf');

      await ref.putData(byteList);
      final url = await ref.getDownloadURL();
      await _firestore.collection('Appointments').doc(app.appointmentID).update(
            {
              'reportURL': url,
              'status': "finished",
              'services':ser,
              'price':double.parse(tot)
            },
          ).onError((error, stackTrace) => null);
          print('1');
      }
      catch (e){
        print(e);
      }
  }

  String getSubTotal(List<Product> products) {
    return products.fold(0.0,(double prev, element) => prev + (element.amount * element.price)).toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products.fold(0.0,(double prev, next) =>prev + ((next.price / 100 * next.vatInPercent) * next.amount),).toStringAsFixed(2);
  }
}