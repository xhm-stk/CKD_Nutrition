import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/biometric_service.dart';
import '../../providers/auth_providers.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';

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
      body: MeshGradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.brandPrimary.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 80,
                    color: AppTheme.brandPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'ข้อมูลสุขภาพของคุณถูกล็อกไว้',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 48),
                if (!_isAuthenticating)
                  ElevatedButton.icon(
                    onPressed: _startAuth,
                    icon: const Icon(Icons.lock_open_rounded),
                    label: const Text('ยืนยันตัวตนอีกครั้ง'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (!_isAuthenticating)
                  TextButton.icon(
                    onPressed: () async {
                      await ref.read(authControllerProvider).logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('ออกจากระบบ'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (_isAuthenticating)
                  const CircularProgressIndicator(color: AppTheme.brandPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
