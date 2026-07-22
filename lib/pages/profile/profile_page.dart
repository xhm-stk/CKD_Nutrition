import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/core_providers.dart';
import '../../../repositories/auth_repository.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../widgets/premium_dropdown_field.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/mesh_gradient_background.dart';
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
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _egfrCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage = 'stage_3a';
  bool _isOnDialysis = false;
  int _avatarId = 1;
  String? _customAvatarPath;
  bool _isLoading = false;
  bool _isFetching = true;
  bool _isEditingEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAvatarPath = prefs.getString('user_custom_avatar_path');
      if (savedAvatarPath != null && File(savedAvatarPath).existsSync()) {
        _customAvatarPath = savedAvatarPath;
      }

      final data =
          await ref.read(healthProfileServiceProvider).getHealthProfile();
      if (data != null && mounted) {
        setState(() {
          _weightCtrl.text = data['weight_kg']?.toString() ?? '';
          _heightCtrl.text = data['height_cm']?.toString() ?? '';
          _nameCtrl.text = data['full_name']?.toString() ?? '';
          _ageCtrl.text = data['age']?.toString() ?? '';
          _egfrCtrl.text = data['egfr']?.toString() ?? '';
          _selectedGender = data['gender'] ?? 'male';
          _selectedStage = data['ckd_stage'] ?? 'stage_3a';
          _isOnDialysis = data['is_on_dialysis'] ?? false;
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

      final ageClean = _ageCtrl.text.trim();
      final egfrClean = _egfrCtrl.text.replaceAll(',', '.').trim();
      final ageVal = ageClean.isNotEmpty ? int.tryParse(ageClean) : null;
      final egfrVal = egfrClean.isNotEmpty ? double.tryParse(egfrClean) : null;

      await ref
          .read(healthProfileServiceProvider)
          .saveHealthProfile(
            weightKg: double.parse(weightClean),
            heightCm: double.parse(heightClean),
            gender: _selectedGender,
            ckdStage: _selectedStage,
            isOnDialysis: _isOnDialysis,
            fullName: _nameCtrl.text.trim(),
            age: ageVal,
            egfr: egfrVal,
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
      setState(() {
        _isLoading = false;
        _isEditingEnabled = false;
      });

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
          content: Text('${AppLocalizations.of(context)!.saveFailed}: $e'),
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
      await supabase.auth.resetPasswordForEmail(
        user!.email!,
        redirectTo: 'io.supabase.ckdnutrition://reset-callback/',
      );
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

  Future<void> _pickAvatarImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'user_avatar_${DateTime.now().millisecondsSinceEpoch}.png';
        final savedImage = await File(
          pickedFile.path,
        ).copy('${appDir.path}/$fileName');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_custom_avatar_path', savedImage.path);

        if (mounted) {
          setState(() {
            _customAvatarPath = savedImage.path;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking avatar image: $e');
    }
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickAvatarImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            color: AppTheme.brandPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ถ่ายภาพ',
                            style: TextStyle(
                              color: AppTheme.brandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickAvatarImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.photo_library_rounded,
                            color: AppTheme.brandPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'คลังภาพ',
                            style: TextStyle(
                              color: AppTheme.brandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(6, (index) {
                  final id = index + 1;
                  return GestureDetector(
                    onTap: () async {
                      final nav = Navigator.of(context);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('user_custom_avatar_path');
                      if (mounted) {
                        setState(() {
                          _customAvatarPath = null;
                          _avatarId = id;
                        });
                      }
                      nav.pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              (_customAvatarPath == null && _avatarId == id)
                                  ? AppTheme.brandPrimary
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            (_customAvatarPath == null && _avatarId == id)
                                ? AppTheme.brandPrimary.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                        child: Text(
                          'A$id',
                          style: TextStyle(
                            color:
                                (_customAvatarPath == null && _avatarId == id)
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
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _egfrCtrl.dispose();
    super.dispose();
  }

  Widget _buildLanguageOption(String label, bool isActive, String code) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          ref.read(localeProvider.notifier).changeLocale(code);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.brandPrimary : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
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
                              backgroundImage:
                                  (_customAvatarPath != null &&
                                          File(_customAvatarPath!).existsSync())
                                      ? FileImage(File(_customAvatarPath!))
                                      : null,
                              child:
                                  (_customAvatarPath != null &&
                                          File(_customAvatarPath!).existsSync())
                                      ? null
                                      : Text(
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.healthData,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (!_isEditingEnabled)
                            IconButton(
                              icon: const Icon(
                                Icons.edit_rounded,
                                size: 20,
                                color: AppTheme.brandPrimary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isEditingEnabled = true;
                                });
                              },
                            ),
                        ],
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                      const SizedBox(height: 12),
                      PremiumTextField(
                        controller: _nameCtrl,
                        label: l10n.fullName,
                        isCompact: true,
                        enabled: _isEditingEnabled,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.fullNameValidationEmpty;
                          }
                          return null;
                        },
                      ).animate().fade(duration: 450.ms).slideY(begin: 0.1),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PremiumTextField(
                              controller: _ageCtrl,
                              label: l10n.ageYears,
                              isCompact: true,
                              enabled: _isEditingEnabled,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return l10n.ageValidationEmpty;
                                }
                                final n = int.tryParse(val.trim());
                                if (n == null || n < 1 || n > 120) {
                                  return l10n.ageValidationInvalid;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumTextField(
                              controller: _egfrCtrl,
                              label: l10n.egfrValue,
                              isCompact: true,
                              enabled: _isEditingEnabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return l10n.egfrValidationEmpty;
                                }
                                final clean = val.replaceAll(',', '.').trim();
                                final n = double.tryParse(clean);
                                if (n == null || n < 0 || n > 200) {
                                  return l10n.egfrValidationInvalid;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.1),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PremiumTextField(
                              controller: _weightCtrl,
                              label: l10n.weightKg,
                              isCompact: true,
                              enabled: _isEditingEnabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumTextField(
                              controller: _heightCtrl,
                              label: l10n.heightCm,
                              isCompact: true,
                              enabled: _isEditingEnabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 550.ms).slideY(begin: 0.1),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PremiumDropdownField<String>(
                              label: l10n.gender,
                              value: _selectedGender,
                              isCompact: true,
                              enabled: _isEditingEnabled,
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
                                  (val) =>
                                      setState(() => _selectedGender = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumDropdownField<String>(
                              label: l10n.ckdStage,
                              value: _selectedStage,
                              isCompact: true,
                              enabled: _isEditingEnabled,
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
                              onChanged: (val) {
                                setState(() {
                                  _selectedStage = val!;
                                  if (_selectedStage != 'stage_5') {
                                    _isOnDialysis = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 600.ms).slideY(begin: 0.1),
                      if (_selectedStage == 'stage_5') ...[
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _isEditingEnabled
                                    ? AppTheme.getSurface(context)
                                    : AppTheme.getSurface(
                                      context,
                                    ).withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_hospital_rounded,
                                    color:
                                        _isEditingEnabled
                                            ? AppTheme.brandPrimary
                                            : AppTheme.brandPrimary.withValues(
                                              alpha: 0.5,
                                            ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.localeName == 'th'
                                            ? 'ได้รับการฟอกไต/ล้างไตแล้ว'
                                            : 'Undergoing Dialysis',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        l10n.localeName == 'th'
                                            ? 'สลับหากได้รับการฟอกไตแล้ว'
                                            : 'Toggle if undergoing dialysis',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isOnDialysis,
                                activeColor: AppTheme.brandPrimary,
                                onChanged:
                                    _isEditingEnabled
                                        ? (val) {
                                          setState(() {
                                            _isOnDialysis = val;
                                          });
                                        }
                                        : null,
                              ),
                            ],
                          ),
                        ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
                      ],
                      const SizedBox(height: 20),
                      if (_isEditingEnabled)
                        Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditingEnabled = false;
                                        _loadProfile();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      side: const BorderSide(
                                        color: AppTheme.brandPrimary,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.brandPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child:
                                      _isLoading
                                          ? const Center(
                                            child: CircularProgressIndicator(
                                              color: AppTheme.brandPrimary,
                                            ),
                                          )
                                          : Container(
                                            height: 44,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppTheme.brandPrimary,
                                                  AppTheme.brandAccent,
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.brandPrimary
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: _saveProfile,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                              ),
                                              child: const Text(
                                                'บันทึก',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                ),
                              ],
                            )
                            .animate()
                            .fade(duration: 650.ms)
                            .scale(begin: const Offset(0.95, 0.95)),
                      const SizedBox(height: 24),
                      const Divider(
                        color: Colors.black12,
                      ).animate().fade(duration: 700.ms),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.language,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLanguageOption(
                                  'TH',
                                  ref.watch(localeProvider).languageCode ==
                                      'th',
                                  'th',
                                ),
                                _buildLanguageOption(
                                  'EN',
                                  ref.watch(localeProvider).languageCode ==
                                      'en',
                                  'en',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 750.ms),
                      const SizedBox(height: 24),
                      const Divider(
                        color: Colors.black12,
                      ).animate().fade(duration: 800.ms),
                      const SizedBox(height: 16),
                      Text(
                        l10n.accountSettings,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).animate().fade(duration: 850.ms),
                      const SizedBox(height: 12),
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
                            fontSize: 14,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 900.ms).slideY(begin: 0.1),
                      const SizedBox(height: 12),
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
                            fontSize: 14,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.03),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.08),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 950.ms).slideY(begin: 0.1),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _confirmDeleteAccount,
                        icon: const Icon(
                          Icons.delete_forever,
                          color: AppTheme.errorBase,
                        ),
                        label: Text(
                          l10n.deleteAccount,
                          style: const TextStyle(
                            color: AppTheme.errorBase,
                            fontSize: 14,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppTheme.errorBase),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fade(duration: 1000.ms).slideY(begin: 0.1),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
      ),
    );
  }
}
