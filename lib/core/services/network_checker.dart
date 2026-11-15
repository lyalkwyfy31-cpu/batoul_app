import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkCheckerProvider = Provider<NetworkChecker>((ref) {
  return NetworkChecker(Connectivity());
});

class NetworkChecker {
  final Connectivity _connectivity;

  NetworkChecker(this._connectivity);

  Future<bool> get isConnected async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        return false;
      }

      // فحص فعلي للوصول إلى الإنترنت للتأكد من وجود حزم بيانات
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 4),
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
