import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/presentations/providers/inventory_provider.dart';
import 'package:medstock/presentations/providers/product_provider.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/widgets/custom_drawer.dart';
import 'package:intl/intl.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProductListView();
  }
}

class _ProductListView extends ConsumerWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);
    final productos = ref.watch(productListProvider);
    final currencyCode = ref.watch(inventoryProvider).currencyCode;
    final inventoryState = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title:Text('Medicamentos')),
      drawer: CustomDrawer(),
      body:ListView.builder(
        padding: EdgeInsets.only(bottom: 130),
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push('/product-details', extra: producto),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(producto.nombreComercial, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              Text('${producto.nombreGenerico} ${producto.concentracion}', style: TextStyle(fontSize: 13, color: colors['textSubtle'])),
                              Text('${producto.formato} · ${producto.presentacion} · ${producto.laboratorio}', style: TextStyle(fontSize: 12, color: colors['textSubtle'])),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if(inventoryState.stockMinimo && producto.stock <= inventoryState.cantidadMinimaAlerta) 
                              Column(
                                children: [
                                  Icon(Icons.warning, size: 18),
                                  Text("Stock Bajo", style: TextStyle(fontSize: 10, color: colors["danger"]),),
                                ],
                              ),
                            if(inventoryState.stockMaximo && producto.stock >= inventoryState.cantidadMaximaAlerta) 
                              Column(
                                children: [
                                  Icon(Icons.trending_up, size: 18, color: colors["onDanger"]),
                                  Text("Sobrestock", style: TextStyle(fontSize: 10, color: colors["onDanger"]),),
                                ],
                              ),
                            IconButton(
                              onPressed: () => context.push('/product-form', extra: {'mode': 'edit', 'producto': producto}), 
                              icon: Icon(Icons.edit, size: 20)
                            ),
                            IconButton(
                              onPressed: () => _showDeleteConfirmation(context, ref, producto.id!),
                              icon: Icon(Icons.delete, size: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: colors['stockBackground'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  icon: Icon(Icons.remove, size: 16),
                                  onPressed: () async {
                                    if (producto.stock > 0) {
                                      await ref.read(productListProvider.notifier).updateProduct(producto.copyWith(stock: producto.stock - 1));
                                    }
                                  },
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Stock', style: TextStyle(fontSize: 12, color: colors['stockLabel'])),
                                    Text('${producto.stock}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colors['stockValue'])),
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  icon: Icon(Icons.add, size: 16),
                                  onPressed: () async {
                                    await ref.read(productListProvider.notifier).updateProduct(producto.copyWith(stock: producto.stock + 1));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: colors['priceBackground'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Precio', style: TextStyle(fontSize: 12, color: colors['priceLabel'])),
                                Text(formatPrice(producto.precioVenta, currencyCode), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colors['priceValue'])),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/product-form', extra: {'mode': 'add'}),
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showDeleteConfirmation(BuildContext context, WidgetRef ref, int productId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar eliminación'),
      content: Text('¿Estás seguro de que deseas eliminar este producto?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final router = GoRouter.of(context);
            await ref.read(productListProvider.notifier).deleteProduct(productId).then((_) => router.pop());
          },
          child: Text('Eliminar', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ],
    ),
  );
}

String formatPrice(double price, String currencyCode) {
  final formatter = NumberFormat.currency(
    locale: 'es_AR',
    symbol: currencyCode == 'ARS' ? '\$'
          : currencyCode == 'USD' ? 'U\$D '
          : currencyCode == 'EUR' ? '€ '
          : '\$',
    decimalDigits: 2,
  );
  return formatter.format(price);
}