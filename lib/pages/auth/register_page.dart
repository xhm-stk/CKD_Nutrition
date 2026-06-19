import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/register_controller.dart';
import '../../../providers/auth_providers.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/mesh_gradient_background.dart';
import 'widgets/register_form.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorBase,
          ),
        );
        Future.microtask(
          () => ref.read(registerControllerProvider.notifier).clearError(),
        );
      }

      if (next.isSuccess && (previous == null || !previous.isSuccess)) {
        ref.read(sessionUnlockedProvider.notifier).state = true;
        final user = Supabase.instance.client.auth.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'สมัครสมาชิกสำเร็จ! กรุณาเปิดกล่องจดหมายของคุณและคลิกลิงก์ยืนยันตัวตนในอีเมลก่อนเริ่มใช้งาน',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: AppTheme.brandSecondary,
              duration: Duration(seconds: 8),
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'สมัครสมาชิกสำเร็จแล้ว! กำลังนำคุณไปยังขั้นตอนตั้งค่าสุขภาพ',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: AppTheme.brandPrimary,
            ),
          );
          context.go('/health-setup');
        }
      }
    });

    return Scaffold(
      body: MeshGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),

                  // Logo Identity — Emerald
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_rounded,
                            color: AppTheme.brandPrimary,
                            size: 32,
                            shadows: [
                              Shadow(
                                color: AppTheme.brandPrimary.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CKD',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Nutrition',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.brandPrimary,
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideY(begin: -0.1, curve: Curves.easeOutCubic),
                  const SizedBox(height: 32),

                  // Header Texts
                  Text(
                        'เริ่มต้นดูแลสุขภาพไต',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fade(delay: 200.ms, duration: 500.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  Text(
                    'สร้างบัญชีใหม่เพื่อรับแผนการกินอาหารที่ออกแบบมาเพื่อคุณโดยเฉพาะ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ).animate().fade(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 48),

                  // Form
                  const RegisterForm()
                      .animate()
                      .fade(delay: 400.ms, duration: 500.ms)
                      .slideY(begin: 0.05),
                  const SizedBox(height: 32),

                  // Footer Text Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'มีบัญชีอยู่แล้ว? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            color: AppTheme.brandPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 500.ms, duration: 500.ms),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
