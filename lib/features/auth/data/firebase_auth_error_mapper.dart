import 'package:firebase_auth/firebase_auth.dart';
import '../domain/errors/auth_failure.dart';

AuthFailure mapFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    // Sign in
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
    case 'invalid-email':
      return AuthFailure('Invalid email or password.', code: e.code);

    // Register
    case 'email-already-in-use':
      return AuthFailure('This email is already in use.', code: e.code);
    case 'weak-password':
      return AuthFailure('Choose a stronger password.', code: e.code);
    case 'operation-not-allowed':
      return AuthFailure('Email/password sign-in is disabled.', code: e.code);

    // Account state / rate limit
    case 'user-disabled':
      return AuthFailure(
        'This account is disabled. Contact support.',
        code: e.code,
      );
    case 'too-many-requests':
      return AuthFailure('Too many attempts. Try again later.', code: e.code);

    // Connectivity
    case 'network-request-failed':
      return AuthFailure('Network error. Check your connection.', code: e.code);

    // Sensitive ops
    case 'requires-recent-login':
      return AuthFailure('Please re-authenticate to continue.', code: e.code);

    default:
      return AuthFailure(
        'Something went wrong. Please try again.',
        code: e.code,
      );
  }
}
