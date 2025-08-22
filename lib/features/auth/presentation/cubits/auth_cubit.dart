import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/auth/domain/models/app_user.dart';
import 'package:sailantro/features/auth/domain/repository/auth_repository.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  AppUser? get currentUser => _currentUser;

  void checkAuth() async {
    debugPrint('Checking current user auth status...');
    emit(AuthLoading());
    final AppUser? user = await authRepository.getCurrentUser();
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
      if (user != null) {
        debugPrint('Login successful: ${user.uid}');
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        debugPrint('Login failed: null user returned');
        emit(Unauthenticated());
      }
    } catch (e, stackTrace) {
      debugPrint('Login error: $e');
      debugPrint(stackTrace.toString());

      emit(AuthError("Login failed. Please check your email and password."));
      emit(Unauthenticated());
    }
  }

  Future<void> register(String name, String email, String password) async {
    debugPrint('Starting registration for: $email');
    try {
      emit(AuthLoading());
      final user = await authRepository.registerWithEmailPassword(
        name,
        email,
        password,
      );
      if (user != null) {
        debugPrint('[Auth] Registration successful: ${user.uid}');
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        debugPrint('Registration failed: null user returned');
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    debugPrint('Logging out user...');
    emit(AuthLoading());
    try {
      await authRepository.logout();
      debugPrint('Logout successful');
      emit(Unauthenticated());
    } catch (e, stackTrace) {
      debugPrint('Logout error: $e');
      debugPrint(stackTrace.toString());
      emit(AuthError("Logout failed. Please try again."));
      emit(Unauthenticated());
    }
  }

  Future<String> forgotPassword(String email) async {
    debugPrint('Sending password reset email to: $email');
    try {
      await authRepository.sendPasswordResetEmail(email);
      debugPrint('Password reset email sent successfully');
      return "Password reset email sent. Please check your inbox.";
    } catch (e, stackTrace) {
      debugPrint('Password reset error: $e');
      debugPrint(stackTrace.toString());
      return "Failed to send password reset email. Please try again.";
    }
  }

  Future<void> delete() async {
    debugPrint('Attempting to delete user account...');

    try {
      emit(AuthLoading());
      await authRepository.deleteAccount();
      debugPrint('Account deleted successfully');
      emit(Unauthenticated());
    } catch (e, stackTrace) {
      debugPrint('Account deletion error: $e');
      debugPrint(stackTrace.toString());
      emit(AuthError("Account deletion failed. Please try again."));
      emit(Unauthenticated());
    }
  }

}
