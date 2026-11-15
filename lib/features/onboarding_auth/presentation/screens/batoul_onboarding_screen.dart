import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:batoul_app/core/theme/batoul_theme.dart';
import 'package:batoul_app/core/widgets/batoul_error_banner.dart';
import 'package:batoul_app/core/widgets/batoul_tactile_button.dart';
import 'package:batoul_app/core/widgets/batoul_text_field.dart';
import 'package:batoul_app/features/onboarding_auth/presentation/controllers/onboarding_controller.dart';
import 'package:batoul_app/features/onboarding_auth/presentation/widgets/batoul_voice_header.dart';
import 'package:batoul_app/features/onboarding_auth/presentation/widgets/grade_selector_card.dart';
import 'package:batoul_app/features/onboarding_auth/presentation/widgets/syria_payment_sheet.dart';

class BatoulOnboardingScreen extends ConsumerStatefulWidget {
  const BatoulOnboardingScreen({super.key});

  @override
  ConsumerState<BatoulOnboardingScreen> createState() =>
      _BatoulOnboardingScreenState();
}

class _BatoulOnboardingScreenState
    extends ConsumerState<BatoulOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _motherPhoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _motherPhoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleActivateCode() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    final bool success =
        await ref.read(onboardingControllerProvider.notifier).activateCode(
              fullName: _nameController.text,
              motherPhone: _motherPhoneController.text,
              code: _codeController.text,
            );

    if (!mounted || !success) return;

    final student = ref.read(onboardingControllerProvider).currentStudent;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BatoulTheme.mintSuccess,
        content: Text(
          'تم تفعيل الاشتراك وقفل الكود بنجاح يا ${student?.fullName ?? 'بطل'}! 🎉',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _handleStartFreeTrial() async {
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    final bool success =
        await ref.read(onboardingControllerProvider.notifier).startFreeTrial(
              fullName: _nameController.text,
              motherPhone: _motherPhoneController.text,
            );

    if (!mounted || !success) return;

    final student = ref.read(onboardingControllerProvider).currentStudent;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BatoulTheme.primaryIndigo,
        content: Text(
          'أهلاً بك يا ${student?.fullName ?? 'بطل'} في الدرس الأول المجاني (الصف ${student?.grade})! 🚀',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingState state = ref.watch(onboardingControllerProvider);
    final OnboardingController controller =
        ref.read(onboardingControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: BatoulTheme.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. منطقة ترحيب الآنسة بتول الصوتية والبصرية
                const BatoulVoiceHeader(),
                const SizedBox(height: 20),

                // شريط الخطأ أو التنبيه إن وجد
                if (state.errorMessage != null)
                  BatoulErrorBanner(message: state.errorMessage!),

                // 2. بطاقة بيانات الطالب والمنهاج السوري ورادار الأم
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: BatoulTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: BatoulTheme.borderLight, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '١. اسم البطل / البطلة:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: BatoulTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BatoulTextField(
                        controller: _nameController,
                        hint: 'مثال: يامن العلي',
                        icon: Icons.person_rounded,
                        onChanged: (_) => controller.clearError(),
                      ),
                      const SizedBox(height: 16),

                      // اختيار الصف الدراسي حسب المنهاج السوري
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '٢. اختر صفك الدراسي:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: BatoulTheme.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: BatoulTheme.mintSuccess.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'المنهاج السوري المعتمد 🇸🇾',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: BatoulTheme.mintSuccess,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GradeSelectorCard(
                            grade: 5,
                            title: 'الخامس',
                            icon: Icons.star_rounded,
                            isSelected: state.selectedGrade == 5,
                            onSelect: () => controller.selectGrade(5),
                          ),
                          const SizedBox(width: 10),
                          GradeSelectorCard(
                            grade: 6,
                            title: 'السادس',
                            icon: Icons.rocket_launch_rounded,
                            isSelected: state.selectedGrade == 6,
                            onSelect: () => controller.selectGrade(6),
                          ),
                          const SizedBox(width: 10),
                          GradeSelectorCard(
                            grade: 7,
                            title: 'السابع',
                            icon: Icons.workspace_premium_rounded,
                            isSelected: state.selectedGrade == 7,
                            onSelect: () => controller.selectGrade(7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // رقم هاتف الأم (رادار المتابعة)
                      const Text(
                        '٣. رقم هاتف الأم (لواتساب النتائج):',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: BatoulTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BatoulTextField(
                        controller: _motherPhoneController,
                        hint: 'مثال: 0912345678',
                        icon: Icons.phone_android_rounded,
                        isPhone: true,
                        onChanged: (_) => controller.clearError(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 3. زر التجربة الاستكشافية المجانية
                BatoulTactileButton(
                  title: 'ابدأ الدرس الأول مجاناً 🚀',
                  bgColor: BatoulTheme.amberGold,
                  lipColor: BatoulTheme.amberGoldDark,
                  textColor: BatoulTheme.textPrimary,
                  isLoading: state.isLoadingTrial,
                  onTap: _handleStartFreeTrial,
                ),
                const SizedBox(height: 16),

                // 4. بطاقة تفعيل كود الاشتراك وقفل الجهاز
                Container(
                  padding: const EdgeInsets.all(16),
