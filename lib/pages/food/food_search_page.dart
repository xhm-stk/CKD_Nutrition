import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/isar/food_item.dart';
import '../../providers/meal_providers.dart';
import '../../controllers/food_search_controller.dart';
import '../../core/result.dart';

class FoodSearchPage extends ConsumerStatefulWidget {
  const FoodSearchPage({super.key});
  
  @override 
  ConsumerState<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showLogDialog(FoodItem food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _FoodLogBottomSheet(food: food),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(foodSearchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'ค้นหาอาหาร... เช่น ข้าวต้ม, ปลา', 
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white70),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchCtrl.clear();
                ref.read(foodSearchControllerProvider.notifier).search('');
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: (val) {
            ref.read(foodSearchControllerProvider.notifier).search(val);
          },
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'สร้างอาหารแบบกำหนดเอง',
            onPressed: () {
              context.push('/food-add');
            },
          )
        ],
      ),
      body: searchState.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : searchState.results.isEmpty 
          ? const Center(child: Text('ไม่พบรายการอาหาร', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: searchState.results.length,
              itemBuilder: (ctx, i) {
                final f = searchState.results[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.fastfood, color: Colors.white, size: 20),
                    ),
                    title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'โปรตีน: ${f.proteinG}g | โซเดียม: ${f.sodiumMg}mg',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.teal, size: 30),
                      onPressed: () => _showLogDialog(f),
                    ),
                    onTap: () => _showLogDialog(f),
                  ),
                );
              }
            ),
    );
  }
}

class _FoodLogBottomSheet extends ConsumerStatefulWidget {
  final FoodItem food;
  const _FoodLogBottomSheet({required this.food});

  @override
  ConsumerState<_FoodLogBottomSheet> createState() => _FoodLogBottomSheetState();
}

class _FoodLogBottomSheetState extends ConsumerState<_FoodLogBottomSheet> {
  final _ctrl = TextEditingController(text: '1');
  String _type = 'lunch';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _ctrl.dispose(); // แก้ Memory Leak
    super.dispose();
  }

  void _submit() async {
    double multiplier = double.tryParse(_ctrl.text) ?? 0.0;
    
    // แก้ Data Integrity: Input Validation
    if (multiplier <= 0 || multiplier > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกจำนวนให้ถูกต้อง (1-100)'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    double baseWeight = 100.0;
    final match = RegExp(r'(\d+)').firstMatch(widget.food.servingSize);
    if (match != null) baseWeight = double.parse(match.group(0)!);

    double totalGrams = multiplier * baseWeight;
    
    final result = await ref.read(mealControllerProvider).logMeal(
      food: widget.food, 
      quantityG: totalGrams, 
      mealType: _type
    );
    
    // แก้ Route Popping Vulnerability
    if (!mounted) return;
    Navigator.pop(context); // ปิด BottomSheet อย่างปลอดภัย

    if (result is Success) {
      if (!mounted) return;
      Navigator.pop(context); // กลับไปหน้า Dashboard
    } else if (result is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.userMessage), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Colors.teal),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'บันทึก ${widget.food.name}', 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              labelText: 'จำนวน', 
              suffixText: 'หน่วย (1 หน่วย = ${widget.food.servingSize})',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _type,
            decoration: const InputDecoration(labelText: 'มื้ออาหาร', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'breakfast', child: Text('มื้อเช้า')),
              DropdownMenuItem(value: 'lunch', child: Text('มื้อเที่ยง')),
              DropdownMenuItem(value: 'dinner', child: Text('มื้อเย็น')),
              DropdownMenuItem(value: 'snack', child: Text('ของว่าง')),
            ],
            onChanged: (val) => setState(() => _type = val!),
          ),
          const SizedBox(height: 24),
          _isSubmitting 
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                  child: const Text('บันทึกมื้อนี้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
