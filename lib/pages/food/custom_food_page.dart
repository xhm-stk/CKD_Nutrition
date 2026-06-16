import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
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
          const SnackBar(content: Text('✅ บันทึกเมนูอาหารส่วนตัวสำเร็จ!')),
        );
        router.pop();
      case Failure(userMessage: final msg):
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('❌ $msg')));
    }
  }

  Widget _buildNumberField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
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
                    child: _buildNumberField(_proteinCtrl, 'โปรตีน (g)'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(_potassiumCtrl, 'โพแทสเซียม (mg)'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(_sodiumCtrl, 'โซเดียม (mg)'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumberField(_sugarCtrl, 'น้ำตาล (g)')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(_carbCtrl, 'คาร์โบไฮเดรต (g)'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumberField(_waterCtrl, 'น้ำ (ml)')),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCustomFood,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            '💾 บันทึกเข้าระบบ',
                            style: TextStyle(fontSize: 18),
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
