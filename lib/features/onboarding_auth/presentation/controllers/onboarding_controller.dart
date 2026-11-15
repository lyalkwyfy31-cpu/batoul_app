import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:batoul_app/core/errors/app_exceptions.dart';
import 'package:batoul_app/features/onboarding_auth/data/models/student_model.dart';
import 'package:batoul_app/features/onboarding_auth/data/repositories/auth_repository.dart';

class OnboardingState {
  final int selectedGrade;
  final bool isLoadingCode;
  final bool isLoadingTrial;
  final String? errorMessage;
  final StudentModel? currentStudent;

  const OnboardingState({
    this.selectedGrade = 6, // الصف السادس افتراضياً كما حدد المصمم
    this.isLoadingCode = false,
    this.isLoadingTrial = false,
    this.errorMessage,
    this.currentStudent,
  });

  bool get isBusy => isLoadingCode || isLoadingTrial;

  OnboardingState copyWith({
    int? selectedGrade,
    bool? isLoadingCode,
    bool? isLoadingTrial,
    String? errorMessage,
    bool clearError = false,
    StudentModel? currentStudent,
  }) {
    return OnboardingState(
      selectedGrade: selectedGrade ?? this.selectedGrade,
      isLoadingCode: isLoadingCode ?? this.isLoadingCode,
      isLoadingTrial: isLoadingTrial ?? this.isLoadingTrial,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentStudent: currentStudent ?? this.currentStudent,
    );
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref.read(authRepositoryProvider));
});

class OnboardingController extends StateNotifier<OnboardingState> {
  final AuthRepository _authRepository;

  OnboardingController(this._authRepository) : super(const OnboardingState());

  void selectGrade(int grade) {
    if (state.isBusy) return;
    state = state.copyWith(selectedGrade: grade, clearError: true);
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  /// التحقق من الحقول الأساسية (الاسم الثلاثي ورقم هاتف الأم) بنفس نصوص المصمم
  String? _validateStudentAndMotherInfo({
    required String fullName,
    required String motherPhone,
  }) {
    if (fullName.trim().isEmpty) {
      return 'يا بطل، اكتب اسمك الثلاثي أولاً ليظهر في لوحة الشرف!';
    }
    if (motherPhone.trim().length < 9) {
      return 'يرجى إدخال رقم هاتف الأم بشكل صحيح لتفعيل رادار المتابعة.';
    }
    return null;
  }

  /// تفعيل كود الاشتراك الكامل
  Future<bool> activateCode({
    required String fullName,
    required String motherPhone,
    required String code,
  }) async {
    if (state.isBusy) return false;

    final String? baseValidationError = _validateStudentAndMotherInfo(
      fullName: fullName,
      motherPhone: motherPhone,
    );

    if (baseValidationError != null) {
      state = state.copyWith(errorMessage: baseValidationError);
      return false;
    }

    if (code.trim().length < 6) {
      state = state.copyWith(
        errorMessage:
            'كود الاشتراك غير مكتمل، تأكد من البطاقة أو ابدأ التجربة المجانية.',
      );
      return false;
    }

    state = state.copyWith(isLoadingCode: true, clearError: true);

    try {
      final StudentModel student = await _authRepository.activateCode(
        fullName: fullName,
        grade: state.selectedGrade,
        motherPhone: motherPhone,
        code: code,
      );

      state = state.copyWith(
        isLoadingCode: false,
        currentStudent: student,
        clearError: true,
      );
      return true;
    } on BatoulException catch (e) {
      state = state.copyWith(
        isLoadingCode: false,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoadingCode: false,
        errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
      );
      return false;
    }
  }

  /// بدء التجربة الاستكشافية المجانية للدرس الأول
  Future<bool> startFreeTrial({
    required String fullName,
    required String motherPhone,
  }) async {
    if (state.isBusy) return false;

    final String? baseValidationError = _validateStudentAndMotherInfo(
      fullName: fullName,
      motherPhone: motherPhone,
    );

    if (baseValidationError != null) {
      state = state.copyWith(errorMessage: baseValidationError);
      return false;
    }

    state = state.copyWith(isLoadingTrial: true, clearError: true);

    try {
      final StudentModel student = await _authRepository.startFreeTrial(
        fullName: fullName,
        grade: state.selectedGrade,
        motherPhone: motherPhone,
      );

      state = state.copyWith(
        isLoadingTrial: false,
        currentStudent: student,
        clearError: true,
      );
      return true;
    } on BatoulException catch (e) {
      state = state.copyWith(
        isLoadingTrial: false,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoadingTrial: false,
        errorMessage: 'تعذر بدء التجربة المجانية حالياً، حاول مرة أخرى.',
      );
      return false;
    }
  }
}
