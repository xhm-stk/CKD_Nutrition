import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/premium_text_field.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/meal_providers.dart';

class CustomFoodEntrySheet extends ConsumerStatefulWidget {
  const CustomFoodEntrySheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => const CustomFoodEntrySheet(),
    );
  }

  @override
  ConsumerState<CustomFoodEntrySheet> createState() =>
      _CustomFoodEntrySheetState();
}

class _CustomFoodEntrySheetState extends ConsumerState<CustomFoodEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _servingCtrl = TextEditingController(text: '1 จาน (200g)');
  final _proteinCtrl = TextEditingController();
  final _potassiumCtrl = TextEditingController();
  final _sodiumCtrl = TextEditingController();
  final _sugarCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingCtrl.dispose();
    _proteinCtrl.dispose();
    _potassiumCtrl.dispose();
    _sodiumCtrl.dispose();
    _sugarCtrl.dispose();
    _carbCtrl.dispose();
    _waterCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCustomFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final repo = ref.read(foodRepositoryProvider);
    final result = await repo.addCustomFood(
      name: _nameCtrl.text.trim(),
      servingSize: _servingCtrl.text.trim(),
      proteinG: double.parse(_proteinCtrl.text),
      potassiumMg: double.parse(_potassiumCtrl.text),
      sodiumMg: double.parse(_sodiumCtrl.text),
      sugarG: double.parse(_sugarCtrl.text),
      carbG: double.parse(_carbCtrl.text),
      waterMl: double.parse(_waterCtrl.text),
    );

    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('✅ บันทึกเมนูอาหารเข้าสมุดเมนูสำเร็จ!')),
        );
        navigator.pop();
      case Failure(userMessage: final msg):
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('❌ $msg')));
    }
  }

  Future<void> _saveAndEatCustomFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final foodRepo = ref.read(foodRepositoryProvider);
    final result = await foodRepo.addCustomFood(
      name: _nameCtrl.text.trim(),
      servingSize: _servingCtrl.text.trim(),
      proteinG: double.parse(_proteinCtrl.text),
      potassiumMg: double.parse(_potassiumCtrl.text),
      sodiumMg: double.parse(_sodiumCtrl.text),
      sugarG: double.parse(_sugarCtrl.text),
      carbG: double.parse(_carbCtrl.text),
      waterMl: double.parse(_waterCtrl.text),
    );

    if (result is Failure) {
      setState(() => _isLoading = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('❌ ${result.userMessage}')),
      );
      return;
    }

    final mealRepo = ref.read(mealRepositoryProvider);
    await mealRepo.logMealData(
      foodId: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      foodName: _nameCtrl.text.trim(),
      quantityG: 1,
      mealType: 'snack',
      protein: double.parse(_proteinCtrl.text),
      potassium: double.parse(_potassiumCtrl.text),
      sodium: double.parse(_sodiumCtrl.text),
      sugar: double.parse(_sugarCtrl.text),
      carb: double.parse(_carbCtrl.text),
      water: double.parse(_waterCtrl.text),
      eatenAt: DateTime.now(),
    );

    setState(() => _isLoading = false);

    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(todayMealsProvider);

    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('✅ บันทึกเข้าสมุดและกินเรียบร้อย!')),
    );
    navigator.pop();
  }

  Widget _buildNumberField(
    TextEditingController ctrl,
    String label, {
    Key? key,
  }) {
    return PremiumTextField(
      key: key,
      controller: ctrl,
      label: label,
      isCompact: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'กรุณากรอก';
        final num = double.tryParse(value.trim());
        if (num == null || num < 0) return 'ไม่ถูกต้อง';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Stack(
        children: [
          // Background layer with Mesh Gradient
          Positioned.fill(
            child: Stack(
              children: [
                Container(color: Theme.of(context).scaffoldBackgroundColor),
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -60,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandAccent.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Foreground Content
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag handle line
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เพิ่มเมนูอาหารส่วนตัว',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PremiumTextField(
                      controller: _nameCtrl,
                      label: 'ชื่อเมนูอาหาร',
                      isCompact: true,
                      validator:
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? 'กรุณากรอกชื่ออาหาร'
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    PremiumTextField(
                      controller: _servingCtrl,
                      label: 'ปริมาณ (เช่น 1 จาน, 100g)',
                      isCompact: true,
                      validator:
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? 'กรุณากรอกปริมาณ'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'คุณค่าทางโภชนาการ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildNumberField(_proteinCtrl, 'โปรตีน (g)'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberField(_carbCtrl, 'คาร์บ (g)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildNumberField(_sodiumCtrl, 'โซเดียม (mg)'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberField(_sugarCtrl, 'น้ำตาล (g)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            _potassiumCtrl,
                            'โพแทสเซียม (mg)',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberField(_waterCtrl, 'น้ำ (ml)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _saveCustomFood,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                color: AppTheme.brandPrimary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'บันทึกเท่านั้น',
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            onPressed:
                                _isLoading ? null : _saveAndEatCustomFood,
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'บันทึก & กินทันที',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
