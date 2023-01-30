import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wrshh/Models/appointment.dart';

import '/Models/product.dart';
import 'invoice_service.dart';

class ReportPage extends StatefulWidget {
  final Appointment app;
  const ReportPage({super.key,required this.app});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool gotPath = false;
  final PdfInvoiceService service = PdfInvoiceService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
    // Step #################### correct
   //Get Products from Report.dart add it here
  List<Product> products = [
    Product("Membership", 9.99, 15),
    // Product("Nails", 0.30, 15),
    // Product("Hammer", 26.43, 15),
    // Product("Hamburger", 5.99, 15),
  ];
    List<Product> services = [
  ];
  var det="";
  var mileage;
  List<Uint8List?> file=[];
  List<Product> fin=[];

  Future _getServices() async {
    // Step 
// init var serv for services || var ser for service || var pri for price
    var serv;
    var counter =0;
    List ser=[];
    List pri=[];
    // Step ####### correct
    //final wService = await _firestore.collection('workshopAdmin').doc(widget.Wid).get().then((value)
    final workshopDB = await _firestore.collection('workshops').doc(widget.app.workshopID).get();
    var email = workshopDB.data()!['adminEmail'];
    final wService = await _firestore.collection('workshopAdmins').doc(email).get().then((value) {
    setState(() {
      serv=value["services"];
      for (var element in serv["service"]) {
        ser.add(element);
        counter++;
        }
      for (var element in serv["price"]) {
        pri.add(double.parse(element));
        }
      for (var i=0; i< counter;i++) {
        services.add(Product (ser[i],pri[i],15));
      }
      });

        },);
    setState(() {gotPath = true;});
    }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getServices();
    // var Sercounter =services.length;
    // var Procounter =products.length;
    // print(Sercounter);
    // print(Procounter);
  }
final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!gotPath){
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(),
      ),
    );
  }
  else{
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Invoice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
// Step
// Services            
            SizedBox(height: 10),
            Text('Services',style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ),),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, Sercounter) {
                  final currentService = services[Sercounter];
                  return Row(
                    children: [
                      Expanded(child: Text(currentService.name)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Price: ${currentService.price.toStringAsFixed(2)} ﷼"),
                            Text("VAT ${currentService.vatInPercent.toStringAsFixed(0)} %")
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() => currentService.amount++);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                currentService.amount.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(currentService.amount>0){
                                      currentService.amount--;
                                    }
                                  },);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
                itemCount: services.length,
              ),
            ),
// Step
// Products 
            SizedBox(height: 20),
            Text('Products',style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ),),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, Procounter) {
                  final currentProduct = products[Procounter];
                  return Row(
                    children: [
                      Expanded(child: Text(currentProduct.name)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Price: ${currentProduct.price.toStringAsFixed(2)} ﷼"),
                            Text("VAT ${currentProduct.vatInPercent.toStringAsFixed(0)} %")
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() => currentProduct.amount++);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                currentProduct.amount.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(currentProduct.amount>0){
                                      currentProduct.amount--;
                                    }
                                  },);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
                itemCount: products.length,
              ),
            ),
// Step            
// Step add  Mileage

const SizedBox(height: 10,),


              Form(key: _formKey,child: Column(
                children: [
                  const Text('Mileage/Odometer'),

              TextFormField(onChanged: (value) => mileage=value,maxLines: 2,decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Enter Car Mileage/Odometer'),inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],validator: (value) {
                    if (value == null || value.isEmpty ) {return 'Please enter Mileage/Odometer';}
                    return null;
                    },),
              const SizedBox(height: 20,),

// Step            
// Step add comment




              const Text('Details'),
              TextFormField(onChanged: (value) => det=value,maxLines: 3,decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Enter Maintenance Comments'),
              // validator: (value) {
              //       if (value == null || value.isEmpty ) {return 'Please enter Maintenance Details';}
              //       return null;
              //       },),
              // const SizedBox(height: 30,),
              //                 ],
              // )
              ),
              const SizedBox(height: 10,),

// Step
//Calculate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Price"), Text("${getPrice()} ﷼")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("VAT"), Text("${getVat()} ﷼")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Total"), Text("${getTotal()} ﷼")],
            ),
            Row(
              children: [
                // Step (Delete it ???) 
                //Expanded(child: ElevatedButton(onPressed: getFiles, child: Icon(Icons.upload_file))),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      var finser=[];
                      try{
                      if (_formKey.currentState!.validate()) {
                      // change to final products
                      for (var i = 0; i < services.length; i++) {
                        if(services[i].amount>=1){
                          fin.add(services[i]);
                          finser.add(services[i]);
                        }
                        }
                        for (var i = 0; i < products.length; i++) {
                        if(products[i].amount>=1){
                          fin.add(products[i]);
                        }
                                        }
                      final data = await service.createInvoice(fin,det,widget.app.workshopID,widget.app.serial);
                      await service.savePdfFile(widget.app,mileage,finser,getTotal(),data);
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice Created Successfully')),);
                        Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                      });
                    }
                    }
                    catch (e){
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice has not been Created')),);
                    }
                    },
                    child: const Text("Create Invoice"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        ])
    )
    );
    
  }
  }
  getPrice(){
    var x=products.fold(0.0, (double prev, element) => prev + (element.price * element.amount)).toStringAsFixed(2);
    var z=services.fold(0.0, (double prev, element) => prev + (element.price * element.amount)).toStringAsFixed(2);
    var c =double.parse(x)+double.parse(z);
    return c.toStringAsFixed(2);
  }

  getVat() {
    var x=products.fold(0.0,(double prev, element) =>prev + (element.price / 100 * element.vatInPercent * element.amount)).toStringAsFixed(2);
    var z= services.fold(0.0,(double prev, element) =>prev + (element.price / 100 * element.vatInPercent * element.amount)).toStringAsFixed(2);
    var c =double.parse(x)+double.parse(z);
    return c.toStringAsFixed(2);
    }
  
  
  getTotal() {
    var x =products.fold(0.0, (double prev, element) => prev + (element.price * element.amount+(element.price / 100 * element.vatInPercent * element.amount))).toStringAsFixed(2);
    var z =services.fold(0.0, (double prev, element) => prev + (element.price * element.amount+(element.price / 100 * element.vatInPercent * element.amount))).toStringAsFixed(2);
    var c =double.parse(x)+double.parse(z);
    return c.toStringAsFixed(2);

  }

  getFiles()async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom,
  allowedExtensions: ['pdf',],);
    if (result != null) {
      for (var i = 0; i < result.files.length; i++) {
        file.add(result.files.elementAt(i).bytes);
      }
}

   else {
    print("No file selected");
}

  }
   

  }
