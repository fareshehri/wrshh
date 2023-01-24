import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '/Pages/workshopTechnical/invoice_service.dart';
import '/Models/product.dart';

class CreatePdf extends StatefulWidget {
  const CreatePdf({super.key});

  @override
  State<CreatePdf> createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
   final PdfInvoiceService service = PdfInvoiceService();
    // Steps
   //Get Products from Report.dart add it here
  List<Product> products = [
    Product("Membership", 9.99, 15),
    Product("Nails", 0.30, 15),
    Product("Hammer", 26.43, 15),
    Product("Hamburger", 5.99, 15),
  ];
  //Number of invoice not so important ex. Invoice0 then invoice 1 etc....
  int number = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final currentProduct = products[index];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("VAT"), Text("${getVat()} ﷼")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Total"), Text("${getTotal()} ﷼")],
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await service.createInvoice(products);
                service.savePdfFile("invoice_$number", data);
                number++;
              },
              child: const Text("Create Invoice"),
            ),
          ],
        ),
      ),
    );
  }

  getTotal() => products
      .fold(0.0, (double prev, element) => prev + (element.price * element.amount))
      .toStringAsFixed(2);

  getVat() => products
      .fold(
          0.0,
          (double prev, element) =>
              prev + (element.price / 100 * element.vatInPercent * element.amount))
      .toStringAsFixed(2);

  }
