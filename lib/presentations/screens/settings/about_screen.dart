import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: _AboutView()
    );
  }
}

class _AboutView extends ConsumerWidget {
  const _AboutView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);
  return SafeArea(
    child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: colors['primary']?.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: Image.asset('assets/images/medstock_logo.png', width: 50)
                ),
            ),
            const SizedBox(height: 16),
    
            // Nombre y versión
            Text('MedStock', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors['textPrimary'])),
            const SizedBox(height: 4),
            Text('Versión 1.0', style: TextStyle(fontSize: 14, color: colors['textSubtle'])),
            const SizedBox(height: 24),
    
            // Descripción
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors['stockBackground'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'MedStock es una aplicación de gestión de inventario de medicamentos. '
                'Permite registrar, editar y controlar el stock de productos farmacéuticos '
                'de forma simple y eficiente.',
                style: TextStyle(fontSize: 14, color: colors['textPrimary'], height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
    
            // Datos del desarrollador
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Desarrollador', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors['textSubtle'], letterSpacing: 0.8)),
            ),
            const SizedBox(height: 8),
            _InfoCard(
              colors: colors,
              children: [
                _InfoRow(icon: Icons.person_outline, label: 'Alexander Daniel Rios', colors: colors),
                Divider(height: 1, color: colors['textSubtle']?.withValues(alpha: 0.15)),
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'alexanderdaniel_rios@hotmail.com',
                  colors: colors,
                  onTap: () => _launch('mailto:alexanderdaniel_rios@hotmail.com'),
                ),
                Divider(height: 1, color: colors['textSubtle']?.withValues(alpha: 0.15)),
                _InfoRow(
                  icon: Icons.code,
                  label: 'github.com/aletbm',
                  colors: colors,
                  onTap: () => _launch('https://github.com/aletbm'),
                ),
              ],
            ),
            const SizedBox(height: 32),
    
            Text('© 2025 Alexander Daniel Rios', style: TextStyle(fontSize: 12, color: colors['textSubtle'])),
            const SizedBox(height: 8),
            Text('Hecho con ❤️ en Flutter', style: TextStyle(fontSize: 12, color: colors['textSubtle'])),
            const SizedBox(height: 24),
          ],
        ),
      ),
  );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('No se pudo abrir: $url');
    }
  }
}

class _InfoCard extends StatelessWidget {
  final Map<String, Color?> colors;
  final List<Widget> children;

  const _InfoCard({required this.colors, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors['stockBackground'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Map<String, Color?> colors;
  final VoidCallback? onTap;

  const _InfoRow({required this.icon, required this.label, required this.colors, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors['primary']),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: onTap != null ? colors['primary'] : colors['textPrimary'],
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 14, color: colors['textSubtle']),
          ],
        ),
      ),
    );
  }
}

