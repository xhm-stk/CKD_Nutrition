import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/register_controller.dart';
import '../../../l10n/app_localizations.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _acceptPrivacyPolicy = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.privacy_tip_outlined,
                color: Colors.teal.shade700,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text('นโยบายความเป็นส่วนตัว'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อตกลงและนโยบายความเป็นส่วนตัว (Privacy Policy)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  '1. การรวบรวมข้อมูลสุขภาพ\n'
                  'แอปพลิเคชัน CKD Nutrition จำเป็นต้องรวบรวมข้อมูลสุขภาพส่วนบุคคลของคุณ เช่น น้ำหนัก ส่วนสูง เพศ และระยะโรคไต (CKD Stage) เพื่อใช้ในการคำนวณโควต้าโปรตีน โซเดียม โพแทสเซียม และปริมาณน้ำที่เหมาะสมสำหรับสุขภาพไตของคุณ\n\n'
                  '2. การรักษาความปลอดภัยของข้อมูล\n'
                  'ข้อมูลทั้งหมดของคุณจะถูกจัดเก็บอย่างปลอดภัยบนระบบฐานข้อมูล Supabase ภายใต้เกราะป้องกัน Row Level Security (RLS) ซึ่งจะจำกัดสิทธิ์ให้เข้าถึงได้เฉพาะเจ้าของบัญชีเท่านั้น\n\n'
                  '3. การแบ่งปันข้อมูล\n'
                  'เราไม่มีนโยบายการเปิดเผยข้อมูลส่วนบุคคลหรือข้อมูลสุขภาพของคุณให้กับบริษัทภายนอกเพื่อประโยชน์ทางการค้าใดๆ ทั้งสิ้น ข้อมูลทั้งหมดจะใช้เพื่อวัตถุประสงค์ในการคำนวณอาหารภายในแอปพลิเคชันนี้เท่านั้น',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('รับทราบ'),
            ),
          ],
        );
      },
    );
  }

  void _register() {
    if (!_acceptPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากดยอมรับนโยบายความเป็นส่วนตัวก่อนสมัครสมาชิก'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    ref
        .read(registerControllerProvider.notifier)
        .register(_emailCtrl.text.trim(), _passCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final registerState = ref.watch(registerControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email,
              hintText: 'example@gmail.com',
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: Colors.teal.shade600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'กรุณากรอกอีเมล';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))
                return 'กรุณากรอกอีเมลที่ถูกต้อง';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscurePass,
            decoration: InputDecoration(
              labelText: l10n.password,
              hintText: 'อย่างน้อย 8 ตัวอักษร (A-Z, a-z, 0-9, อักขระพิเศษ)',
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Colors.teal.shade600,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.teal.shade600,
                ),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'กรุณากรอกรหัสผ่าน';
              if (val.length < 8)
                return 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร';
              if (!RegExp(r'[A-Z]').hasMatch(val))
                return 'ต้องมีตัวพิมพ์ใหญ่ (A-Z) อย่างน้อย 1 ตัว';
              if (!RegExp(r'[a-z]').hasMatch(val))
                return 'ต้องมีตัวพิมพ์เล็ก (a-z) อย่างน้อย 1 ตัว';
              if (!RegExp(r'[0-9]').hasMatch(val))
                return 'ต้องมีตัวเลข (0-9) อย่างน้อย 1 ตัว';
              if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(val)) {
                return 'ต้องมีอักขระพิเศษ (เช่น !@#\$%^&*) อย่างน้อย 1 ตัว';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPassCtrl,
            obscureText: _obscureConfirmPass,
            decoration: InputDecoration(
              labelText: l10n.confirmPassword,
              prefixIcon: Icon(
                Icons.lock_clock_outlined,
                color: Colors.teal.shade600,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.teal.shade600,
                ),
                onPressed:
                    () => setState(
                      () => _obscureConfirmPass = !_obscureConfirmPass,
                    ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'กรุณากรอกรหัสยืนยัน';
              if (val != _passCtrl.text) return 'รหัสผ่านไม่ตรงกัน';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                activeColor: Colors.teal.shade700,
                value: _acceptPrivacyPolicy,
                onChanged:
                    (val) =>
                        setState(() => _acceptPrivacyPolicy = val ?? false),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _showPrivacyPolicyDialog,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.teal.shade800,
                        fontSize: 13,
                        fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                      ),
                      children: [
                        const TextSpan(text: 'ฉันยอมรับ '),
                        TextSpan(
                          text: 'นโยบายความเป็นส่วนตัว และ ข้อตกลงการใช้งาน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          registerState.isLoading
              ? const CircularProgressIndicator()
              : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade700, Colors.green.shade600],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(child: Text(l10n.register)),
                ),
              ),
        ],
      ),
    );
  }
}
