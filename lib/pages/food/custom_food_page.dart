import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../core/result.dart';
import '../../widgets/mesh_gradient_background.dart';
import '../../theme/app_theme.dart';
import '../../widgets/premium_text_field.dart';
import '../../widgets/premium_primary_button.dart';

class CustomFoodPage extends ConsumerStatefulWidget {
  const CustomFoodPage({super.key});

  @override
  ConsumerState<CustomFoodPage> createState() => _CustomFoodPageState();
}

class _CustomFoodPageState extends ConsumerState<CustomFoodPage> {
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
    final router = GoRouter.of(context);

    // Call foodRepository to insert custom food
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
        router.pop();
      case Failure(userMessage: final msg):
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('❌ $msg')));
    }
  }

  Future<void> _saveAndEatCustomFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    // 1. บันทึกเข้าสมุดอาหาร
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
        SnackBar(content: Text('❌ ${(result).userMessage}')),
      );
      return;
    }

    // 2. กินทันที! (บันทึกเข้า Dashboard)
    final mealRepo = ref.read(mealRepositoryProvider);
    await mealRepo.logMealData(
      foodId:
          'custom_${DateTime.now().millisecondsSinceEpoch}', // ใช้ ID ชั่วคราวเพื่อออฟไลน์ซิงค์
      foodName: _nameCtrl.text.trim(),
      quantityG: 1, // เมนูทำเองถือเป็น 1 หน่วยบริโภค
      mealType: 'snack', // ใส่เป็นของว่างไปก่อน
      protein: double.parse(_proteinCtrl.text),
      potassium: double.parse(_potassiumCtrl.text),
      sodium: double.parse(_sodiumCtrl.text),
      sugar: double.parse(_sugarCtrl.text),
      carb: double.parse(_carbCtrl.text),
      water: double.parse(_waterCtrl.text),
      eatenAt: DateTime.now(),
    );

    setState(() => _isLoading = false);

    // รีเฟรช Dashboard และรายการมื้ออาหาร
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(todayMealsProvider);

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('✅ บันทึกเข้าสมุดและกินเรียบร้อย! (เช็คที่ Dashboard)'),
      ),
    );
    // ดีดกลับไปหน้าแรก (Dashboard)
    router.go('/dashboard');
  }

  Widget _buildNumberField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    Key? key,
  }) {
    return PremiumTextField(
      key: key,
      controller: ctrl,
      label: label,
      prefixIcon: icon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'กรุณากรอกข้อมูล';
        final num = double.tryParse(value.trim());
        if (num == null || num < 0) return 'ตัวเลขไม่ถูกต้อง';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('เพิ่มเมนูอาหารส่วนตัว'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: MeshGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PremiumTextField(
                    key: const Key('custom_food_name'),
                    controller: _nameCtrl,
                    label: 'ชื่อเมนูอาหาร',
                    prefixIcon: Icons.restaurant_menu_rounded,
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'กรุณากรอกชื่ออาหาร'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  PremiumTextField(
                    key: const Key('custom_food_serving'),
                    controller: _servingCtrl,
                    label: 'ปริมาณ (เช่น 1 จาน, 100g)',
                    prefixIcon: Icons.scale_rounded,
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'กรุณากรอกปริมาณ'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'คุณค่าทางโภชนาการ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          _proteinCtrl,
                          'โปรตีน (g)',
                          Icons.egg_outlined,
                          key: const Key('custom_food_protein'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          _potassiumCtrl,
                          'โพแทสเซียม (mg)',
                          Icons.eco_outlined,
                          key: const Key('custom_food_potassium'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          _sodiumCtrl,
                          'โซเดียม (mg)',
                          Icons.soup_kitchen_outlined,
                          key: const Key('custom_food_sodium'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          _sugarCtrl,
                          'น้ำตาล (g)',
                          Icons.cookie_outlined,
                          key: const Key('custom_food_sugar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          _carbCtrl,
                          'คาร์โบไฮเดรต (g)',
                          Icons.breakfast_dining_outlined,
                          key: const Key('custom_food_carb'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          _waterCtrl,
                          'น้ำ (ml)',
                          Icons.water_drop_outlined,
                          key: const Key('custom_food_water'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  PremiumPrimaryButton(
                    text: 'บันทึกและรับประทานทันที',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _saveAndEatCustomFood,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    key: const Key('btn_save_custom_food'),
                    onPressed: _isLoading ? null : _saveCustomFood,
                    icon: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppTheme.brandPrimary,
                    ),
                    label: const Text(
                      'บันทึกเก็บไว้ในประวัติเมนูส่วนตัว',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: AppTheme.brandPrimary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
