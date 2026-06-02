import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medstock/core/theme/app_color.dart';
import 'package:medstock/core/theme/app_font.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';

class ApparenceScreen extends StatelessWidget {
  const ApparenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: const _ApparenceView(),
    );
  }
}

class _ApparenceView extends ConsumerWidget {
  const _ApparenceView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColors = ref.watch(colorsProvider);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 60),
        children: [
          _SectionTitle(title: 'Tema'),
          Text('Selecciona un tema para la aplicación'),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: AppColors.all.length,
            itemBuilder: (context, index) {
              final theme = AppColors.all[index];
              final colors = theme['colors'] as Map<String, Color>;
              final isSelected = currentColors['primary'] == colors['primary'];
      
              return GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).setTheme(colors, theme['name']),
                child: Tooltip(
                  message: theme['name'],
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? colors['primary']! : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: colors['primary']!.withValues(alpha: 0.5), blurRadius: 8)]
                          : null,
                    ),
                    child: CircleAvatar(
                      backgroundColor: colors['cardBackground'],
                      child: CircleAvatar(
                        backgroundColor: colors['primary'],
                        radius: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24),
          _SectionTitle(title: 'Fuente'),
          Text('Selecciona una fuente para la aplicación'),
          SizedBox(height: 12),
          _FontSelector(),
        ],
      ),
    );
  }
}

class _FontSelector extends ConsumerWidget {
  const _FontSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(themeProvider).font;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.text_fields),
      title: Text('Tipografía'),
      subtitle: Text(
        currentFont,
        style: GoogleFonts.getFont(currentFont),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => _showFontDialog(context, ref, currentFont),
    );
  }

  void _showFontDialog(BuildContext context, WidgetRef ref, String currentFont) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text('Elegir fuente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Divider(),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: AppFonts.fonts.length,
                  itemBuilder: (context, index) {
                    final font = AppFonts.fonts[index];
                    final isSelected = font == currentFont;
                    return ListTile(
                      selected: isSelected,
                      trailing: isSelected ? Icon(Icons.check) : null,
                      title: Text(font, style: GoogleFonts.getFont(font, fontSize: 16)),
                      subtitle: Text(
                        'El veloz murciélago hindú',
                        style: GoogleFonts.getFont(font, fontSize: 12),
                      ),
                      onTap: () {
                        ref.read(themeProvider.notifier).setFont(font);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}