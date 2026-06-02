import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/providers/user_provider.dart';
import 'package:medstock/presentations/widgets/form_widgets.dart';

class EditProfileScreen extends StatelessWidget {
  final User userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: _EditProfileView(userData: userData),
      resizeToAvoidBottomInset: true,
    );
  }
}

class _EditProfileView extends ConsumerStatefulWidget {
  final User userData;
  const _EditProfileView({required this.userData});

  @override
  ConsumerState<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<_EditProfileView> {
  late final TextEditingController nameController;
  late final TextEditingController lastnameController;
  late final TextEditingController matriculaController;
  late final TextEditingController telefonoController;
  late final TextEditingController emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController      = TextEditingController(text: widget.userData.name);
    lastnameController  = TextEditingController(text: widget.userData.lastname);
    matriculaController = TextEditingController(text: widget.userData.matricula);
    telefonoController  = TextEditingController(text: widget.userData.telefono);
    emailController     = TextEditingController(text: widget.userData.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    matriculaController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(colorsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16, right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Sección 1: Datos personales ──
            SectionHeader(title: 'Datos personales', icon: Icons.person_outline, colors: colors),
            const SizedBox(height: 8),
            FormCard(colors: colors, children: [
              FormFieldRow(controller: nameController,     label: 'Nombre',    icon: Icons.badge_outlined),
              FormFieldRow(controller: lastnameController, label: 'Apellido',  icon: Icons.badge_outlined, isLast: true),
            ]),

            const SizedBox(height: 20),

            // ── Sección 2: Datos profesionales ──
            SectionHeader(title: 'Datos profesionales', icon: Icons.work_outline, colors: colors),
            const SizedBox(height: 8),
            FormCard(colors: colors, children: [
              FormFieldRow(
                controller: matriculaController,
                label: 'Matrícula',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
              ),
              FormFieldRow(
                controller: telefonoController,
                label: 'Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isLast: true,
              ),
            ]),

            const SizedBox(height: 20),

            // ── Sección 3: Contacto ──
            SectionHeader(title: 'Contacto', icon: Icons.email_outlined, colors: colors),
            const SizedBox(height: 8),
            FormCard(colors: colors, children: [
              FormFieldRow(
                controller: emailController,
                label: 'Email (opcional)',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isLast: true,
              ),
            ]),

            const SizedBox(height: 28),

            // ── Botones ──
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
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Guardar cambios', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final router = GoRouter.of(context);
    final users  = ref.read(userListProvider);

    final name      = nameController.text.trim();
    final lastname  = lastnameController.text.trim();
    final matricula = matriculaController.text.trim();
    final telefono  = telefonoController.text.trim();
    final email     = emailController.text.trim();

    void showSnack(String msg) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    bool valido = true;
    String messages = '';

    if (name.isEmpty)         { messages += '- Ingresá tu nombre\n';                               valido = false; }
    else if (name.length < 2) { messages += '- El nombre debe tener al menos 2 caracteres\n';      valido = false; }

    if (lastname.isEmpty)           { messages += '- Ingresá tu apellido\n';                          valido = false; }
    else if (lastname.length < 2)   { messages += '- El apellido debe tener al menos 2 caracteres\n'; valido = false; }

    if (matricula.isEmpty) {
      messages += '- Ingresá tu matrícula\n'; valido = false;
    } else if (int.tryParse(matricula) == null) {
      messages += '- La matrícula debe ser numérica\n'; valido = false;
    } else if (matricula.length < 4) {
      messages += '- La matrícula debe tener al menos 4 caracteres\n'; valido = false;
    } else if (users.any((u) => u.matricula.trim() == matricula) && matricula != widget.userData.matricula) {
      messages += '- Ya existe un usuario con esa matrícula\n'; valido = false;
    }

    if (telefono.isEmpty) {
      messages += '- Ingresá tu teléfono\n'; valido = false;
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(telefono)) {
      messages += '- El teléfono solo puede contener dígitos (7–15 caracteres)\n'; valido = false;
    }

    if (email.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      messages += '- El email ingresado no es válido\n'; valido = false;
    }

    if (!valido) { showSnack(messages); return; }

    setState(() => _isLoading = true);

    try {
      await ref.read(currentUserProvider.notifier).updateCurrentUser(
        widget.userData.copyWith(
          id:        widget.userData.id,
          name:      name,
          lastname:  lastname,
          matricula: matricula,
          telefono:  telefono,
          email:     email.isEmpty ? null : email,
        ),
      );
      if (!mounted) return;
      showSnack('Usuario modificado correctamente');
      router.pop();
    } catch (e) {
      if (!mounted) return;
      showSnack('Error al modificar su información.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}