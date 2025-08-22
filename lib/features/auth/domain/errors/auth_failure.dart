class AuthFailure implements Exception {
  final String message;     // safe, user-friendly
  final String? code;       // optional: keep original code for logging/analytics

  const AuthFailure(this.message, {this.code});

  @override
  String toString() => 'AuthFailure(code: $code, message: $message)';
}
