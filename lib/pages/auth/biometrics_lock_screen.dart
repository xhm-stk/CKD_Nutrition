import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/biometric_service.dart';
import '../../providers/auth_providers.dart';
import '../../controllers/auth_controller.dart';

class BiometricsLockScreen extends ConsumerStatefulWidget {
  const BiometricsLockScreen({super.key});

  @override
  ConsumerState<BiometricsLockScreen> createState() =>
      _BiometricsLockScreenState();
}

class _BiometricsLockScreenState extends ConsumerState<BiometricsLockScreen> {
  bool _isAuthenticating = false;
  String _message = 'แตะเพื่อสแกนใบหน้า/ลายนิ้วมือ';

  @override
  void initState() {
    super.initState();
    // เมื่อเปิดหน้านี้ขึ้นมา ให้บังคับเรียกสแกนทันที
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAuth();
    });
  }

  Future<void> _startAuth() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _message = 'กำลังตรวจสอบการยืนยันตัวตน...';
    });

    final biometricService = ref.read(biometricServiceProvider);
    final success = await biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
      });
      if (success) {
        ref.read(sessionUnlockedProvider.notifier).state = true;
        // หากสแกนผ่าน ให้ปิดหน้าต่างล็อกแล้วกลับไปหน้า Dashboard/หน้าที่ค้างอยู่
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/dashboard');
        }
      } else {
        setState(() {
          _message = 'การยืนยันตัวตนล้มเหลว กรุณาลองอีกครั้ง';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint_rounded,
                size: 100,
                color: Colors.teal.shade700,
              ),
              const SizedBox(height: 24),
              const Text(
                'ข้อมูลสุขภาพของคุณถูกล็อกไว้',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _message,
                style: TextStyle(fontSize: 16, color: Colors.teal.shade900),
              ),
              const SizedBox(height: 48),
              if (!_isAuthenticating)
                ElevatedButton.icon(
                  onPressed: _startAuth,
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text('ยืนยันตัวตนอีกครั้ง'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (!_isAuthenticating)
                TextButton.icon(
                  onPressed: () async {
                    await ref.read(authControllerProvider).logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('ออกจากระบบ'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              if (_isAuthenticating) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
