import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class PDFPage extends StatefulWidget {
  final String reportURL;
  const PDFPage({Key? key, required this.reportURL}) : super(key: key);

  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  bool gotPath = false;
  var reprotData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var reportData = await InternetFile.get(widget.reportURL);
    setState(() {
      reprotData = reportData;
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Report'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PdfView(
                  controller: PdfController(
                    document: PdfDocument.openData(reprotData),
                  ),
                  

                )),
          ],
        ),
      );
    }
  }
}
