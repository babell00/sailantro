import 'package:firebase_auth/firebase_auth.dart';
import 'package:sailantro/features/auth/domain/models/app_user.dart';
import 'package:sailantro/features/auth/domain/repository/auth_repository.dart';

import 'firebase_auth_error_mapper.dart';
import '../domain/errors/auth_failure.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteAccount() async {
    try {
      final u = firebaseAuth.currentUser;
      if (u == null) throw const AuthFailure('No user logged in.');
      await u.delete();            // may throw requires-recent-login
      await logout();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (_) {
      throw const AuthFailure('User deletion failed. Please try again.');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final u = firebaseAuth.currentUser;
    if (u == null) return null;
    return AppUser(
      uid: u.uid,
      email: u.email,               // ← nullable, no '' fallback
      displayName: u.displayName,
    );
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      final cred = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final u = cred.user;
      if (u == null) {
        throw const AuthFailure('Login failed. Please try again.');
      }
      return AppUser(
        uid: u.uid,
        email: u.email ?? email,    // ← prefer Firebase; fall back to input
        displayName: u.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (_) {
      throw const AuthFailure('Login failed. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name,
      String email,
      String password,
      ) async {
    try {
      final cred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final u = cred.user;
      if (u == null) {
        throw const AuthFailure('Registration failed. Please try again.');
      }
      await u.updateDisplayName(name);
      return AppUser(
        uid: u.uid,
        email: u.email ?? email,    // ← usually present, but keep safe
        displayName: name,
      );
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (_) {
      throw const AuthFailure('Registration failed. Please try again.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (_) {
      throw const AuthFailure('Could not send reset email. Please try again.');
    }
  }
}
