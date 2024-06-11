import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:html' as html if (dart.library.io) 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../service/api_service.dart';

class DataTableScreen extends StatefulWidget {
  @override
  _DataTableScreenState createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
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

  Future<void> _exportToExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      if (_data.isNotEmpty) {
        // Añadir encabezados de columnas
        List<String> headers = _data[0].keys.toList();
        sheetObject.appendRow(headers);

        // Añadir datos
        for (var row in _data) {
          List<dynamic> values = headers.map((header) => row[header]).toList();
          sheetObject.appendRow(values);
        }

        // Guardar archivo
        if (kIsWeb) {
          // Guardar archivo en la web
          final bytes = excel.encode()!;
          final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'output.xlsx')
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Guardar archivo en otras plataformas
          Directory directory = await getApplicationDocumentsDirectory();
          String outputPath = '${directory.path}/output.xlsx';
          File(outputPath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(excel.encode()!);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Archivo Excel guardado en $outputPath')),
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
        SnackBar(content: Text('Error exporting to Excel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Datos'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportToExcel,
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
