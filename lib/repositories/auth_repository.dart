import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/result.dart';
import '../providers/core_providers.dart';

// ประกาศ Provider ให้ฉีด Supabase เข้า Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final sb = ref.watch(supabaseProvider);
  return AuthRepository(sb);
});

class AuthRepository {
  final SupabaseClient _sb;
  AuthRepository(this._sb);

  Future<Result<void>> login(String email, String password) async {
    try {
      await _sb.auth.signInWithPassword(email: email, password: password);
      return Success(null);
    } on AuthException catch (e, stack) {
      return Failure(e.message, e, stack);
    } catch (e, stack) {
      return Failure(
        'ไม่สามารถเข้าสู่ระบบได้ กรุณาตรวจสอบอินเทอร์เน็ต',
        e,
        stack,
      );
    }
  }

  Future<Result<void>> register(String email, String password) async {
    try {
      await _sb.auth.signUp(email: email, password: password);
      return Success(null);
    } on AuthException catch (e, stack) {
      return Failure(e.message, e, stack);
    } catch (e, stack) {
      return Failure(
        'ไม่สามารถสมัครสมาชิกได้ กรุณาตรวจสอบอินเทอร์เน็ต',
        e,
        stack,
      );
    }
  }

  Future<Result<void>> resetPassword(String email) async {
    try {
      await _sb.auth.resetPasswordForEmail(email);
      return Success(null);
    } on AuthException catch (e, stack) {
      return Failure(e.message, e, stack);
    } catch (e, stack) {
      return Failure(
        'ไม่สามารถส่งลิงก์รีเซ็ตรหัสผ่านได้ กรุณาลองใหม่อีกครั้ง',
        e,
        stack,
      );
    }
  }

  Future<void> logout() async {
    await _sb.auth.signOut();
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      await _sb.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.ckdnutrition://login-callback/',
      );
      return Success(null);
    } on AuthException catch (e, stack) {
      return Failure(e.message, e, stack);
    } catch (e, stack) {
      return Failure('เกิดข้อผิดพลาดในการเชื่อมต่อ Google', e, stack);
    }
  }

  Future<Result<void>> signInWithApple() async {
    try {
      await _sb.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.ckdnutrition://login-callback/',
      );
      return Success(null);
    } on AuthException catch (e, stack) {
      return Failure(e.message, e, stack);
    } catch (e, stack) {
      return Failure('เกิดข้อผิดพลาดในการเชื่อมต่อ Apple', e, stack);
    }
  }

  Future<Result<void>> deleteAccount() async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return Failure('กรุณาเข้าสู่ระบบก่อน');

      await _sb.rpc('delete_user_account', params: {'p_user_id': user.id});
      await logout();
      return Success(null);
    } catch (e, stack) {
      return Failure('ไม่สามารถลบบัญชีได้: $e', e, stack);
    }
  }
}
