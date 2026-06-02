import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/product.dart';
import 'package:medstock/presentations/providers/product_provider.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/widgets/form_widgets.dart';

class ProductFormScreen extends StatelessWidget {
  final Product? producto;
  final String mode;
  const ProductFormScreen({super.key, required this.mode, this.producto});

  @override
  Widget build(BuildContext context) {
    final bool addMode = mode == 'add';
    return Scaffold(
      appBar: AppBar(title: Text(addMode ? 'Agregar medicamento' : 'Editar medicamento')),
      body: _ProductFormView(addMode: addMode, producto: producto),
      resizeToAvoidBottomInset: true,
    );
  }
}

class _ProductFormView extends ConsumerStatefulWidget {
  final bool addMode;
  final Product? producto;
  const _ProductFormView({required this.addMode, this.producto});

  @override
  ConsumerState<_ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends ConsumerState<_ProductFormView> {
  late final TextEditingController nombreComercialController;
  late final TextEditingController nombreGenericoController;
  late final TextEditingController concentracionController;
  late final TextEditingController formatoController;
  late final TextEditingController presentacionController;
  late final TextEditingController laboratorioController;
  late final TextEditingController categoriaController;
  late final TextEditingController stockController;
  late final TextEditingController precioVentaController;
  late final TextEditingController proveedorController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nombreComercialController = TextEditingController(text: widget.addMode ? '' : widget.producto?.nombreComercial);
    nombreGenericoController  = TextEditingController(text: widget.addMode ? '' : widget.producto?.nombreGenerico);
    concentracionController   = TextEditingController(text: widget.addMode ? '' : widget.producto?.concentracion);
    formatoController         = TextEditingController(text: widget.addMode ? '' : widget.producto?.formato);
    presentacionController    = TextEditingController(text: widget.addMode ? '' : widget.producto?.presentacion);
    laboratorioController     = TextEditingController(text: widget.addMode ? '' : widget.producto?.laboratorio);
    categoriaController       = TextEditingController(text: widget.addMode ? '' : widget.producto?.categoria);
    stockController           = TextEditingController(text: widget.addMode ? '' : widget.producto?.stock.toString());
    precioVentaController     = TextEditingController(text: widget.addMode ? '' : widget.producto?.precioVenta.toStringAsFixed(2));
    proveedorController       = TextEditingController(text: widget.addMode ? '' : widget.producto?.proveedor);
  }

