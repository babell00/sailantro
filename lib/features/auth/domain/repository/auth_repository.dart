import 'package:sailantro/features/auth/domain/models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
}
