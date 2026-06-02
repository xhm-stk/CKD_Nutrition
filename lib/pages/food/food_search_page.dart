import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../models/isar/food_item.dart';
import '../../services/food_service.dart';

class FoodSearchPage extends StatefulWidget {
  final Isar isar;
  const FoodSearchPage({super.key, required this.isar});
  @override State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  List<FoodItem> _results = [];
  late final FoodService _foodSvc;

  @override
  void initState() {
    super.initState();
    _foodSvc = FoodService(widget.isar);
    _search(''); // ตอนเปิดมาครั้งแรก โชว์อาหารทั้งหมดเลย
  }

  // เรียกหา Service ให้ค้นหาใน Isar
  void _search(String q) async {
    final foods = await _foodSvc.searchFood(q);
    setState(() => _results = foods);
  }

  // ฟังก์ชันนี้จะถูกเรียกเมื่อกดที่เมนูอาหาร (โชว์หน้าต่างลอยขึ้นมาให้กรอกจำนวน)
  void _showLogDialog(FoodItem food) {
    final ctrl = TextEditingController(text: '1'); // ค่าเริ่มต้น 1 หน่วย
    String type = 'lunch';
    bool isSubmitting = false;
    
    // พยายามดึงตัวเลขน้ำหนักต่อจานออกมา (เช่น "120g" ดึงมาแค่ 120.0)
    double baseWeight = 100.0;
    final match = RegExp(r'(\d+)').firstMatch(food.servingSize);
    if(match != null) baseWeight = double.parse(match.group(0)!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ทำให้เวลาคีย์บอร์ดเด้ง หน้าจอไม่โดนบัง
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom, // ดันหน้าต่างหนีคีย์บอร์ด
              left: 24, right: 24, top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('บันทึก ${food.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(labelText: 'จำนวน', suffixText: 'หน่วย (1 หน่วย = ${food.servingSize})'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'มื้ออาหาร'),
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
                      child: ElevatedButton(
                        onPressed: () async {
                          setModalState(() => isSubmitting = true);
                          // คำนวณน้ำหนักกรัมที่กินจริง = ตัวคูณ * น้ำหนักตั้งต้น 1 จาน
                          double multiplier = double.tryParse(ctrl.text) ?? 1.0;
                          double totalGrams = multiplier * baseWeight;
                          
                          // สั่งบันทึก!
                          final err = await _foodSvc.logMeal(food: food, quantityG: totalGrams, mealType: type);
                          
                          if(!context.mounted) return;
                          Navigator.pop(ctx); // ปิด BottomSheet
                          
                          if (err != null) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                          } else {
                             Navigator.pop(context); // ปิดหน้าค้นหาอาหาร กลับไป Dashboard
                          }
                        },
                        child: const Text('บันทึกมื้อนี้'),
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
          autofocus: true,
          decoration: const InputDecoration(hintText: 'ค้นหาอาหาร... เช่น ข้าวต้ม, ปลา', border: InputBorder.none),
          onChanged: _search,
        ),
      ),
      body: ListView.builder(
        itemCount: _results.length,
        itemBuilder: (ctx, i) {
          final f = _results[i];
          return ListTile(
            title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('โปรตีน: ${f.proteinG}g | โซเดียม: ${f.sodiumMg}mg'),
            trailing: const Icon(Icons.add_circle, color: Colors.green),
            onTap: () => _showLogDialog(f),
          );
        }
      ),
    );
  }

  
}
