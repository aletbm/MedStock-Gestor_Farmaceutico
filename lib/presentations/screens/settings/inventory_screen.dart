import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medstock/presentations/providers/inventory_provider.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: _InventoryView()
    );
  }
}

class _InventoryView extends ConsumerStatefulWidget {
  const _InventoryView();

  @override
  ConsumerState<_InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends ConsumerState<_InventoryView> {
  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryProvider);
    final colors = ref.watch(colorsProvider);
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 16),
      child: ListView(
        padding: EdgeInsets.only(bottom: 16),
        children: [
          ListTile(
            title: Text('Stock mínimo'),
            subtitle: Text('Configura el stock mínimo para recibir alertas'),
            trailing: Switch(value: inventoryState.stockMinimo, onChanged: (value) {
              ref.read(inventoryProvider.notifier).toggleStockMinimo(value);
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Opacity(
              opacity: inventoryState.stockMinimo ? 1 : 0.2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad mínima de alerta',
                            style: TextStyle(fontSize: 16)),
                        Text('Configura la cantidad mínima para recibir alertas',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.remove, size: 20),
                    onPressed: inventoryState.stockMinimo ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadMinimaAlerta(inventoryState.cantidadMinimaAlerta - 1);
                    } : null,
                  ),
                  Text('${inventoryState.cantidadMinimaAlerta}', style: TextStyle(fontSize: 18)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add, size: 20),
                    onPressed: inventoryState.stockMinimo ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadMinimaAlerta(inventoryState.cantidadMinimaAlerta + 1);
                    } : null,
                  ),
                ],
              ),
            ),
          ),
      
          Opacity(
            opacity: inventoryState.stockMinimo ? 1 : 0.2,
            child: ListTile(
              title: Text('Alertas de stock bajo'),
              subtitle: Text('Recibe alertas cuando el stock de un medicamento esté por debajo del mínimo'),
              trailing: Switch(value: inventoryState.alertasStockBajo, onChanged: (value) {
                  inventoryState.stockMinimo ? ref.read(inventoryProvider.notifier).toggleAlertasStockBajo(value) : null;
                }),
              ),
            ),
      
          ListTile(
            title: Text('Stock máximo'),
            subtitle: Text('Configura el stock máximo para evitar sobrestock'),
            trailing: Switch(value: inventoryState.stockMaximo, onChanged: (value) {
              ref.read(inventoryProvider.notifier).toggleStockMaximo(value);
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Opacity(
              opacity: inventoryState.stockMaximo ? 1 : 0.2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad máxima de alerta',
                            style: TextStyle(fontSize: 16)),
                        Text('Configura la cantidad máxima para recibir alertas',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.remove, size: 20),
                    onPressed: inventoryState.stockMaximo ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadMaximaAlerta(inventoryState.cantidadMaximaAlerta - 1);
                    } : null,
                  ),
                  Text('${inventoryState.cantidadMaximaAlerta}', style: TextStyle(fontSize: 18)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add, size: 20),
                    onPressed: inventoryState.stockMaximo ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadMaximaAlerta(inventoryState.cantidadMaximaAlerta + 1);
                    } : null,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Alertas de vencimiento'),
            subtitle: Text('Recibe alertas cuando un medicamento esté próximo a vencer'),
            trailing: Switch(value: inventoryState.alertasVencimiento, onChanged: (value) {
              ref.read(inventoryProvider.notifier).toggleAlertasVencimiento(value);
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Opacity(
              opacity: inventoryState.alertasVencimiento ? 1 : 0.2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad de días anticipados para alerta',
                            style: TextStyle(fontSize: 16)),
                        Text('Configura la cantidad de días antes del vencimiento para recibir alertas',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.remove, size: 20),
                    onPressed: inventoryState.alertasVencimiento ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadDiasAnticipados(inventoryState.cantidadDiasAnticipados - 1);
                    } : null,
                  ),
                  Text('${inventoryState.cantidadDiasAnticipados}', style: TextStyle(fontSize: 18)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add, size: 20),
                    onPressed: inventoryState.alertasVencimiento ? () async {
                      ref.read(inventoryProvider.notifier).setCantidadDiasAnticipados(inventoryState.cantidadDiasAnticipados + 1);
                    } : null,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Moneda'),
            subtitle: Text('Configura la moneda para mostrar los precios'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownMenu<String>(
                initialSelection: inventoryState.currencyCode,
                onSelected: (value) {
                  if (value != null) {
                    ref.read(inventoryProvider.notifier).setCurrencyCode(value);
                  }
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: 'ARS',
                    label: 'ARS - Peso Argentino',
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(colors['textOnSurface']),
                      backgroundColor: WidgetStateProperty.all(colors['cardBackground']),
                    ),
                  ),
                  DropdownMenuEntry(
                    value: 'USD',
                    label: 'USD - Dólar Estadounidense',
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(colors['textOnSurface']),
                      backgroundColor: WidgetStateProperty.all(colors['cardBackground']),
                    ),
                  ),
                  DropdownMenuEntry(
                    value: 'EUR',
                    label: 'EUR - Euro',
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(colors['textOnSurface']),
                      backgroundColor: WidgetStateProperty.all(colors['cardBackground']),
                    ),
                  ),
                ],
              ),
          )
        ],
      ),
    );
  }
}