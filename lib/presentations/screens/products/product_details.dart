import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/product.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product producto;
  const ProductDetailsScreen({super.key, required this.producto});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(colorsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push(
                  '/product-form',
                  extra: {'mode': 'edit', 'producto': widget.producto},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.producto.nombreComercial,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.producto.nombreGenerico,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Tab indicators
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TabChip(label: 'Información', active: currentPage == 0, colors: colors, onTap: () {
                        _controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }),
                      const SizedBox(width: 8),
                      _TabChip(label: 'Stock', active: currentPage == 1, colors: colors, onTap: () {
                        _controller.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }),
                    ],
                  ),
                ),

                SizedBox(
                  height: 420,
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) => setState(() => currentPage = index),
                    children: [
                      _ProductInfo(producto: widget.producto, colors: colors),
                      _ProductStock(producto: widget.producto, colors: colors),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final Map<String, Color?> colors;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.active, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: active ? colors['primary'] : colors['stockBackground'],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : colors['textSubtle'],
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product producto;
  final Map<String, Color?> colors;
  const _ProductInfo({required this.producto, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Center(
            child: Image.asset('assets/images/medicine.png', height: 180),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            colors: colors,
            children: [
              _DetailRow(icon: Icons.science_outlined,      label: 'Concentración', value: producto.concentracion, colors: colors),
              _DetailRow(icon: Icons.category_outlined,     label: 'Formato',       value: producto.formato,       colors: colors),
              _DetailRow(icon: Icons.inventory_2_outlined,  label: 'Presentación',  value: producto.presentacion,  colors: colors),
              _DetailRow(icon: Icons.business_outlined,     label: 'Laboratorio',   value: producto.laboratorio,   colors: colors),
              _DetailRow(icon: Icons.label_outline,         label: 'Categoría',     value: producto.categoria,     colors: colors, isLast: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductStock extends StatelessWidget {
  final Product producto;
  final Map<String, Color?> colors;
  const _ProductStock({required this.producto, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Center(
            child: Image.asset('assets/images/proveedor.jpg', height: 180),
          ),
          const SizedBox(height: 16),

          // Chips de stock y precio
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.warehouse_outlined,
                  label: 'Stock',
                  value: '${producto.stock} unidades',
                  colors: colors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money,
                  label: 'Precio',
                  value: '\$${producto.precioVenta.toStringAsFixed(2)}',
                  colors: colors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _SectionCard(
            colors: colors,
            children: [
              _DetailRow(icon: Icons.local_shipping_outlined, label: 'Proveedor', value: producto.proveedor, colors: colors, isLast: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  final Map<String, Color?> colors;

  const _SectionCard({required this.children, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors['stockBackground'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Map<String, Color?> colors;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors['primary']),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(fontSize: 13, color: colors['textSubtle'])),
              const Spacer(),
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors['textPrimary'])),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, indent: 16, endIndent: 16, color: colors['textSubtle']?.withValues(alpha: 0.15)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Map<String, Color?> colors;

  const _StatCard({required this.icon, required this.label, required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['primary']?.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colors['primary']),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: colors['textSubtle'])),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors['textPrimary'])),
        ],
      ),
    );
  }
}