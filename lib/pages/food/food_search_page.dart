import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../models/isar/food_item.dart';
import '../../providers/core_providers.dart';
import '../../core/result.dart';

class FoodSearchPage extends ConsumerStatefulWidget {
  final Isar isar; // ยังคงส่ง isar เข้ามาได้ เพราะหน้าค้นหาอาจจะต้องใช้ Isar instance โดยตรง หรือจะดึงผ่าน ref ก็ได้
  const FoodSearchPage({super.key, required this.isar});
  @override ConsumerState<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<FoodItem> _results = [];

  @override
  void initState() {
    super.initState();
    _search(''); // โชว์ทั้งหมดตอนแรก
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _search(String q) async {
    debugPrint('🔍 [Food Search Page] คำค้นหาที่ป้อน: "$q"');
    final repo = ref.read(foodRepositoryProvider);
    final foods = await repo.searchFood(q);
    debugPrint('🔍 [Food Search Page] ค้นพบอาหารใน Isar: ${foods.length} รายการ');
    if (mounted) setState(() => _results = foods);
  }

  void _showLogDialog(FoodItem food) {
    final ctrl = TextEditingController(text: '1');
    String type = 'lunch';
    bool isSubmitting = false;
    
    double baseWeight = 100.0;
    final match = RegExp(r'(\d+)').firstMatch(food.servingSize);
    if (match != null) baseWeight = double.parse(match.group(0)!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                        'บันทึก ${food.name}', 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    labelText: 'จำนวน', 
                    suffixText: 'หน่วย (1 หน่วย = ${food.servingSize})',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'มื้ออาหาร', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'breakfast', child: Text('มื้อเช้า')),
                    DropdownMenuItem(value: 'lunch', child: Text('มื้อเที่ยง')),
                    DropdownMenuItem(value: 'dinner', child: Text('มื้อเย็น')),
                    DropdownMenuItem(value: 'snack', child: Text('ของว่าง')),
                  ],
                  onChanged: (val) => setModalState(() => type = val!),
                ),
                const SizedBox(height: 24),
                isSubmitting 
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
                        onPressed: () async {
                          setModalState(() => isSubmitting = true);
                          double multiplier = double.tryParse(ctrl.text) ?? 1.0;
                          double totalGrams = multiplier * baseWeight;
                          
                          final nav = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          
                          final result = await ref.read(mealControllerProvider).logMeal(food: food, quantityG: totalGrams, mealType: type);
                          
                          nav.pop(); // ปิด BottomSheet
                          
                          switch (result) {
                            case Success():
                              nav.pop(); // กลับไปหน้า Dashboard
                            case Failure(:final userMessage):
                              messenger.showSnackBar(SnackBar(content: Text(userMessage), backgroundColor: Colors.red));
                          }
                        },
                        child: const Text('บันทึกมื้อนี้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _search('');
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: _search,
          onSubmitted: _search,
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _results.isEmpty 
        ? const Center(child: Text('ไม่พบรายการอาหาร', style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (ctx, i) {
              final f = _results[i];
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
