import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html if (dart.library.io) 'dart:io';
import '../service/api_service.dart';

class PdfExportScreen extends StatefulWidget {
  @override
  _PdfExportScreenState createState() => _PdfExportScreenState();
}

class _PdfExportScreenState extends State<PdfExportScreen> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Map<String, dynamic>> data = await ApiService.fetchData();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _exportToPDF() async {
    try {
      final pdf = pw.Document();
      if (_data.isNotEmpty) {
        // Añadir encabezados de columnas
        List<String> headers = _data[0].keys.toList();
        // Añadir datos
        List<List<String>> data = _data.map((row) {
          return headers.map((header) => row[header].toString()).toList();
        }).toList();

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                headers: headers,
                data: data,
              );
            },
          ),
        );

        // Guardar archivo
        if (kIsWeb) {
          // Guardar archivo en la web
          final bytes = await pdf.save();
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'output.pdf')
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Guardar archivo en otras plataformas
          Directory directory = await getApplicationDocumentsDirectory();
          String outputPath = '${directory.path}/output.pdf';
          File(outputPath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(await pdf.save());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Archivo PDF guardado en $outputPath')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay datos para exportar')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting to PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exportar Datos a PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportToPDF,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _data.isNotEmpty
                    ? _data[0]
                        .keys
                        .map((key) => DataColumn(label: Text(key)))
                        .toList()
                    : [DataColumn(label: Text('No hay datos'))],
                rows: _data
                    .map(
                      (item) => DataRow(
                        cells: item.values
                            .map((value) => DataCell(Text(value.toString())))
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
