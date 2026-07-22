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
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';
import '../../../widgets/mesh_gradient_background.dart';

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
  final _ageCtrl = TextEditingController();
  final _egfrCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage = 'stage_3a';
  bool _isOnDialysis = false;
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
          final dbName = data['full_name']?.toString() ?? '';
          _nameCtrl.text = dbName.isNotEmpty ? dbName : userName;
          _weightCtrl.text = data['weight_kg']?.toString() ?? '';
          _heightCtrl.text = data['height_cm']?.toString() ?? '';
          _ageCtrl.text = data['age']?.toString() ?? '';
          _egfrCtrl.text = data['egfr']?.toString() ?? '';
          _selectedGender = data['gender'] ?? 'male';
          _selectedStage = data['ckd_stage'] ?? 'stage_3a';
          _isOnDialysis = data['is_on_dialysis'] ?? false;
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

    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isLoading = true);

    try {
      final newName = _nameCtrl.text.trim();
      if (newName.isNotEmpty) {
        try {
          await Supabase.instance.client.auth.updateUser(
            UserAttributes(data: {'name': newName}),
          );
        } catch (e) {
          debugPrint('🚨 Failed to update auth name metadata: $e');
        }
      }

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
            fullName: newName,
            age: ageVal,
            egfr: egfrVal,
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      ref.invalidate(dashboardSummaryProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.saveSuccess),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );

      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      debugPrint('Setup Profile Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.saveFailed),
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
            backgroundColor: AppTheme.getElevated(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              AppLocalizations.of(context)!.confirmLogout,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              AppLocalizations.of(context)!.confirmLogoutDesc,
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
                  AppLocalizations.of(context)!.cancel,
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
                child: Text(AppLocalizations.of(context)!.logout),
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
    _ageCtrl.dispose();
    _egfrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.healthData,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
          ),
          tooltip: 'ย้อนกลับไปหน้าสร้างบัญชี',
          onPressed: _confirmLogout,
        ),
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
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.pleaseEnterHealthData,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF475569),
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                      const SizedBox(height: 32),
                      PremiumTextField(
                        controller: _nameCtrl,
                        label: AppLocalizations.of(context)!.enterName,
                        keyboardType: TextInputType.name,
                      ).animate().fade(duration: 450.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PremiumTextField(
                              controller: _ageCtrl,
                              label: AppLocalizations.of(context)!.ageYears,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                final l10n = AppLocalizations.of(context)!;
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
                              label: AppLocalizations.of(context)!.egfrValue,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return null;
                                }
                                final clean = val.replaceAll(',', '.').trim();
                                final n = double.tryParse(clean);
                                if (n == null || n < 0 || n > 200) {
                                  return AppLocalizations.of(
                                            context,
                                          )!.localeName ==
                                          'th'
                                      ? 'กรอกค่า eGFR (0-200)'
                                      : 'Invalid eGFR (0-200)';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 480.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumTextField(
                        controller: _weightCtrl,
                        label: AppLocalizations.of(context)!.weightKg,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          final l10n = AppLocalizations.of(context)!;
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
                        label: AppLocalizations.of(context)!.heightCm,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          final l10n = AppLocalizations.of(context)!;
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
                        label: AppLocalizations.of(context)!.gender,
                        value: _selectedGender,
                        items: [
                          DropdownMenuItem(
                            value: 'male',
                            child: Text(AppLocalizations.of(context)!.male),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(AppLocalizations.of(context)!.female),
                          ),
                        ],
                        onChanged:
                            (val) => setState(() => _selectedGender = val!),
                      ).animate().fade(duration: 700.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumDropdownField<String>(
                        label: AppLocalizations.of(context)!.ckdStage,
                        value: _selectedStage,
                        items: [
                          DropdownMenuItem(
                            value: 'stage_1',
                            child: Text(AppLocalizations.of(context)!.stage1),
                          ),
                          DropdownMenuItem(
                            value: 'stage_2',
                            child: Text(AppLocalizations.of(context)!.stage2),
                          ),
                          DropdownMenuItem(
                            value: 'stage_3a',
                            child: Text(AppLocalizations.of(context)!.stage3a),
                          ),
                          DropdownMenuItem(
                            value: 'stage_3b',
                            child: Text(AppLocalizations.of(context)!.stage3b),
                          ),
                          DropdownMenuItem(
                            value: 'stage_4',
                            child: Text(AppLocalizations.of(context)!.stage4),
                          ),
                          DropdownMenuItem(
                            value: 'stage_5',
                            child: Text(AppLocalizations.of(context)!.stage5),
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
                      ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
                      if (_selectedStage == 'stage_5') ...[
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.getSurface(context),
                            borderRadius: BorderRadius.circular(30),
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
                                  const Icon(
                                    Icons.local_hospital_rounded,
                                    color: AppTheme.brandPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                  context,
                                                )!.localeName ==
                                                'th'
                                            ? 'ได้รับการฟอกไต/ล้างไตแล้ว'
                                            : 'Undergoing Dialysis',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(
                                                  context,
                                                )!.localeName ==
                                                'th'
                                            ? 'สลับหากได้รับการฟอกไตแล้ว'
                                            : 'Toggle if undergoing dialysis',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isOnDialysis,
                                activeColor: AppTheme.brandPrimary,
                                onChanged: (val) {
                                  setState(() {
                                    _isOnDialysis = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
                      ],
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
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.saveHealthData,
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
                    ],
                  ),
                ),
      ),
    );
  }
}