  @override
  void dispose() {
    nombreComercialController.dispose();
    nombreGenericoController.dispose();
    concentracionController.dispose();
    formatoController.dispose();
    presentacionController.dispose();
    laboratorioController.dispose();
    categoriaController.dispose();
    stockController.dispose();
    precioVentaController.dispose();
    proveedorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(colorsProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          SectionHeader(title: 'Identificación', icon: Icons.label_outline, colors: colors),
          const SizedBox(height: 8),
          FormCard(colors: colors, children: [
            FormFieldRow(controller: nombreComercialController, label: 'Nombre comercial', icon: Icons.medication),
            FormFieldRow(controller: nombreGenericoController,  label: 'Nombre genérico',  icon: Icons.science_outlined),
            FormFieldRow(controller: concentracionController,   label: 'Concentración',    icon: Icons.water_drop_outlined, isLast: true),
          ]),

          const SizedBox(height: 20),

          SectionHeader(title: 'Detalles', icon: Icons.info_outline, colors: colors),
          const SizedBox(height: 8),
          FormCard(colors: colors, children: [
            FormFieldRow(controller: formatoController,      label: 'Formato',      icon: Icons.category_outlined),
            FormFieldRow(controller: presentacionController, label: 'Presentación', icon: Icons.inventory_2_outlined),
            FormFieldRow(controller: laboratorioController,  label: 'Laboratorio',  icon: Icons.business_outlined),
            FormFieldRow(controller: categoriaController,    label: 'Categoría',    icon: Icons.local_pharmacy_outlined, isLast: true),
          ]),

          const SizedBox(height: 20),

          SectionHeader(title: 'Stock y Precio', icon: Icons.bar_chart, colors: colors),
          const SizedBox(height: 8),
          FormCard(colors: colors, children: [
            FormFieldRow(controller: stockController,       label: 'Stock',           icon: Icons.warehouse_outlined,    keyboardType: TextInputType.number),
            FormFieldRow(controller: precioVentaController, label: 'Precio de venta', icon: Icons.attach_money,          keyboardType: TextInputType.number),
            FormFieldRow(controller: proveedorController,   label: 'Proveedor',       icon: Icons.local_shipping_outlined, isLast: true),
          ]),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(widget.addMode ? 'Agregar medicamento' : 'Guardar cambios',
                          style: const TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final router = GoRouter.of(context);

    final String nombreComercial = nombreComercialController.text.trim();
    final String nombreGenerico  = nombreGenericoController.text.trim();
    final String concentracion   = concentracionController.text.trim();
    final String formato         = formatoController.text.trim();
    final String presentacion    = presentacionController.text.trim();
    final String laboratorio     = laboratorioController.text.trim();
    final String categoria       = categoriaController.text.trim();
    final String stock           = stockController.text.trim();
    final String precioVenta     = precioVentaController.text.trim();
    final String proveedor       = proveedorController.text.trim();

    void showSnack(String msg) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    int? stockParsed;
    double? precioParsed;
    bool valido = true;
    String messages = '';

    if (nombreComercial.isEmpty) { messages += '- Ingresá el nombre comercial\n'; valido = false; }
    if (nombreGenerico.isEmpty)  { messages += '- Ingresá el nombre genérico\n';  valido = false; }
    if (concentracion.isEmpty)   { messages += '- Ingresá la concentración\n';    valido = false; }
    if (formato.isEmpty)         { messages += '- Ingresá el formato\n';           valido = false; }
    if (presentacion.isEmpty)    { messages += '- Ingresá la presentación\n';      valido = false; }
    if (laboratorio.isEmpty)     { messages += '- Ingresá el laboratorio\n';       valido = false; }
    if (categoria.isEmpty)       { messages += '- Ingresá la categoría\n';         valido = false; }
    if (proveedor.isEmpty)       { messages += '- Ingresá el proveedor\n';         valido = false; }

    if (stock.isEmpty) {
      messages += '- Ingresá el stock\n'; valido = false;
    } else {
      stockParsed = int.tryParse(stock);
      if (stockParsed == null)  { messages += '- El stock debe ser un número entero\n'; valido = false; }
      else if (stockParsed < 0) { messages += '- El stock no puede ser negativo\n';     valido = false; }
    }

    if (precioVenta.isEmpty) {
      messages += '- Ingresá el precio de venta\n'; valido = false;
    } else {
      precioParsed = double.tryParse(precioVenta.replaceAll(',', '.'));
      if (precioParsed == null)   { messages += '- El precio debe ser un número válido\n'; valido = false; }
      else if (precioParsed <= 0) { messages += '- El precio debe ser mayor a cero\n';     valido = false; }
    }

    if (!valido) { showSnack(messages); return; }

    setState(() => _isLoading = true);

    final product = Product(
      id:              widget.addMode ? null : widget.producto!.id,
      nombreComercial: nombreComercial,
      nombreGenerico:  nombreGenerico,
      concentracion:   concentracion,
      formato:         formato,
      presentacion:    presentacion,
      laboratorio:     laboratorio,
      categoria:       categoria,
      stock:           stockParsed!,
      precioVenta:     precioParsed!,
      proveedor:       proveedor,
    );

    try {
      if (widget.addMode) {
        await ref.read(productListProvider.notifier).addProduct(product);
      } else {
        await ref.read(productListProvider.notifier).updateProduct(product);
      }
      if (!mounted) return;
      router.pop();
    } catch (e) {
      if (!mounted) return;
      showSnack('Error al guardar el producto.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}