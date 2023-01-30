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


  Future<Uint8List> createInvoice(List<Product> soldProducts,det,String WorkshopId,String serialNo) async {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
    // Step #################### correct
    final serial = await _firestore.collection('serial').doc(serialNo).get();
    //final workshop =await _firestore.collection('workshops').where('adminEmail', isEqualTo: WorkshopId).get();

    var e="";
    if(det!=""){
      e="Maintenance Details: ";
    }
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
 final image = (await rootBundle.load("images/Logo.png")).buffer.asUint8List();
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
                      pw.Text("Customer Name"),
                      pw.Text("Customer Address"),
                      pw.Text("Customer City"),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Max Weber"),
                      pw.Text("Weird Street Name 1"),
                      pw.Text("77662 Not my City"),
                      pw.Text("Vat-id: 123456"),
                      pw.Text("Invoice-Nr: 00001")
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Dear Customer, thanks for buying at Flutter Explained, feel free to see the list of items below."),
              pw.SizedBox(height: 25),
              itemColumn(elements),
              pw.Row(children: [
                pw.Text("$e"),
                pw.Text("$det")
              ]
      ),
              pw.SizedBox(height: 25),
              pw.Text("Thanks for your trust, and till the next time."),
              pw.SizedBox(height: 25),
              pw.Text("Kind regards,"),
              pw.SizedBox(height: 25),
              pw.Text("Max Weber")
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
    Future<void> savePdfFile(Appointment app,String mileage,Uint8List byteList) async {
      final _firestore = FirebaseFirestore.instance;
      var serial=app.serial;
      // Step #################### check ############# add services
      final ref = FirebaseStorage.instance.ref().child('Reports').child("$serial").child("$mileage"+'.pdf');
      final url = await ref.getDownloadURL();
      await _firestore.collection('Appointments').doc(app.appointmentID).update(
            {
              'reportURL': url,
              'status': "finished",
            },
          ).onError((error, stackTrace) => null);
      if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){await ref.putFile(File(byteList.toString()));}
      //Web
      else{await ref.putData(byteList);}
  }

  String getSubTotal(List<Product> products) {
    return products.fold(0.0,(double prev, element) => prev + (element.amount * element.price)).toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products.fold(0.0,(double prev, next) =>prev + ((next.price / 100 * next.vatInPercent) * next.amount),).toStringAsFixed(2);
  }
}