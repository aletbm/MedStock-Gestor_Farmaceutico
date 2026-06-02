import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/providers/user_provider.dart';
import 'package:medstock/presentations/widgets/custom_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileView();
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserProvider);
    final colors = ref.watch(colorsProvider);

    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/images/doc.jpg'),),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${userData.name} ${userData.lastname}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                        SizedBox(height: 4),
                        Text(userData.rol.capitalize, style: TextStyle(fontSize: 16, color: colors['textSubtle']),),
                        SizedBox(height: 4),
                        Text("Matrícula: ${userData.matricula}", style: TextStyle(fontSize: 14, color: colors['textSubtle']),),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( "Información de contacto",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(userData.telefono),
                    ),
                    if (userData.email != null)
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(userData.email!),
                      ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detalles de la cuenta",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text(
                        "Estado: ${userData.activo ? "Activo" : "Inactivo"}",
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(
                        "Fecha de alta: ${userData.fechaAlta.toLocal().toIso8601String()}",
                      ),
                    ),
                    if (userData.ultimoAcceso != null)
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text(
                          "Último acceso: ${userData.ultimoAcceso!.toLocal().toIso8601String()}",
                        ),
                      ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Acciones",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text("Editar perfil"),
                      onTap: () {
                        context.push('/edit-profile', extra: userData);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Cambiar contraseña'),
                      onTap: () => _showChangePasswordDialog(context, ref, userData),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

void _showChangePasswordDialog(BuildContext context, WidgetRef ref, User userData) {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cambiar contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresá la contraseña actual';
                  if (value != userData.password) return 'Contraseña incorrecta';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresá la nueva contraseña';
                  if (value.length < 4) return 'Mínimo 4 caracteres';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirmá la nueva contraseña';
                  if (value != newPasswordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await ref.read(userListProvider.notifier).updateUser(
                          userData.copyWith(password: newPasswordController.text),
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Contraseña actualizada correctamente')),
                          );
                        }
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}