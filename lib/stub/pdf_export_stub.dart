import 'package:pdf/widgets.dart' as pw;

Future<void> exportToPDFWeb(pw.Document pdf) async {
  throw UnsupportedError("Cannot export PDF on this platform");
}

Future<void> exportToPDFMobile(pw.Document pdf) async {
  throw UnsupportedError("Cannot export PDF on this platform");
}
