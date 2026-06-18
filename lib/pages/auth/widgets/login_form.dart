import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/auth_controller.dart';
import '../../../repositories/auth_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/premium_primary_button.dart';
import '../../../widgets/premium_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _emailError;
  String? _passError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _validateAndLogin() async {
    setState(() {
      _emailError = null;
      _passError = null;
    });

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    bool isValid = true;

    if (email.isEmpty) {
      _emailError = 'กรุณากรอกอีเมล';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'รูปแบบอีเมลไม่ถูกต้อง';
      isValid = false;
    }

    if (pass.isEmpty) {
      _passError = 'กรุณากรอกรหัสผ่าน';
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    await ref.read(loginControllerProvider.notifier).login(email, pass);
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isDialogLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B), // bgElevated
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.lock_reset_rounded,
                    color: Color(0xFF00E5FF),
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text('รีเซ็ตรหัสผ่าน', style: TextStyle(color: Colors.white)),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'กรุณากรอกอีเมลที่ใช้สมัครบัญชีของคุณ ระบบจะส่งลิงก์ตั้งรหัสผ่านใหม่ไปให้ที่กล่องจดหมายของคุณ',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PremiumTextField(
                      label: 'อีเมลของคุณ',
                      hint: 'example@gmail.com',
                      controller: emailCtrl,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isDialogLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                isDialogLoading
                    ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                    )
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (emailCtrl.text.isEmpty) return;
                        setDialogState(() => isDialogLoading = true);
                        await ref
                            .read(authRepositoryProvider)
                            .resetPassword(emailCtrl.text.trim());
                        if (!context.mounted) return;
                        setDialogState(() => isDialogLoading = false);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'หากอีเมลถูกต้อง ระบบได้ส่งลิงก์รีเซ็ตรหัสผ่านไปให้แล้ว กรุณาตรวจสอบกล่องจดหมาย',
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Color(0xFF00E5FF),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      },
                      child: const Text('ส่งลิงก์'),
                    ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loginState = ref.watch(loginControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          PremiumTextField(
            label: l10n.email,
            hint: 'example@gmail.com',
            controller: _emailCtrl,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            onChanged: (val) {
              if (_emailError != null) setState(() => _emailError = null);
            },
          ),
          const SizedBox(height: 16),
          PremiumTextField(
            label: l10n.password,
            controller: _passCtrl,
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            errorText: _passError,
            onChanged: (val) {
              if (_passError != null) setState(() => _passError = null);
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'ลืมรหัสผ่าน?',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          PremiumPrimaryButton(
            text: l10n.login,
            isLoading: loginState.isLoading,
            onPressed: _validateAndLogin,
          ),
        ],
      ),
    );
  }
}
