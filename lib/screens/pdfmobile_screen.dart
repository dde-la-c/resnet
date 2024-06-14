import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io' as io;

Future<void> exportToPDFMobile(pw.Document pdf) async {
  Directory directory = await getApplicationDocumentsDirectory();
  String outputPath = '${directory.path}/output.pdf';
  io.File(outputPath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(await pdf.save());
}
