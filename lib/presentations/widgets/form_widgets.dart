// lib/presentations/widgets/form_widgets.dart

import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, Color?> colors;

  const SectionHeader({super.key, required this.title, required this.icon, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colors['primary']),
        const SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: colors['primary'], letterSpacing: 0.5)),
      ],
    );
  }
}

class FormCard extends StatelessWidget {
  final List<Widget> children;
  final Map<String, Color?> colors;

  const FormCard({super.key, required this.children, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors['stockBackground'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class FormFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isLast;
  final TextInputType keyboardType;

  const FormFieldRow({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isLast = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 46, endIndent: 16),
      ],
    );
  }
}

class PasswordFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const PasswordFieldRow({
    super.key,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 18,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: InputBorder.none,
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18),
                  onPressed: onToggle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}