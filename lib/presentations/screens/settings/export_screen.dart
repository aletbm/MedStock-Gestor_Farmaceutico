import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medstock/core/services/export_services.dart';
import 'package:medstock/presentations/providers/product_provider.dart';
import 'package:medstock/presentations/providers/user_provider.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exportar Datos')),
      body: _ExportView(),
    );
  }
}

class _ExportView extends ConsumerStatefulWidget {
  const _ExportView();

  @override
  ConsumerState<_ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends ConsumerState<_ExportView> {
  bool _isLoadingCsv = false;
  bool _isLoadingPdf = false;

  @override
  Widget build(BuildContext context) {
    final productos = ref.watch(productListProvider);
    final userData = ref.watch(currentUserProvider);

    void showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Exportar productos a CSV',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Puedes exportar la lista de productos a un archivo CSV para compartir o guardar una copia de seguridad.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoadingCsv ? null : () async {
              setState(() => _isLoadingCsv = true);
      
              try {
                final exportService = ExportService();
                final file = await exportService.exportProductsToCsv(productos);
                await exportService.shareFile(file);
              } catch(e) {
                showSnack('No se pudo exportar los datos a formato CSV.');
              } finally {
                setState(() => _isLoadingCsv = false);
              }
            },
            icon: _isLoadingCsv
                ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.file_download),
            label: Text(_isLoadingCsv ? 'Exportando...' : 'Exportar a CSV'),
          ),
          Divider(),
          Text(
            'Exportar productos a PDF',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Puedes exportar la lista de productos a un archivo PDF para imprimir o compartir.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoadingPdf ? null : () async {
              setState(() => _isLoadingPdf = true);
              try {
                final exportService = ExportService();
                final file = await exportService.exportProductsToPdf(productos, userData);
                await exportService.shareFile(file);
              } catch(e) {
                showSnack('No se pudo exportar los datos a formato PDF.');
              } finally {
                setState(() => _isLoadingPdf = false);
              }
            },
            icon: _isLoadingPdf
                ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.file_download),
            label: Text(_isLoadingPdf ? 'Exportando...' : 'Exportar a PDF'),
          ),
        ],
      ),
    );
  }
}