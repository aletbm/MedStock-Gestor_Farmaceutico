import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/presentations/providers/session_provider.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);
  
    return Drawer(
      width: 250,
      child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colors['drawerHeader']),
              child: Text('Menú', style: TextStyle(color: colors['textOnPrimary'], fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                context.go('/product-list');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: colors['danger'],),
              title: Text('Cerrar sesión', style: TextStyle(color: colors['danger'],),),
              onTap: () async {await ref.read(sessionProvider.notifier).logout();},
            ),
          ],
        ),
      );
  }
}