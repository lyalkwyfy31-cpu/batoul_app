import 'package:flutter/material.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';

class SyriaPaymentSheet extends StatelessWidget {
  const SyriaPaymentSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SyriaPaymentSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'طرق الحصول على كود اشتراك "بتول" في سوريا 🇸🇾',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: BatoulTheme.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '• الدفع الإلكتروني الفوري: عبر سيريتل كاش (Syriatel Cash) أو إم تي إن كاش (MTN Cash).',
            ),
            SizedBox(height: 8),
            Text(
              '• الحوالات المباشرة: عبر شركتي الهرم أو الفؤاد.',
            ),
            SizedBox(height: 8),
            Text(
              '• بطاقات الشحن المطبوعة: متوفرة في المكتبات المعتمدة في محافظتك.',
            ),
            SizedBox(height: 12),
            Text(
              '🔒 ملاحظة: الكود يُقفل تلقائياً على جهاز الطالب ويُربط برقم هاتف الأم لضمان أمان الحساب.',
              style: TextStyle(
                fontSize: 12.5,
                color: BatoulTheme.warningOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
