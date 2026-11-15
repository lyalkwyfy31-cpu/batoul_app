import 'package:flutter/material.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';

class BatoulTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPhone;
  final ValueChanged<String>? onChanged;

  const BatoulTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPhone = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: BatoulTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: BatoulTheme.textSecondary,
          fontSize: 13.5,
        ),
        prefixIcon: Icon(icon, color: BatoulTheme.primaryIndigo, size: 22),
        filled: true,
        fillColor: BatoulTheme.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BatoulTheme.borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BatoulTheme.primaryIndigo, width: 2),
        ),
      ),
    );
  }
}
