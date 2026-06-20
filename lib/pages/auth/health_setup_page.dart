import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/core_providers.dart';
import '../../../repositories/auth_repository.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../widgets/premium_dropdown_field.dart';
import '../../../theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthSetupPage extends ConsumerStatefulWidget {
  const HealthSetupPage({super.key});
  @override
  ConsumerState<HealthSetupPage> createState() => _HealthSetupPageState();
}

class _HealthSetupPageState extends ConsumerState<HealthSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage = 'stage_3a';
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data =
          await ref.read(healthProfileServiceProvider).getHealthProfile();
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      final userName = user?.userMetadata?['name'] ?? '';

      if (data != null && mounted) {
        setState(() {
          _nameCtrl.text = userName;
          _weightCtrl.text = data['weight_kg']?.toString() ?? '';
          _heightCtrl.text = data['height_cm']?.toString() ?? '';
          _selectedGender = data['gender'] ?? 'male';
          _selectedStage = data['ckd_stage'] ?? 'stage_3a';
        });
      } else if (mounted) {
        setState(() {
          _nameCtrl.text = userName;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newName = _nameCtrl.text.trim();
      if (newName.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(data: {'name': newName}),
        );
      }

      await ref
          .read(healthProfileServiceProvider)
          .saveHealthProfile(
            weightKg: double.parse(_weightCtrl.text.trim()),
            heightCm: double.parse(_heightCtrl.text.trim()),
            gender: _selectedGender,
            ckdStage: _selectedStage,
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      ref.invalidate(dashboardSummaryProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );

      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      debugPrint('Setup Profile Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกโปรไฟล์สุขภาพล้มเหลว กรุณาลองใหม่อีกครั้ง'),
          backgroundColor: AppTheme.errorBase,
        ),
      );
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.bgElevated,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              'ยืนยันออกจากระบบ',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'คุณต้องการออกจากระบบใช่หรือไม่?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(authRepositoryProvider).logout();
                },
                child: const Text('ออกจากระบบ'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        title: const Text(
          'ตั้งค่าข้อมูลสุขภาพ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white70,
          ),
          tooltip: 'ย้อนกลับไปหน้าสร้างบัญชี',
          onPressed: _confirmLogout,
        ),
      ),
      body:
          _isFetching
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.brandPrimary),
              )
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'กรุณากรอกข้อมูลเพื่อปรับแต่งการแนะนำอาหาร',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 32),
                    PremiumTextField(
                      controller: _nameCtrl,
                      label: 'ชื่อของคุณ',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ).animate().fade(duration: 450.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    PremiumTextField(
                      controller: _weightCtrl,
                      label: 'น้ำหนัก (kg)',
                      prefixIcon: Icons.monitor_weight_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ).animate().fade(duration: 500.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    PremiumTextField(
                      controller: _heightCtrl,
                      label: 'ส่วนสูง (cm)',
                      prefixIcon: Icons.height_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ).animate().fade(duration: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    PremiumDropdownField<String>(
                      label: 'เพศ',
                      value: _selectedGender,
                      prefixIcon: Icons.person_outline,
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('ชาย')),
                        DropdownMenuItem(value: 'female', child: Text('หญิง')),
                      ],
                      onChanged:
                          (val) => setState(() => _selectedGender = val!),
                    ).animate().fade(duration: 700.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    PremiumDropdownField<String>(
                      label: 'ระยะโรคไต (CKD Stage)',
                      value: _selectedStage,
                      prefixIcon: Icons.medical_services_outlined,
                      items: const [
                        DropdownMenuItem(
                          value: 'stage_1',
                          child: Text('ระยะที่ 1'),
                        ),
                        DropdownMenuItem(
                          value: 'stage_2',
                          child: Text('ระยะที่ 2'),
                        ),
                        DropdownMenuItem(
                          value: 'stage_3a',
                          child: Text('ระยะที่ 3a'),
                        ),
                        DropdownMenuItem(
                          value: 'stage_3b',
                          child: Text('ระยะที่ 3b'),
                        ),
                        DropdownMenuItem(
                          value: 'stage_4',
                          child: Text('ระยะที่ 4'),
                        ),
                        DropdownMenuItem(
                          value: 'stage_5',
                          child: Text('ระยะที่ 5 (ฟอกไต)'),
                        ),
                      ],
                      onChanged: (val) => setState(() => _selectedStage = val!),
                    ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
                    const SizedBox(height: 48),
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.brandPrimary,
                          ),
                        )
                        : Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.brandPrimary,
                                    AppTheme.brandAccent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.brandPrimary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'เริ่มต้นใช้งานแอป',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fade(duration: 900.ms)
                            .scale(begin: const Offset(0.95, 0.95)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
    );
  }
}
