import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/auth_controller.dart';
import '../../../providers/auth_providers.dart';
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
            backgroundColor: const Color(0xFFEF4444), // Ruby Red
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
      body: Stack(
        children: [
          // 1. Mesh Gradient Background Effect
          Container(color: const Color(0xFF090E17)), // Base Void Navy
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),

          // 2. Foreground Content
          SafeArea(
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
                    const SizedBox(height: 80), // Push down to sweet spot
                    // Logo Identity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          color: const Color(0xFF00E5FF),
                          size: 40,
                          shadows: [
                            Shadow(
                              color: const Color(
                                0xFF00E5FF,
                              ).withValues(alpha: 0.5),
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
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Header Texts
                    Text(
                      'ยินดีต้อนรับกลับ',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เข้าสู่ระบบเพื่อจัดการโภชนาการของคุณต่อ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Inputs
                    const LoginForm(),
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
                    ),
                    const SizedBox(height: 32),

                    // Social Buttons
                    const SocialAuthButtons(),
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
                              color: Color(0xFF00E5FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
