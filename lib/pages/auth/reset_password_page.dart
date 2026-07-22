import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/mesh_gradient_background.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../widgets/premium_primary_button.dart';
import '../../router/app_router.dart'; // to read isRecoveringPasswordProvider

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _isLoading = false;
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  int _calculatePasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  void _validateAll() {
    setState(() {
      final pass = _passCtrl.text;
      if (pass.isEmpty) {
        _passError = 'กรุณากรอกรหัสผ่านใหม่';
      } else if (_calculatePasswordStrength(pass) < 4) {
        _passError = 'รหัสผ่านยังไม่แข็งแกร่งพอ';
      } else {
        _passError = null;
      }

      final confirm = _confirmPassCtrl.text;
      if (confirm.isEmpty) {
        _confirmError = 'กรุณายืนยันรหัสผ่านใหม่';
      } else if (confirm != pass) {
        _confirmError = 'รหัสผ่านไม่ตรงกัน';
      } else {
        _confirmError = null;
      }
    });
  }

  bool _isFormValid() {
    if (_calculatePasswordStrength(_passCtrl.text) < 4) return false;
    if (_passCtrl.text != _confirmPassCtrl.text) return false;
    return true;
  }

  void _resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _validateAll();
    if (!_isFormValid()) return;

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passCtrl.text.trim()),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Reset recovery state so routing redirects properly
      ref.read(isRecoveringPasswordProvider.notifier).state = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เปลี่ยนรหัสผ่านใหม่สำเร็จแล้ว! กำลังเข้าสู่ระบบ...'),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );

      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เปลี่ยนรหัสผ่านไม่สำเร็จ: ${e.toString()}'),
          backgroundColor: AppTheme.errorBase,
        ),
      );
    }
  }

  Widget _buildPasswordStrengthIndicator() {
    final score = _calculatePasswordStrength(_passCtrl.text);
    if (_passCtrl.text.isEmpty) return const SizedBox.shrink();

    Color strengthColor = const Color(0xFFEF4444); // Red
    String text = 'รัดกุมต่ำ (ควรมี 8 ตัวอักษร, พิมพ์ใหญ่, ตัวเลข, สัญลักษณ์)';
    double widthFactor = 0.33;

    if (score == 4) {
      strengthColor = const Color(0xFF10B981); // Green
      text = 'รัดกุมสูงมาก';
      widthFactor = 1.0;
    } else if (score >= 2) {
      strengthColor = const Color(0xFFF59E0B); // Amber
      text = 'รัดกุมปานกลาง (เพิ่มตัวพิมพ์ใหญ่/ตัวเลข/สัญลักษณ์)';
      widthFactor = 0.66;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: MediaQuery.of(context).size.width * widthFactor,
                decoration: BoxDecoration(
                  color: strengthColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: strengthColor.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: TextStyle(color: strengthColor, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isFormValid();

    return Scaffold(
      body: MeshGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      color: AppTheme.brandPrimary,
                      size: 64,
                    ).animate().scale(
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ตั้งรหัสผ่านใหม่',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'กรุณากรอกรหัสผ่านใหม่ที่คุณต้องการใช้สำหรับบัญชีนี้',
                      style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    PremiumTextField(
                      label: 'รหัสผ่านใหม่',
                      controller: _passCtrl,
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      errorText: _passError,
                      onChanged: (v) {
                        if (_passError != null) {
                          setState(() => _passError = null);
                        }
                        if (_confirmError != null &&
                            _confirmPassCtrl.text == v) {
                          setState(() => _confirmError = null);
                        }
                        setState(() {});
                      },
                    ),
                    _buildPasswordStrengthIndicator(),
                    const SizedBox(height: 16),
                    PremiumTextField(
                      label: 'ยืนยันรหัสผ่านใหม่',
                      controller: _confirmPassCtrl,
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      errorText: _confirmError,
                      onChanged: (v) {
                        if (v == _passCtrl.text) {
                          setState(() => _confirmError = null);
                        } else if (_confirmError == null) {
                          setState(() => _confirmError = 'รหัสผ่านไม่ตรงกัน');
                        }
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 32),
                    PremiumPrimaryButton(
                      text: 'ยืนยันตั้งรหัสผ่านใหม่',
                      isLoading: _isLoading,
                      onPressed: isValid ? _resetPassword : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
