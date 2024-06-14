import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

Future<void> exportToPDFWeb(pw.Document pdf) async {
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'output.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}
