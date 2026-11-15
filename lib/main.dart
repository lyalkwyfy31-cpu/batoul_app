import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';
import 'package:batoul_app/features/onboarding_auth/presentation/screens/batoul_onboarding_screen.dart';

class SupabaseConfig {
  static const String url = 'https://supabase.co';
  static const String anonKey = 'sb_publishable_JErgaUBRQm7GdGnEbpjbAg_DIHKz7Dy';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تثبيت اتجاه الشاشة عمودياً لضمان استقرار تجربة الطفل البصرية
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تهيئة الاتصال بقاعدة بيانات Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    const ProviderScope(
      child: BatoulApp(),
    ),
  );
}

class BatoulApp extends StatelessWidget {
  const BatoulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بتول - المنهاج السوري',
      debugShowCheckedModeBanner: false,
      theme: BatoulTheme.lightTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const BatoulOnboardingScreen(),
    );
  }
}
