import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/auth/domain/entities/app_user.dart';
import 'package:sailantro/features/auth/domain/repository/auth_repository.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_state.dart';
import '../../domain/errors/auth_failure.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  AppUser? get currentUser => _currentUser;

  /// Called once on app start
  Future<void> checkAuth() async {
    debugPrint('Checking current user auth status...');
    emit(AuthLoading());
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      debugPrint('User found: ${user.uid}');
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      debugPrint('No user found. User is unauthenticated.');
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    debugPrint('Attempting login for: $email');
    try {
      emit(AuthLoading());
      final user = await authRepository.loginWithEmailPassword(email, password);
      if (user == null) {
        emit(AuthError('Login failed. Please try again.'));
        return;
      }
      debugPrint('Login successful: ${user.uid}');
      _currentUser = user;
      emit(Authenticated(user));
    } catch (e, st) {
      debugPrint('Login error: $e\n$st');
      final msg = e is AuthFailure ? e.message : 'Login failed. Please try again.';
      emit(AuthError(msg));
    }
  } // ← END login()

  Future<void> register(String name, String email, String password) async {
    debugPrint('Starting registration for: $email');
    try {
      emit(AuthLoading());
      final user = await authRepository.registerWithEmailPassword(name, email, password);
      if (user == null) {
        emit(AuthError('Registration failed. Please try again.'));
        return;
      }
      debugPrint('[Auth] Registration successful: ${user.uid}');
      _currentUser = user;
      emit(Authenticated(user));
    } catch (e, st) {
      debugPrint('Register error: $e\n$st');
      final msg = e is AuthFailure ? e.message : 'Registration failed. Please try again.';
      emit(AuthError(msg));
    }
  }

  Future<void> logout() async {
    debugPrint('Logging out user...');
    emit(AuthLoading());
    try {
      await authRepository.logout();
      debugPrint('Logout successful');
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e, st) {
      debugPrint('Logout error: $e\n$st');
      final msg = e is AuthFailure ? e.message : 'Logout failed. Please try again.';
      emit(AuthError(msg));
    }
  }

  Future<String> forgotPassword(String email) async {
    debugPrint('Sending password reset email to: $email');
    try {
      await authRepository.sendPasswordResetEmail(email);
      debugPrint('Password reset email sent successfully');
      return 'Password reset email sent. Please check your inbox.';
    } catch (e, st) {
      debugPrint('Password reset error: $e\n$st');
      return e is AuthFailure ? e.message : 'Failed to send reset email. Please try again.';
    }
  }

  Future<void> delete() async {
    debugPrint('Attempting to delete user account...');
    try {
      emit(AuthLoading());
      await authRepository.deleteAccount();
      debugPrint('Account deleted successfully');
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e, st) {
      debugPrint('Account deletion error: $e\n$st');
      final msg = e is AuthFailure ? e.message : 'Account deletion failed. Please try again.';
      emit(AuthError(msg));
    }
  }
}
