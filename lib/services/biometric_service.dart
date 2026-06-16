import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// ตรวจสอบว่าเครื่องนี้รองรับการสแกนนิ้ว/หน้า หรือไม่
  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck || isDeviceSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// ดำเนินการขอยืนยันตัวตน (สแกนนิ้ว/หน้า)
  Future<bool> authenticate() async {
    final isSupported = await canCheckBiometrics();
    if (!isSupported) {
      // หากเครื่องไม่รองรับ ให้ Return false ห้ามข้าม (Bypass) เด็ดขาด (Security Risk)
      // ผู้ใช้ต้องใช้วิธี Log out และ Login ใหม่ด้วยรหัสผ่านแทน
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason:
            'กรุณาสแกนใบหน้าหรือลายนิ้วมือเพื่อเข้าถึงข้อมูลสุขภาพส่วนบุคคลของคุณ',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly:
              false, // อนุญาตให้ใช้ PIN/Password เครื่องได้ด้วยถ้าสแกนนิ้วไม่ผ่าน
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}
