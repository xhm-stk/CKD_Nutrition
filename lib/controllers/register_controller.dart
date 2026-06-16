import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../core/result.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final registerControllerProvider = StateNotifierProvider.autoDispose<RegisterController, RegisterState>((ref) {
  return RegisterController(ref.watch(authRepositoryProvider));
});

class RegisterController extends StateNotifier<RegisterState> {
  final AuthRepository _repo;

  RegisterController(this._repo) : super(RegisterState());

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repo.register(email, password);

      switch (result) {
        case Success():
          state = state.copyWith(isLoading: false, isSuccess: true);
        case Failure(:final userMessage):
          state = state.copyWith(isLoading: false, errorMessage: userMessage);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'เกิดข้อผิดพลาดในการลงทะเบียน กรุณาลองใหม่อีกครั้ง');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
