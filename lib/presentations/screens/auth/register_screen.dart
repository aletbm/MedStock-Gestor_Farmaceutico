import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/providers/user_provider.dart';
import 'package:medstock/presentations/widgets/form_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: _RegisterView(),
    );
  }
}

class _RegisterView extends ConsumerStatefulWidget {
  const _RegisterView();

  @override
  ConsumerState<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<_RegisterView> {
  bool _isLoading = false;
  final nameController      = TextEditingController();
  final lastnameController  = TextEditingController();
  final matriculaController = TextEditingController();
  final rolController       = TextEditingController();
  final telefonoController  = TextEditingController();
  final emailController     = TextEditingController();
  final passwordController  = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    matriculaController.dispose();
    rolController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(colorsProvider);
    final users  = ref.watch(userListProvider);

    return SingleChildScrollView(
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
            FormFieldRow(controller: nameController, label: 'Nombre', icon: Icons.badge_outlined),
            FormFieldRow(controller: lastnameController, label: 'Apellido', icon: Icons.badge_outlined),
            FormFieldRow(controller: matriculaController, label: 'Matrícula', icon: Icons.numbers, keyboardType: TextInputType.number, isLast: true,),
          ]),

          const SizedBox(height: 20),

          // ── Sección 2: Datos profesionales ──
          SectionHeader(title: 'Datos profesionales', icon: Icons.work_outline, colors: colors),
          const SizedBox(height: 8),
          FormCard(colors: colors, children: [
            FormFieldRow(controller: rolController,      label: 'Rol',      icon: Icons.assignment_ind_outlined),
            FormFieldRow(
              controller: telefonoController,
              label: 'Teléfono',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isLast: true,
            ),
          ]),

          const SizedBox(height: 20),

          // ── Sección 3: Acceso ──
          SectionHeader(title: 'Acceso', icon: Icons.lock_outline, colors: colors),
          const SizedBox(height: 8),
          FormCard(colors: colors, children: [
            FormFieldRow(
              controller: emailController,
              label: 'Email (opcional)',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            PasswordFieldRow(
              controller: passwordController,
              obscure: _obscurePassword,
              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ]),

          const SizedBox(height: 28),

          // ── Botón ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : () => _submit(context, users),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Registrarse', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, List users) async {
    final router = GoRouter.of(context);

    final String name      = nameController.text.trim();
    final String lastname  = lastnameController.text.trim();
    final String matricula = matriculaController.text.trim();
    final String rol       = rolController.text.trim();
    final String telefono  = telefonoController.text.trim();
    final String email     = emailController.text.trim();
    final String password  = passwordController.text.trim();

    void showSnack(String msg) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    bool valido = true;
    String messages = '';

    if (name.isEmpty)         { messages += '- Ingresá tu nombre\n';                               valido = false; }
    else if (name.length < 2) { messages += '- El nombre debe tener al menos 2 caracteres\n';      valido = false; }

    if (lastname.isEmpty)           { messages += '- Ingresá tu apellido\n';                          valido = false; }
    else if (lastname.length < 2)   { messages += '- El apellido debe tener al menos 2 caracteres\n'; valido = false; }

    if (matricula.isEmpty)                    { messages += '- Ingresá tu matrícula\n';           valido = false; }
    else if (int.tryParse(matricula) == null)  { messages += '- La matrícula debe ser numérica\n'; valido = false; }
    else if (users.any((u) => u.matricula.trim() == matricula)) {
      messages += '- Ya existe un usuario con esa matrícula\n'; valido = false;
    }

    if (telefono.isEmpty)                   { messages += '- Ingresá tu teléfono\n';                    valido = false; }
    else if (telefono.length < 8)           { messages += '- El teléfono es inválido\n';                valido = false; }
    else if (int.tryParse(telefono) == null){ messages += '- El teléfono debe contener sólo números\n'; valido = false; }

    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
      if (!emailRegex.hasMatch(email)) { messages += '- Email inválido\n'; valido = false; }
    }

    if (password.isEmpty)          { messages += '- Ingresá una contraseña\n';                              valido = false; }
    else if (password.length < 8)  { messages += '- La contraseña debe tener al menos 8 caracteres\n';     valido = false; }

    if (rol.isEmpty)         { messages += '- Ingresá tu rol\n';                               valido = false; }
    else if (rol.length < 2) { messages += '- El rol debe tener al menos 2 caracteres\n';      valido = false; }

    if (!valido) { showSnack(messages); return; }

    setState(() => _isLoading = true);

    final user = User(
      name:      name,
      lastname:  lastname,
      matricula: matricula,
      telefono:  telefono,
      email:     email.isEmpty ? null : email,
      password:  password,
      rol:       rol,
      activo:    true,
      fechaAlta: DateTime.now(),
    );

    try {
      await ref.read(userListProvider.notifier).addUser(user);
      if (!mounted) return;
      showSnack('Usuario registrado correctamente');
      router.pop();
    } catch (e) {
      if (!mounted) return;
      showSnack('Error al guardar el registro.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}