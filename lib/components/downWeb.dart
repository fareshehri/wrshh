import 'dart:html'as html;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
Future<void> downloadWeb(Uint8List byteslist) async{
        final output = await getTemporaryDirectory();
        final blob = html.Blob([byteslist]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'report.pdf';
        html.document.body?.children.add(anchor);

// download
anchor.click();

// cleanup
html.document.body?.children.remove(anchor);
html.Url.revokeObjectUrl(url);
    }