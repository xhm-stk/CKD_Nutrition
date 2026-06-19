import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/core_providers.dart';
import '../../../repositories/auth_repository.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../widgets/premium_dropdown_field.dart';
import '../../../theme/app_theme.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage = 'stage_3a';
  int _avatarId = 1;
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ref.read(healthProfileServiceProvider).getHealthProfile();
      if (data != null && mounted) {
        setState(() {
          _weightCtrl.text = data['weight_kg']?.toString() ?? '';
          _heightCtrl.text = data['height_cm']?.toString() ?? '';
          _selectedGender = data['gender'] ?? 'male';
          _selectedStage = data['ckd_stage'] ?? 'stage_3a';
          _avatarId = data['avatar_id'] ?? 1;
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
      await ref.read(healthProfileServiceProvider).saveHealthProfile(
            weightKg: double.parse(_weightCtrl.text.trim()),
            heightCm: double.parse(_heightCtrl.text.trim()),
            gender: _selectedGender,
            ckdStage: _selectedStage,
          );
          
      final user = ref.read(supabaseProvider).auth.currentUser;
      if (user != null) {
        await ref.read(supabaseProvider).from('users').update({
          'avatar_id': _avatarId,
        }).eq('id', user.id);
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      ref.invalidate(dashboardSummaryProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลสำเร็จ'),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง'),
          backgroundColor: AppTheme.errorBase,
        ),
      );
    }
  }

  void _changePassword() async {
    final supabase = ref.read(supabaseProvider);
    final user = supabase.auth.currentUser;
    if (user?.email == null) return;
    try {
      await supabase.auth.resetPasswordForEmail(user!.email!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว'),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการส่งลิงก์รีเซ็ตรหัสผ่าน'),
          backgroundColor: AppTheme.errorBase,
        ),
      );
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('ยืนยันออกจากระบบ', style: TextStyle(color: Colors.white)),
        content: const Text(
          'คุณต้องการออกจากระบบใช่หรือไม่?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.white54)),
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

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('ยืนยันการลบบัญชี', style: TextStyle(color: AppTheme.errorBase)),
        content: const Text(
          'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชี? ข้อมูลทั้งหมดของคุณจะถูกลบและไม่สามารถกู้คืนได้',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorBase,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authRepositoryProvider).deleteAccount();
            },
            child: const Text('ลบถาวร'),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('เลือกอวตาร์ของคุณ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(6, (index) {
                  final id = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _avatarId = id);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _avatarId == id ? AppTheme.brandPrimary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: _avatarId == id ? AppTheme.brandPrimary.withValues(alpha: 0.2) : Colors.white10,
                        child: Text('A$id', style: TextStyle(color: _avatarId == id ? AppTheme.brandPrimary : Colors.white54, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
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
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        title: const Text('บัญชีของฉัน'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.bgElevated,
                          child: Text('A$_avatarId', style: const TextStyle(fontSize: 32, color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showAvatarPicker,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.brandPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 32),
                  const Text('ข้อมูลสุขภาพ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                      .animate().fade(duration: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: _weightCtrl,
                    label: 'น้ำหนัก (kg)',
                    prefixIcon: Icons.monitor_weight_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    controller: _heightCtrl,
                    label: 'ส่วนสูง (cm)',
                    prefixIcon: Icons.height_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    onChanged: (val) => setState(() => _selectedGender = val!),
                  ).animate().fade(duration: 700.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  PremiumDropdownField<String>(
                    label: 'ระยะโรคไต (CKD Stage)',
                    value: _selectedStage,
                    prefixIcon: Icons.medical_services_outlined,
                    items: const [
                      DropdownMenuItem(value: 'stage_1', child: Text('ระยะที่ 1')),
                      DropdownMenuItem(value: 'stage_2', child: Text('ระยะที่ 2')),
                      DropdownMenuItem(value: 'stage_3a', child: Text('ระยะที่ 3a')),
                      DropdownMenuItem(value: 'stage_3b', child: Text('ระยะที่ 3b')),
                      DropdownMenuItem(value: 'stage_4', child: Text('ระยะที่ 4')),
                      DropdownMenuItem(value: 'stage_5', child: Text('ระยะที่ 5 (ฟอกไต)')),
                    ],
                    onChanged: (val) => setState(() => _selectedStage = val!),
                  ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
                  const SizedBox(height: 32),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
                      : Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [AppTheme.brandPrimary, AppTheme.brandAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.brandPrimary.withValues(alpha: 0.3),
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
                              'บันทึกข้อมูลสุขภาพ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ).animate().fade(duration: 900.ms).scale(begin: const Offset(0.95, 0.95)),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.white10).animate().fade(duration: 1000.ms),
                  const SizedBox(height: 16),
                  const Text('การตั้งค่าบัญชี', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                      .animate().fade(duration: 1000.ms),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _changePassword,
                    icon: const Icon(Icons.lock_reset, color: Colors.white70),
                    label: const Text('เปลี่ยนรหัสผ่าน', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ).animate().fade(duration: 1100.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    label: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ).animate().fade(duration: 1200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _confirmDeleteAccount,
                    icon: const Icon(Icons.delete_forever, color: AppTheme.errorBase),
                    label: const Text('ลบบัญชีผู้ใช้', style: TextStyle(color: AppTheme.errorBase)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.errorBase),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ).animate().fade(duration: 1300.ms).slideY(begin: 0.2),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
