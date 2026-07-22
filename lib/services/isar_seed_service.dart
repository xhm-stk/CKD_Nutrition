import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import '../models/isar/food_item.dart'; // แก้ path ให้ตรงกับโฟลเดอร์จริงของคุณ

class IsarSeedService {
  static Future<void> seedFoodData(
    Isar isar, {
    bool forceUpdate = false,
  }) async {
    // เช็คก่อนว่าในเครื่องมีข้อมูลอาหารหรือยัง ถ้ามีแล้วไม่ต้องโหลดซ้ำ (ประหยัดเวลาเปิดแอป)
    final countBefore = await isar.foodItems.count();
    debugPrint(
      '📦 [Isar Seeding] จำนวนอาหารใน Isar ก่อนโหลด: $countBefore รายการ (forceUpdate: $forceUpdate)',
    );
    if (countBefore > 0 && !forceUpdate) {
      debugPrint('📦 [Isar Seeding] มีข้อมูลใน Isar แล้ว ข้ามการปั๊มข้อมูล');
      return;
    }

    try {
      debugPrint(
        '📦 [Isar Seeding] เริ่มโหลดไฟล์ assets/data/food_master.json...',
      );
      // อ่านไฟล์ JSON จาก Assets
      final String fJson = await rootBundle.loadString(
        'assets/data/food_master.json',
      );

      // ถอดรหัส JSON
      final List<dynamic> rawData = await compute(
        (String text) => jsonDecode(text) as List<dynamic>,
        fJson,
      );

      final countBefore = await isar.foodItems.count();
      debugPrint(
        '📦 [Isar Seeding] จำนวนอาหารใน Isar: $countBefore รายการ vs JSON: ${rawData.length} รายการ (forceUpdate: $forceUpdate)',
      );

      final bool countMismatch = countBefore != rawData.length;
      if (countBefore > 0 && !forceUpdate && !countMismatch) {
        debugPrint(
          '📦 [Isar Seeding] ข้อมูลใน Isar ตรงกันแล้ว ข้ามการปั๊มข้อมูล',
        );
        return;
      }

      // แปลง JSON แต่ละก้อนให้กลายเป็นออบเจกต์ FoodItem
      final List<FoodItem> foods =
          rawData.map((j) {
            String parseString(dynamic value) {
              String str = value?.toString().trim() ?? '';
              return str == '-' ? '' : str;
            }

            return FoodItem()
              ..foodId = parseString(j['food_id'])
              ..name = parseString(j['ชื่ออาหาร'])
              ..searchKeywords = parseString(j['search_keywords'])
              ..category = parseString(j['ประเภท'])
              ..ingredients = parseString(j['วัตถุดิบทั้งหมด(ปริมาณด้วย) (g)'])
              ..servingSize = parseString(j['ปริมาณต่อจาน'])
              ..proteinG =
                  double.tryParse(parseString(j['โปรตีน(กรัม)'])) ?? 0.0
              ..potassiumMg =
                  double.tryParse(parseString(j['โพแทสเซียม(มิลลิกรัม)'])) ??
                  0.0
              ..sodiumMg =
                  double.tryParse(parseString(j['โซเดียม(มิลลิกรัม)'])) ?? 0.0
              ..sugarG = double.tryParse(parseString(j['นํ้าตาล(กรัม)'])) ?? 0.0
              ..carbG =
                  double.tryParse(parseString(j['คาโบไฮเดต(กรัม)'])) ?? 0.0
              ..waterMl =
                  double.tryParse(parseString(j['นํ้า(มิลลิลิตร)'])) ?? 0.0
              ..cookingMethod = parseString(j['วิธีปรุงอาหาร'])
              ..source = parseString(j['source'])
              ..sourceUrl = parseString(j['source_url'])
              ..notes = parseString(j['notes']);
          }).toList();

      // บันทึกข้อมูลลงฐานข้อมูล
      await isar.writeTxn(() async {
        if (forceUpdate || countMismatch) {
          debugPrint(
            '📦 [Isar Seeding] กำลังล้างตารางอาหารเดิมเพื่อให้ข้อมูลตรงกัน...',
          );
          await isar.foodItems.clear();
        }
        debugPrint(
          '📦 [Isar Seeding] กำลังบันทึกข้อมูลอาหาร ${foods.length} รายการลง Isar...',
        );
        await isar.foodItems.putAll(foods);
      });

      final countAfter = await isar.foodItems.count();
      debugPrint(
        '📦 [Isar Seeding] บันทึกข้อมูลอาหารลง Isar สำเร็จ! ปัจจุบันมี: $countAfter รายการ',
      );
    } catch (e, stack) {
      debugPrint(
        '🚨 [Isar Seeding Error] เกิดข้อผิดพลาดในขั้นตอนปั๊มข้อมูล: $e',
      );
      debugPrint('$stack');
    }
  }
}
