import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../core/result.dart';

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
      phosphorus: 0,
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
    String label, {
    Key? key,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        key: key,
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'กรุณากรอกข้อมูล';
          final num = double.tryParse(value);
          if (num == null || num < 0) return 'ตัวเลขไม่ถูกต้อง';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('➕ เพิ่มเมนูอาหารส่วนตัว')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('custom_food_name'),
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'ชื่อเมนูอาหาร',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'กรุณากรอกชื่ออาหาร'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('custom_food_serving'),
                controller: _servingCtrl,
                decoration: const InputDecoration(
                  labelText: 'ปริมาณ (เช่น 1 จาน, 100g)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'กรุณากรอกปริมาณ'
                            : null,
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'คุณค่าทางโภชนาการ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      _proteinCtrl,
                      'โปรตีน (g)',
                      key: const Key('custom_food_protein'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(
                      _potassiumCtrl,
                      'โพแทสเซียม (mg)',
                      key: const Key('custom_food_potassium'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      _sodiumCtrl,
                      'โซเดียม (mg)',
                      key: const Key('custom_food_sodium'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(
                      _sugarCtrl,
                      'น้ำตาล (g)',
                      key: const Key('custom_food_sugar'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      _carbCtrl,
                      'คาร์โบไฮเดรต (g)',
                      key: const Key('custom_food_carb'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(
                      _waterCtrl,
                      'น้ำ (ml)',
                      key: const Key('custom_food_water'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _isLoading ? null : _saveAndEatCustomFood,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            '🍽️ บันทึกและกินทันที! (ขึ้น Dashboard)',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  key: const Key('btn_save_custom_food'),
                  onPressed: _isLoading ? null : _saveCustomFood,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                            '💾 แค่บันทึกเก็บไว้ในสมุดเมนู',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
