import 'package:flutter/material.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';

class BatoulVoiceHeader extends StatelessWidget {
  const BatoulVoiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [BatoulTheme.primaryIndigo, Color(0xFF6366F1)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                border: Border.all(color: BatoulTheme.amberGold, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: BatoulTheme.primaryIndigo.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                // مكان ملف Rive التفاعلي لشخصية الآنسة بتول
                child: Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: BatoulTheme.amberGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                size: 18,
                color: BatoulTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'أهلاً بك عند الآنسة بتول! 🌟',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: BatoulTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'رحلتك الذكية للتفوق في المنهاج السوري باللعب والتحدي',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: BatoulTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
