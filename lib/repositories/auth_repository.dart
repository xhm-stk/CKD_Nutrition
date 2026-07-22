import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/result.dart';
import '../providers/core_providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        return Failure('ไม่มีอินเทอร์เน็ต กรุณาเชื่อมต่อก่อนเข้าสู่ระบบ');
      }

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

  Future<Result<void>> register(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        return Failure('ไม่มีอินเทอร์เน็ต กรุณาเชื่อมต่อก่อนสมัครสมาชิก');
      }

      await _sb.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );
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
      await _sb.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.ckdnutrition://reset-callback/',
      );
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
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        clientId: iosClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return Failure('ยกเลิกการเข้าสู่ระบบด้วย Google');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return Failure('ไม่สามารถดึงข้อมูลยืนยันตัวตนจาก Google ได้');
      }

      await _sb.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
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
