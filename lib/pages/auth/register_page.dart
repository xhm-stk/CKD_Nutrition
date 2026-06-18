import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/register_controller.dart';
import '../../../providers/auth_providers.dart';
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
            backgroundColor: const Color(0xFFEF4444),
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
              backgroundColor: Color(0xFFF59E0B),
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
              backgroundColor: Color(0xFF00E5FF),
            ),
          );
          context.go('/health-setup');
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. Mesh Gradient Background Effect
          Container(color: const Color(0xFF090E17)), // Base Void Navy
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFF59E0B,
                ).withValues(alpha: 0.1), // Amber blur
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF00E5FF,
                ).withValues(alpha: 0.15), // Cyan blur
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
                    const SizedBox(height: 48), // Top spacing
                    // Logo Identity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          color: const Color(0xFF00E5FF),
                          size: 32,
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
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Header Texts
                    Text(
                      'เริ่มต้นดูแลสุขภาพไต',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'สร้างบัญชีใหม่เพื่อรับแผนการกินอาหารที่ออกแบบมาเพื่อคุณโดยเฉพาะ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Form
                    const RegisterForm(),
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
                            context.pop(); // Go back to login
                          },
                          child: const Text(
                            'เข้าสู่ระบบ',
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
