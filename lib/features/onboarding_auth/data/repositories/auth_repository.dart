import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:batoul_app/core/errors/app_exceptions.dart';
import 'package:batoul_app/core/services/device_info_service.dart';
import 'package:batoul_app/core/services/network_checker.dart';
import 'package:batoul_app/features/onboarding_auth/data/models/student_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    supabaseClient: Supabase.instance.client,
    networkChecker: ref.read(networkCheckerProvider),
    deviceInfoService: ref.read(deviceInfoServiceProvider),
  );
});

class AuthRepository {
  static const String _cachedStudentKey = 'batoul_cached_student_profile';

  final SupabaseClient _supabaseClient;
  final NetworkChecker _networkChecker;
  final DeviceInfoService _deviceInfoService;

  AuthRepository({
    required SupabaseClient supabaseClient,
    required NetworkChecker networkChecker,
    required DeviceInfoService deviceInfoService,
  })  : _supabaseClient = supabaseClient,
        _networkChecker = networkChecker,
        _deviceInfoService = deviceInfoService;

  /// تفعيل كود الاشتراك وقفل بصمة الجهاز عبر دالة الخادم الآمنة (RPC)
  Future<StudentModel> activateCode({
    required String fullName,
    required int grade,
    required String motherPhone,
    required String code,
  }) async {
    final bool hasInternet = await _networkChecker.isConnected;
    if (!hasInternet) {
      throw BatoulException.noInternet();
    }

    try {
      final String deviceId = await _deviceInfoService.getUniqueDeviceId();

      final dynamic response = await _supabaseClient.rpc(
        'activate_student_code',
        params: {
          'p_full_name': fullName.trim(),
          'p_grade': grade,
          'p_mother_phone': motherPhone.trim(),
          'p_code': code.trim().toUpperCase(),
          'p_device_id': deviceId,
        },
      );

      if (response == null || response is! Map<String, dynamic>) {
        throw BatoulException.unknown();
      }

      final bool isSuccess = response['success'] == true;
      if (!isSuccess) {
        final String errorMsg = response['message']?.toString() ??
            'تعذر تفعيل الكود، يرجى التأكد من صحته.';
        final String? errorCode = response['error_code']?.toString();
        throw BatoulException(message: errorMsg, code: errorCode);
      }

      final Map<String, dynamic> studentMap =
          Map<String, dynamic>.from(response['student'] as Map);
      final StudentModel student = StudentModel.fromJson(studentMap);

      await _cacheStudentLocally(student);
      return student;
    } on BatoulException {
      rethrow;
    } on PostgrestException catch (e) {
      throw BatoulException(
        code: e.code,
        message: 'تعذر الوصول إلى خادم التفعيل حالياً، يرجى المحاولة بعد قليل.',
      );
    } catch (_) {
      throw BatoulException.unknown();
    }
  }

  /// بدء التجربة المجانية للدرس الأول وحفظ رقم الأم لرادار المتابعة
  Future<StudentModel> startFreeTrial({
    required String fullName,
    required int grade,
    required String motherPhone,
  }) async {
    final bool hasInternet = await _networkChecker.isConnected;
    if (!hasInternet) {
      throw BatoulException.noInternet();
    }

    try {
      final String deviceId = await _deviceInfoService.getUniqueDeviceId();

      final dynamic response = await _supabaseClient.rpc(
        'start_student_free_trial',
        params: {
          'p_full_name': fullName.trim(),
          'p_grade': grade,
          'p_mother_phone': motherPhone.trim(),
          'p_device_id': deviceId,
        },
      );

      if (response == null || response is! Map<String, dynamic>) {
        throw BatoulException.unknown();
      }

      final bool isSuccess = response['success'] == true;
      if (!isSuccess) {
        final String errorMsg = response['message']?.toString() ??
            'تعذر بدء التجربة المجانية حالياً.';
        throw BatoulException(message: errorMsg);
      }

      final Map<String, dynamic> studentMap =
          Map<String, dynamic>.from(response['student'] as Map);
      final StudentModel student = StudentModel.fromJson(studentMap);

      await _cacheStudentLocally(student);
      return student;
    } on BatoulException {
      rethrow;
    } catch (_) {
      throw BatoulException.unknown();
    }
  }

  /// استرجاع بيانات الطالب المحفوظة محلياً إن وجدت
  Future<StudentModel?> getCachedStudent() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawJson = prefs.getString(_cachedStudentKey);
      if (rawJson == null || rawJson.isEmpty) return null;

      final Map<String, dynamic> map =
          jsonDecode(rawJson) as Map<String, dynamic>;
      return StudentModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheStudentLocally(StudentModel student) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedStudentKey, jsonEncode(student.toJson()));
  }
}
