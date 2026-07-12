import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/register_controller.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';
import '../../../widgets/premium_primary_button.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../theme/app_theme.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _acceptPrivacyPolicy = false;

  String? _nameError;
  String? _emailError;
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
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
      _nameError =
          _nameCtrl.text.trim().isEmpty
              ? AppLocalizations.of(context)!.enterName
              : null;

      final email = _emailCtrl.text.trim();
      if (email.isEmpty) {
        _emailError = AppLocalizations.of(context)!.enterEmail;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailError = AppLocalizations.of(context)!.invalidEmail;
      } else {
        _emailError = null;
      }

      final pass = _passCtrl.text;
      if (pass.isEmpty) {
        _passError = AppLocalizations.of(context)!.enterPassword;
      } else if (_calculatePasswordStrength(pass) < 4) {
        _passError = 'รหัสผ่านยังไม่แข็งแกร่งพอ';
      } else {
        _passError = null;
      }

      final confirm = _confirmPassCtrl.text;
      if (confirm.isEmpty) {
        _confirmError = 'กรุณายืนยันรหัสผ่าน';
      } else if (confirm != pass) {
        _confirmError = 'รหัสผ่านไม่ตรงกัน';
      } else {
        _confirmError = null;
      }
    });
  }

  bool _isFormValid() {
    if (_nameCtrl.text.trim().isEmpty) return false;
    final email = _emailCtrl.text.trim();
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    if (_calculatePasswordStrength(_passCtrl.text) < 4) return false;
    if (_passCtrl.text != _confirmPassCtrl.text) return false;
    if (!_acceptPrivacyPolicy) return false;
    return true;
  }

  void _register() {
    FocusManager.instance.primaryFocus?.unfocus();
    _validateAll();
    if (!_isFormValid()) return;

    ref
        .read(registerControllerProvider.notifier)
        .register(
          _emailCtrl.text.trim(),
          _passCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
        );
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

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.getElevated(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                color: AppTheme.brandPrimary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'นโยบายความเป็นส่วนตัว',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อตกลงและนโยบายความเป็นส่วนตัว (Privacy Policy)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '1. การรวบรวมข้อมูลสุขภาพ\n'
                  'แอปพลิเคชัน CKD Nutrition จำเป็นต้องรวบรวมข้อมูลสุขภาพส่วนบุคคลของคุณ เพื่อใช้ในการคำนวณโควต้าที่เหมาะสม\n\n'
                  '2. การรักษาความปลอดภัยของข้อมูล\n'
                  'ข้อมูลของคุณจะถูกจัดเก็บอย่างปลอดภัยและเข้ารหัส (RLS) \n\n'
                  '3. การแบ่งปันข้อมูล\n'
                  'เราไม่มีนโยบายการเปิดเผยข้อมูลส่วนบุคคลหรือข้อมูลสุขภาพของคุณให้กับบริษัทภายนอก',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'รับทราบ',
                style: TextStyle(color: AppTheme.brandPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final registerState = ref.watch(registerControllerProvider);
    final isValid = _isFormValid();

    return Column(
      children: [
        PremiumTextField(
          label: 'ชื่อเล่น / ชื่อเรียก',
          controller: _nameCtrl,
          prefixIcon: Icons.person_outline_rounded,
          errorText: _nameError,
          onChanged: (v) {
            if (_nameError != null) setState(() => _nameError = null);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        PremiumTextField(
          label: l10n.email,
          controller: _emailCtrl,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          onChanged: (v) {
            if (_emailError != null) setState(() => _emailError = null);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        PremiumTextField(
          label: l10n.password,
          controller: _passCtrl,
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          errorText: _passError,
          onChanged: (v) {
            if (_passError != null) setState(() => _passError = null);
            if (_confirmError != null && _confirmPassCtrl.text == v) {
              setState(() => _confirmError = null);
            }
            setState(() {});
          },
        ),
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),
        PremiumTextField(
          label: l10n.confirmPassword,
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
        const SizedBox(height: 24),

        // Privacy Policy Checkbox
        InkWell(
          onTap: () {
            setState(() => _acceptPrivacyPolicy = !_acceptPrivacyPolicy);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _acceptPrivacyPolicy,
                    onChanged: (val) {
                      setState(() => _acceptPrivacyPolicy = val ?? false);
                    },
                    activeColor: AppTheme.brandPrimary,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        'ฉันยอมรับ ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showPrivacyPolicyDialog,
                        child: const Text(
                          'เงื่อนไขและนโยบายความเป็นส่วนตัว',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.brandPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        PremiumPrimaryButton(
          text: l10n.register,
          isLoading: registerState.isLoading,
          onPressed: isValid ? _register : null,
        ),
      ],
    );
  }
}
