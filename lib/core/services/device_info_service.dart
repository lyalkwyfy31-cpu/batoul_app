import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService(DeviceInfoPlugin());
});

class DeviceInfoService {
  static const String _cachedDeviceIdKey = 'batoul_bound_device_id';
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoService(this._deviceInfoPlugin);

  Future<String> getUniqueDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedId = prefs.getString(_cachedDeviceIdKey);

    if (savedId != null && savedId.trim().isNotEmpty) {
      return savedId;
    }

    String extractedId = '';

    try {
      if (kIsWeb) {
        final WebBrowserInfo webInfo = await _deviceInfoPlugin.webBrowserInfo;
        extractedId = 'WEB-${webInfo.userAgent.hashCode}';
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        extractedId = 'AND-${androidInfo.id}-${androidInfo.model}';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        extractedId = 'IOS-${iosInfo.identifierForVendor ?? iosInfo.utsname.machine}';
      } else {
        extractedId = _generateFallbackId();
      }
    } catch (_) {
      extractedId = _generateFallbackId();
    }

    if (extractedId.trim().isEmpty) {
      extractedId = _generateFallbackId();
    }

    await prefs.setString(_cachedDeviceIdKey, extractedId);
    return extractedId;
  }

  String _generateFallbackId() {
    final Random random = Random.secure();
    final int randomPart = random.nextInt(900000) + 100000;
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'BTL-DEV-$timestamp-$randomPart';
  }
}
