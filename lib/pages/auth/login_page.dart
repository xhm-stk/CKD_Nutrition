import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/auth_controller.dart';
import '../../../providers/auth_providers.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/mesh_gradient_background.dart';
import 'widgets/login_form.dart';
import 'widgets/social_auth_buttons.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // รับฟัง Error เพื่อแสดง SnackBar
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorBase,
          ),
        );
        Future.microtask(
          () => ref.read(loginControllerProvider.notifier).clearError(),
        );
      }

      if (next.isSuccess && (previous == null || !previous.isSuccess)) {
        ref.read(sessionUnlockedProvider.notifier).state = true;
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
                  const SizedBox(height: 80),

                  // Logo Identity — Emerald Glow
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_rounded,
                            color: AppTheme.brandPrimary,
                            size: 40,
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Nutrition',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.brandPrimary,
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideY(begin: -0.1, curve: Curves.easeOutCubic),
                  const SizedBox(height: 48),

                  // Header Texts
                  Text(
                        'ยินดีต้อนรับกลับ',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fade(delay: 200.ms, duration: 500.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  Text(
                    'เข้าสู่ระบบเพื่อจัดการโภชนาการของคุณต่อ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ).animate().fade(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 48),

                  // Inputs
                  const LoginForm()
                      .animate()
                      .fade(delay: 400.ms, duration: 500.ms)
                      .slideY(begin: 0.05),
                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'หรือเข้าใช้งานผ่าน',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 500.ms, duration: 500.ms),
                  const SizedBox(height: 32),

                  // Social Buttons
                  const SocialAuthButtons()
                      .animate()
                      .fade(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.05),
                  const SizedBox(height: 48),

                  // Footer Text Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ยังไม่มีบัญชีใช่ไหม? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/register');
                        },
                        child: const Text(
                          'สร้างบัญชีใหม่',
                          style: TextStyle(
                            color: AppTheme.brandPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 700.ms, duration: 500.ms),
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
