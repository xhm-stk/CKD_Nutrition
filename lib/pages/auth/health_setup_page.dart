import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/core_providers.dart';
import '../../../repositories/auth_repository.dart';

class HealthSetupPage extends ConsumerStatefulWidget {
  const HealthSetupPage({super.key});
  @override
  ConsumerState<HealthSetupPage> createState() => _HealthSetupPageState();
}

class _HealthSetupPageState extends ConsumerState<HealthSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage = 'stage_3a'; // ตั้งค่าเริ่มต้นเป็นระยะ 3a
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
      if (data != null && mounted) {
        setState(() {
          _weightCtrl.text = data['weight_kg']?.toString() ?? '';
          _heightCtrl.text = data['height_cm']?.toString() ?? '';
          _selectedGender = data['gender'] ?? 'male';
          _selectedStage = data['ckd_stage'] ?? 'stage_3a';
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
      // เซฟโปรไฟล์ขึ้น Cloud
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

      // เซฟเสร็จพาไปหน้า Dashboard เลย
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      debugPrint('Setup Profile Error: $e'); // ซ่อน Exception ดิบ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกโปรไฟล์สุขภาพล้มเหลว กรุณาลองใหม่อีกครั้ง'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลสุขภาพของคุณ'),
        actions: [
          // เพิ่มปุ่มออกจากระบบ (Sign Out) เพื่อย้อนกลับไปหน้าเข้าสู่ระบบได้ทุกเมื่อ
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'ย้อนกลับ / ออกจากระบบ',
            onPressed: () async {
              await ref.read(authRepositoryProvider).logout();
            },
          ),
        ],
      ),
      body:
          _isFetching
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    TextFormField(
                      key: const Key('input_weight'),
                      controller: _weightCtrl,
                      decoration: const InputDecoration(
                        labelText: 'น้ำหนัก (kg)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'กรุณากรอกน้ำหนัก';
                        }
                        final w = double.tryParse(val);
                        if (w == null) return 'กรุณากรอกตัวเลขเท่านั้น';
                        if (w < 10 || w > 500) {
                          return 'น้ำหนักต้องอยู่ระหว่าง 10-500 กก.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('input_height'),
                      controller: _heightCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ส่วนสูง (cm)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'กรุณากรอกส่วนสูง';
                        }
                        final h = double.tryParse(val);
                        if (h == null) return 'กรุณากรอกตัวเลขเท่านั้น';
                        if (h < 50 || h > 300) {
                          return 'ส่วนสูงต้องอยู่ระหว่าง 50-300 ซม.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const Key('dropdown_gender'),
                      value: _selectedGender,
                      decoration: const InputDecoration(labelText: 'เพศ'),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('ชาย')),
                        DropdownMenuItem(value: 'female', child: Text('หญิง')),
                      ],
                      onChanged:
                          (val) => setState(() => _selectedGender = val!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const Key('dropdown_ckd_stage'),
                      value: _selectedStage,
                      decoration: const InputDecoration(
                        labelText: 'ระยะโรคไต (CKD Stage)',
                      ),
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
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          key: const Key('btn_save_profile'),
                          onPressed: _saveProfile,
                          child: const Text('บันทึกและเริ่มใช้งาน'),
                        ),
                  ],
                ),
              ),
    );
  }
}
