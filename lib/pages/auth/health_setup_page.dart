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
      await ref
          .read(healthProfileServiceProvider)
          .saveHealthProfile(
            weightKg: double.parse(weightClean),
            heightCm: double.parse(heightClean),
            gender: _selectedGender,
            ckdStage: _selectedStage,
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
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ).animate().fade(duration: 450.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      PremiumTextField(
                        controller: _weightCtrl,
                        label: AppLocalizations.of(context)!.weightKg,
                        prefixIcon: Icons.monitor_weight_outlined,
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
                        prefixIcon: Icons.height_outlined,
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
                        prefixIcon: Icons.person_outline,
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
                        prefixIcon: Icons.medical_services_outlined,
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
                        onChanged:
                            (val) => setState(() => _selectedStage = val!),
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
