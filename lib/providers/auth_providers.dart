import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core_providers.dart'; // To access supabaseProvider
import '../repositories/auth_repository.dart';

// Provider ที่ใช้จับตาดูสถานะ Login/Logout ตลอดเวลา (Reactive Auth)
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseProvider));
});

// เก็บสถานะการปลดล็อกด้วย Biometrics ในหน่วยความจำ (หายไปเมื่อปิดแอป)
final sessionUnlockedProvider = StateProvider<bool>((ref) => false);
