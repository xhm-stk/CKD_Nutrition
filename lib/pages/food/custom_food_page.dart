import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  File? _selectedImage;

  Future<void> _pickFoodImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ไม่สามารถเลือกรูปภาพได้: $e')));
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                children: [
                  const Center(
                    child: Text(
                      'เลือกรูปภาพเมนูอาหาร',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppTheme.brandPrimary,
                    ),
                    title: const Text('ถ่ายภาพด้วยกล้อง (Camera)'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickFoodImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library_rounded,
                      color: AppTheme.brandPrimary,
                    ),
                    title: const Text('เลือกจากคลังภาพ (Gallery)'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickFoodImage(ImageSource.gallery);
                    },
                  ),
                  if (_selectedImage != null)
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      title: const Text('ลบรูปภาพ'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _selectedImage = null);
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _saveImageMapping(String foodName) async {
    if (_selectedImage == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_food_img_$foodName', _selectedImage!.path);
  }

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
        await _saveImageMapping(_nameCtrl.text.trim());
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

    // Save image mapping
    await _saveImageMapping(_nameCtrl.text.trim());

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
                  Center(
                    child: GestureDetector(
                      onTap: _showImagePickerSheet,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child:
                            _selectedImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 40,
                                      color: AppTheme.brandPrimary.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'เพิ่มรูปภาพอาหาร',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PremiumTextField(
                    key: const Key('custom_food_name'),
                    controller: _nameCtrl,
                    label: 'ชื่อเมนูอาหาร',
                    isCompact: true,
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'กรุณากรอกชื่ออาหาร'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  PremiumTextField(
                    key: const Key('custom_food_serving'),
                    controller: _servingCtrl,
                    label: 'ปริมาณ (เช่น 1 จาน, 100g)',
                    isCompact: true,
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'กรุณากรอกปริมาณ'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'คุณค่าทางโภชนาการ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
