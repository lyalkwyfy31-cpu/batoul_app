import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';

class GradeSelectorCard extends StatelessWidget {
  final int grade;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelect;

  const GradeSelectorCard({
    super.key,
    required this.grade,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onSelect();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? BatoulTheme.primaryIndigo.withOpacity(0.08)
                : BatoulTheme.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? BatoulTheme.primaryIndigo
                  : BatoulTheme.borderLight,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? BatoulTheme.primaryIndigo
                    : BatoulTheme.textSecondary,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                'الصف $title',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? BatoulTheme.primaryIndigo
                      : BatoulTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
