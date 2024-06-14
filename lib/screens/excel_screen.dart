import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:html' as html if (dart.library.io) 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import '../service/api_service.dart';

class ExcelExportScreen extends StatefulWidget {
  @override
  _ExcelExportScreenState createState() => _ExcelExportScreenState();
}

class _ExcelExportScreenState extends State<ExcelExportScreen> {
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

  // Función asincrónica para exportar los datos a un archivo Excel
  Future<void> _exportToExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      if (_data.isNotEmpty) {
        // Agregar encabezados de columnas
        List<String> headers = _data[0].keys.toList();
        sheetObject.appendRow(headers);

        // Agregar datos de filas
        for (var row in _data) {
          List<dynamic> values = headers.map((header) => row[header]).toList();
          sheetObject.appendRow(values);
        }

        // Guardar archivo Excel
        if (kIsWeb) {
          // Guardar archivo en la web
          final bytes = excel.encode()!;
          final blob = html.Blob([
            bytes
          ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'output.xlsx')
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Guardar archivo en otras plataformas (como Android e iOS)
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
  // Método build para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Datos'), // Título de la pantalla
        actions: [
          IconButton(
            icon: Icon(Icons.download), // Icono para exportar a Excel
            onPressed: _exportToExcel, // Acción al presionar el botón de exportar
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Desplazamiento horizontal para la tabla
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