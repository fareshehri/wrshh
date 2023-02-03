import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_document/open_document.dart';
Future<void> downloadApp(Uint8List byteslist) async{
  final output = await getTemporaryDirectory();
    var filePath = "${output.path}/report.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteslist);
    await OpenDocument.openDocument(filePath: filePath);
    }