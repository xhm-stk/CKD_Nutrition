import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../core/result.dart';

// State สำหรับหน้า Login
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final int attempts;
  final DateTime? lockoutUntil;
  final bool isSuccess;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.attempts = 0,
    this.lockoutUntil,
    this.isSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? attempts,
    DateTime? lockoutUntil,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // allow null
      attempts: attempts ?? this.attempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref.watch(authRepositoryProvider));
});

class LoginController extends StateNotifier<LoginState> {
  final AuthRepository _repo;

  LoginController(this._repo) : super(LoginState());

  Future<void> login(String email, String password) async {
    // 1. เช็คว่าติด Lockout ไหม
    if (state.isLockedOut) {
      final diffSeconds = state.lockoutUntil!.difference(DateTime.now()).inSeconds;
      state = state.copyWith(errorMessage: 'คุณล็อกอินผิดพลาดเกินกำหนด กรุณารองอีกครั้งในอีก $diffSeconds วินาที');
      return;
    } else if (state.lockoutUntil != null) {
      // หมดเวลา Lockout แล้ว
      state = state.copyWith(attempts: 0, lockoutUntil: null, errorMessage: null);
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.login(email, password);

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false, isSuccess: true, attempts: 0, lockoutUntil: null);
      case Failure(:final userMessage):
        final newAttempts = state.attempts + 1;
        DateTime? newLockout;
        String finalMessage = userMessage;

        if (newAttempts >= 5) {
          newLockout = DateTime.now().add(const Duration(minutes: 1));
          finalMessage = 'กรอกรหัสผ่านผิดครบ 5 ครั้ง! โดนระงับการเข้าใช้งานชั่วคราว 1 นาที';
        } else {
          finalMessage = '$userMessage (เหลือสิทธิ์ให้ลองอีก ${5 - newAttempts} ครั้ง)';
        }

        state = state.copyWith(
          isLoading: false,
          attempts: newAttempts,
          lockoutUntil: newLockout,
          errorMessage: finalMessage,
        );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController {
  final AuthRepository _repo;

  AuthController(this._repo);

  Future<void> logout() async {
    await _repo.logout();
  }

  Future<String?> deleteAccount() async {
    // Returns error message if failed, null if success
    try {
      // We assume _repo.deleteAccount is implemented or we use a Supabase RPC here.
      // Wait, let's check how DashboardPage called it.
      // `final error = await ref.read(authRepositoryProvider).deleteAccount();`
      // So deleteAccount should be in AuthRepository!
      final result = await _repo.deleteAccount();
      if (result case Failure(:final userMessage)) {
        return userMessage;
      }
      return null;
    } catch (e) {
      return 'เกิดข้อผิดพลาดในการลบบัญชี';
    }
  }

  Future<String?> signInWithGoogle() async {
    final result = await _repo.signInWithGoogle();
    if (result case Failure(:final userMessage)) {
      return userMessage;
    }
    return null;
  }

  Future<String?> signInWithApple() async {
    final result = await _repo.signInWithApple();
    if (result case Failure(:final userMessage)) {
      return userMessage;
    }
    return null;
  }
}
