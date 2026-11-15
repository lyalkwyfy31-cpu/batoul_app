class BatoulException implements Exception {
  final String message;
  final String? code;

  const BatoulException({
    required this.message,
    this.code,
  });

  factory BatoulException.noInternet() {
    return const BatoulException(
      code: 'NO_INTERNET',
      message: 'لا يوجد اتصال بالإنترنت حالياً، يرجى التأكد من الشبكة والمحاولة مجدداً.',
    );
  }

  factory BatoulException.unknown([String? customMessage]) {
    return BatoulException(
      code: 'UNKNOWN_ERROR',
      message: customMessage ?? 'حدث خلل تقني بسيط، يرجى المحاولة بعد قليل.',
    );
  }

  @override
  String toString() => message;
}
