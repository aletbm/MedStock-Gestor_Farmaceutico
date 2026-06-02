import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/presentations/providers/session_provider.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'package:medstock/presentations/providers/user_provider.dart';
import 'package:medstock/presentations/widgets/form_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _LoginView(),
    );
  }
}

class _LoginView extends ConsumerStatefulWidget {
  const _LoginView();

  @override
  ConsumerState<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<_LoginView> {
  final matriculaController = TextEditingController();
  final passwordController  = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    matriculaController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(colorsProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/medstock_logo.png', height: 180),
            const SizedBox(height: 40),

            FormCard(colors: colors, children: [
              FormFieldRow(
                controller: matriculaController,
                label: 'Matrícula',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
              ),
              PasswordFieldRow(
                controller: passwordController,
                obscure: _obscurePassword,
                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ]),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/register'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    void showSnack(String msg) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    if (matriculaController.text.isEmpty) {
      showSnack('Por favor, ingresá tu matrícula');
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnack('Por favor, ingresá una contraseña');
      return;
    }

    setState(() => _isLoading = true);

    final user = await ref.read(userListProvider.notifier).checkUserData(
      matriculaController.text,
      passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (user != null) {
      await ref.read(sessionProvider.notifier).login(user.id!, user.rol);
    } else {
      showSnack('Matrícula o contraseña incorrectos');
    }
  }
}