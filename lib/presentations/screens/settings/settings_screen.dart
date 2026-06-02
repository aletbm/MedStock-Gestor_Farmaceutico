import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/core/router/settings_routes.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/widgets/custom_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuración')),
      drawer: CustomDrawer(),
      body: _SettingsView()
      );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);
    return SafeArea(
      child: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item.icon, color: colors['iconPrimary']),
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () => context.push(item.path),
          );
        }
      ),
    );
  }
}