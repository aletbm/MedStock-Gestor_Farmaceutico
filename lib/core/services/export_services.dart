import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:medstock/domain/entities/product.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ExportService {
  Future<File> exportProductsToCsv(List<Product> products) async {
    final rows = [
      ['id',
      'nombreComercial',
      'nombreGenerico',
      'concentracion',
      'formato',
      'presentacion',
      'laboratorio',
      'categoria',
      'stock',
      'precioVenta',
      'proveedor'],

      ...products.map((product) =>[
        product.id,
        product.nombreComercial,
        product.nombreGenerico,
        product.concentracion,
        product.formato,
        product.presentacion,
        product.laboratorio,
        product.categoria,
        product.stock,
        product.precioVenta,
        product.proveedor
      ]),
    ];

    final csvString = csv.encoder.convert(rows);
    final dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('${dir.path}/products_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvString, encoding: utf8);
    return file;
  }

  Future<void> shareFile(File file) async{
    await SharePlus.instance.share(
      ShareParams(
        text: 'Exportación de productos MedStock',
        files: [XFile(file.path)],
      ),
    );
  } 

  Future<File> exportProductsToPdf(List<Product> products, User? user) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('MedStock - Listado de Productos', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Generado el ${DateTime.now().toString().substring(0, 10)} por ${user?.name?? ""} ${user?.lastname ?? ""} con Matricula: ${user?.matricula ?? ""}',
              style: pw.TextStyle(fontSize: 10)
          ),
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: pw.FixedColumnWidth(30),
              1: pw.FlexColumnWidth(),
              2: pw.FlexColumnWidth(),
              3: pw.FixedColumnWidth(50),
              4: pw.FixedColumnWidth(50),
              5: pw.FixedColumnWidth(50),
              6: pw.FixedColumnWidth(50),
              7: pw.FixedColumnWidth(50),
              8: pw.FixedColumnWidth(30),
              9: pw.FixedColumnWidth(40),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey800),
                children: [
                  _headerCell('ID'),
                  _headerCell('Nombre Comercial'),
                  _headerCell('Nombre Genérico'),
                  _headerCell('Concentración'),
                  _headerCell('Formato'),
                  _headerCell('Presentación'),
                  _headerCell('Laboratorio'),
                  _headerCell('Categoría'),
                  _headerCell('Stock'),
                  _headerCell('Precio de Venta'),
                  _headerCell('Proveedor')
                ],
              ),
              ...products.map((product) => pw.TableRow(
                children: [
                  _dataCell(product.id.toString()),
                  _dataCell(product.nombreComercial),
                  _dataCell(product.nombreGenerico),
                  _dataCell(product.concentracion),
                  _dataCell(product.formato),
                  _dataCell(product.presentacion),
                  _dataCell(product.laboratorio),
                  _dataCell(product.categoria),
                  _dataCell(product.stock.toString()),
                  _dataCell('\$${product.precioVenta.toStringAsFixed(2)}'),
                  _dataCell(product.proveedor)
                ]
              )),
            ],
          ),
        ]
      )
    );

    final bytes = await doc.save();
    final dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('${dir.path}/products_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes); 
    return file;
  }

  pw.Widget _headerCell(String text) => pw.Padding(
    padding: pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
      ),
    ),
  );

  pw.Widget _dataCell(String text) => pw.Padding(
    padding: pw.EdgeInsets.all(6),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 9)),
  );
}