import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/core_providers.dart';
import '../../../repositories/auth_repository.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../widgets/premium_dropdown_field.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/mesh_gradient_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/notification_service.dart';
import '../../../l10n/app_localizations.dart';

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
  bool _mealRemindersEnabled = false;

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
          _avatarId = data['avatar_id'] ?? 1;
        });
      }

      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _mealRemindersEnabled =
              prefs.getBool('meal_reminders_enabled') ?? false;
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
      final weightClean =
          _weightCtrl.text
              .replaceAll(',', '.')
              .replaceAll(RegExp(r'[^0-9\.]'), '')
              .trim();
      final heightClean =
          _heightCtrl.text
              .replaceAll(',', '.')
              .replaceAll(RegExp(r'[^0-9\.]'), '')
              .trim();
      await ref
          .read(healthProfileServiceProvider)
          .saveHealthProfile(
            weightKg: double.parse(weightClean),
            heightCm: double.parse(heightClean),
            gender: _selectedGender,
            ckdStage: _selectedStage,
          );

      final user = ref.read(supabaseProvider).auth.currentUser;
      if (user != null) {
        await ref
            .read(supabaseProvider)
            .from('user_health_profiles')
            .update({'avatar_id': _avatarId})
            .eq('user_id', user.id);
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      ref.invalidate(dashboardSummaryProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.saveSuccess),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.saveFailed),
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.resetPasswordLinkSent),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.resetPasswordLinkFailed),
          backgroundColor: AppTheme.errorBase,
        ),
      );
    }
  }

  void _confirmLogout() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.getElevated(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              l10n.confirmLogout,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              l10n.confirmLogoutDesc,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
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
                child: Text(l10n.logout),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteAccount() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.getElevated(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              l10n.confirmDeleteAcc,
              style: const TextStyle(color: AppTheme.errorBase),
            ),
            content: Text(
              l10n.confirmDeleteAccDesc,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
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
                child: Text(l10n.permanentlyDelete),
              ),
            ],
          ),
    );
  }

  void _showAvatarPicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.getElevated(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.selectAvatar,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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
                          color:
                              _avatarId == id
                                  ? AppTheme.brandPrimary
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            _avatarId == id
                                ? AppTheme.brandPrimary.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                        child: Text(
                          'A$id',
                          style: TextStyle(
                            color:
                                _avatarId == id
                                    ? AppTheme.brandPrimary
                                    : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: MeshGradientBackground(
        child:
            _isFetching
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.brandPrimary,
                  ),
                )
                : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppTheme.brandPrimary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                'A$_avatarId',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppTheme.brandPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().scale(
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.healthData,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumTextField(
                        controller: _weightCtrl,
                        label: l10n.weightKg,
                        prefixIcon: Icons.monitor_weight_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.weightValidationEmpty;
                          }
                          final clean =
                              val
                                  .replaceAll(',', '.')
                                  .replaceAll(RegExp(r'[^0-9\.]'), '')
                                  .trim();
                          final n = double.tryParse(clean);
                          if (n == null || n < 20 || n > 300) {
                            return l10n.weightValidationInvalid;
                          }
                          return null;
                        },
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumTextField(
                        controller: _heightCtrl,
                        label: l10n.heightCm,
                        prefixIcon: Icons.height_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.heightValidationEmpty;
                          }
                          final clean =
                              val
                                  .replaceAll(',', '.')
                                  .replaceAll(RegExp(r'[^0-9\.]'), '')
                                  .trim();
                          final n = double.tryParse(clean);
                          if (n == null || n < 100 || n > 250) {
                            return l10n.heightValidationInvalid;
                          }
                          return null;
                        },
                      ).animate().fade(duration: 600.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumDropdownField<String>(
                        label: l10n.gender,
                        value: _selectedGender,
                        prefixIcon: Icons.person_outline,
                        items: [
                          DropdownMenuItem(
                            value: 'male',
                            child: Text(l10n.male),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(l10n.female),
                          ),
                        ],
                        onChanged:
                            (val) => setState(() => _selectedGender = val!),
                      ).animate().fade(duration: 700.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumDropdownField<String>(
                        label: l10n.ckdStage,
                        value: _selectedStage,
                        prefixIcon: Icons.medical_services_outlined,
                        items: [
                          DropdownMenuItem(
                            value: 'stage_1',
                            child: Text(l10n.stage1),
                          ),
                          DropdownMenuItem(
                            value: 'stage_2',
                            child: Text(l10n.stage2),
                          ),
                          DropdownMenuItem(
                            value: 'stage_3a',
                            child: Text(l10n.stage3a),
                          ),
                          DropdownMenuItem(
                            value: 'stage_3b',
                            child: Text(l10n.stage3b),
                          ),
                          DropdownMenuItem(
                            value: 'stage_4',
                            child: Text(l10n.stage4),
                          ),
                          DropdownMenuItem(
                            value: 'stage_5',
                            child: Text(l10n.stage5),
                          ),
                        ],
                        onChanged:
                            (val) => setState(() => _selectedStage = val!),
                      ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
                      const SizedBox(height: 32),
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
                                  child: Text(
                                    l10n.saveHealthData,
                                    style: const TextStyle(
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
                      const Divider(
                        color: Colors.black12,
                      ).animate().fade(duration: 1000.ms),
                      const SizedBox(height: 16),
                      Text(
                        l10n.notifications,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).animate().fade(duration: 1000.ms),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                l10n.mealReminders,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                l10n.mealRemindersDesc,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                              value: _mealRemindersEnabled,
                              activeColor: AppTheme.brandPrimary,
                              onChanged: (val) async {
                                final messenger = ScaffoldMessenger.of(context);
                                setState(() => _mealRemindersEnabled = val);
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool(
                                  'meal_reminders_enabled',
                                  val,
                                );

                                final notifService = NotificationService();
                                if (val) {
                                  await notifService.scheduleMealReminder(
                                    id: 101,
                                    title: 'ได้เวลาอาหารเช้า 🍳',
                                    body:
                                        'อย่าลืมบันทึกอาหารเช้าของคุณ เพื่อติดตามโภชนาการที่ถูกต้อง',
                                    hour: 8,
                                    minute: 0,
                                  );
                                  await notifService.scheduleMealReminder(
                                    id: 102,
                                    title: 'ได้เวลาอาหารกลางวัน 🍱',
                                    body:
                                        'บันทึกมื้อเที่ยงกันเถอะ ควบคุมโซเดียมและโปรตีนให้อยู่ในเกณฑ์นะ',
                                    hour: 12,
                                    minute: 0,
                                  );
                                  await notifService.scheduleMealReminder(
                                    id: 103,
                                    title: 'ได้เวลาอาหารเย็น 🥗',
                                    body:
                                        'มื้อเย็นมาแล้ว บันทึกข้อมูลเพื่อสรุปโภชนาการประจำวันของคุณ',
                                    hour: 18,
                                    minute: 0,
                                  );
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.mealRemindersOn),
                                    ),
                                  );
                                } else {
                                  await notifService.cancelReminder(101);
                                  await notifService.cancelReminder(102);
                                  await notifService.cancelReminder(103);
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.mealRemindersOff),
                                    ),
                                  );
                                }
                              },
                            ),
                            Divider(
                              color: Colors.black.withValues(alpha: 0.05),
                              height: 1,
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.add_alarm_rounded,
                                color: AppTheme.brandPrimary,
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    l10n.remindersTitle,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFF59E0B,
                                        ).withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: const Text(
                                      'BETA',
                                      style: TextStyle(
                                        color: Color(0xFFD97706),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                l10n.localeName == 'th'
                                    ? 'ตั้งเวลาเตือนความจำเลือกเมนูอาหาร/น้ำดื่มได้เอง'
                                    : 'Schedule time & custom meal/water menus',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                size: 16,
                              ),
                              onTap: () => context.push('/reminders'),
                            ),
                          ],
                        ),
                      ).animate().fade(duration: 1050.ms).slideY(begin: 0.2),
                      const SizedBox(height: 32),
                      const Divider(
                        color: Colors.black12,
                      ).animate().fade(duration: 1100.ms),
                      const SizedBox(height: 16),
                      Text(
                        l10n.language,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).animate().fade(duration: 1000.ms),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                        child: SwitchListTile(
                          title: Text(
                            'English Mode',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            l10n.currentLanguage,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          value: ref.watch(localeProvider).languageCode == 'en',
                          activeColor: AppTheme.brandPrimary,
                          onChanged: (val) {
                            final code = val ? 'en' : 'th';
                            ref
                                .read(localeProvider.notifier)
                                .changeLocale(code);
                          },
                        ),
                      ).animate().fade(duration: 1050.ms).slideY(begin: 0.2),
                      const SizedBox(height: 32),
                      const Divider(
                        color: Colors.black12,
                      ).animate().fade(duration: 1100.ms),
                      const SizedBox(height: 16),
                      Text(
                        l10n.accountSettings,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).animate().fade(duration: 1000.ms),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _changePassword,
                        icon: Icon(
                          Icons.lock_reset,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        label: Text(
                          l10n.changePassword,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 1100.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _confirmLogout,
                        icon: Icon(
                          Icons.logout_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        label: Text(
                          l10n.logout,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.03),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.08),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 1200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _confirmDeleteAccount,
                        icon: const Icon(
                          Icons.delete_forever,
                          color: AppTheme.errorBase,
                        ),
                        label: Text(
                          l10n.deleteAccount,
                          style: const TextStyle(color: AppTheme.errorBase),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.errorBase),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 1300.ms).slideY(begin: 0.2),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
      ),
    );
  }
}
