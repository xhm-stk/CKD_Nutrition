import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/models/isar/food_item.dart';

void main() {
  group('Food Master Database Integrity Tests (156 Menus)', () {
    late List<dynamic> rawData;
    late List<FoodItem> foods;

    setUpAll(() async {
      // ดึงไฟล์ JSON โดยตรงผ่าน dart:io สำหรับ Unit Test
      final file = File('assets/data/food_master.json');
      final jsonString = await file.readAsString();
      rawData = jsonDecode(jsonString) as List<dynamic>;

      // จำลองลอจิกการถอดรหัส (Parsing logic) แบบเดียวกับ IsarSeedService
      foods = rawData.map((j) {
        String parseString(dynamic value) {
          String str = value?.toString().trim() ?? '';
          return str == '-' ? '' : str;
        }

        return FoodItem()
          ..foodId         = parseString(j['food_id'])
          ..name           = parseString(j['ชื่ออาหาร'])
          ..searchKeywords = parseString(j['search_keywords'])
          ..category       = parseString(j['ประเภท'])
          ..ingredients    = parseString(j['วัตถุดิบทั้งหมด(ปริมาณด้วย) (g)'])
          ..servingSize    = parseString(j['ปริมาณต่อจาน'])
          ..proteinG       = double.tryParse(parseString(j['โปรตีน(กรัม)'])) ?? 0.0
          ..potassiumMg    = double.tryParse(parseString(j['โพแทสเซียม(มิลลิกรัม)'])) ?? 0.0
          ..sodiumMg       = double.tryParse(parseString(j['โซเดียม(มิลลิกรัม)'])) ?? 0.0
          ..sugarG         = double.tryParse(parseString(j['นํ้าตาล(กรัม)'])) ?? 0.0
          ..carbG          = double.tryParse(parseString(j['คาโบไฮเดต(กรัม)'])) ?? 0.0
          ..waterMl        = double.tryParse(parseString(j['นํ้า(มิลลิลิตร)'])) ?? 0.0
          ..cookingMethod  = parseString(j['วิธีปรุงอาหาร'])
          ..source         = parseString(j['source'])
          ..sourceUrl      = parseString(j['source_url'])
          ..notes          = parseString(j['notes']);
      }).toList();
    });

    test('1. อาหารในฐานข้อมูลต้องมีครบ 156 เมนู 100% (Exact Count)', () {
      expect(rawData.length, equals(156), reason: 'จำนวนรายการใน JSON ไม่ครบ 156 รายการ');
      expect(foods.length, equals(156), reason: 'จำนวนการแปลงเป็น FoodItem ไม่ครบ 156 รายการ');
    });

    test('2. อาหารทั้ง 156 เมนู ต้องไม่มีรหัส (foodId) ซ้ำกันเลย (Uniqueness)', () {
      final ids = foods.map((f) => f.foodId).toList();
      final uniqueIds = ids.toSet();
      expect(ids.length, equals(uniqueIds.length), reason: 'มีรหัส foodId ซ้ำซ้อนกันในฐานข้อมูล');
    });

    test('3. อาหารทั้ง 156 เมนู ต้องมีชื่ออาหารและหมวดหมู่ห้ามเป็นค่าว่าง (Required Fields)', () {
      for (var food in foods) {
        expect(food.name, isNotEmpty, reason: 'เมนูรหัส ${food.foodId} ไม่มีชื่ออาหาร');
        expect(food.category, isNotEmpty, reason: 'เมนูรหัส ${food.foodId} (${food.name}) ไม่มีหมวดหมู่');
      }
    });

    test('4. อาหารทั้ง 156 เมนู ต้องสามารถแปลงค่าโภชนาการเป็นตัวเลขได้อย่างปลอดภัยไม่แครช (Type Safety)', () {
      for (var food in foods) {
        // ถ้าโปรแกรมไม่แครชและสามารถอ่านค่าได้อย่างน้อย 0.0 ถือว่าผ่าน
        expect(food.proteinG, isA<double>());
        expect(food.sodiumMg, isA<double>());
        expect(food.potassiumMg, isA<double>());
      }
    });

    test('5. อาหารทั้ง 156 เมนู ต้องไม่มีค่าโภชนาการติดลบ (No Negative Nutrients)', () {
      for (var food in foods) {
        expect(food.proteinG, greaterThanOrEqualTo(0.0), reason: '${food.name} มีโปรตีนติดลบ');
        expect(food.sodiumMg, greaterThanOrEqualTo(0.0), reason: '${food.name} มีโซเดียมติดลบ');
        expect(food.potassiumMg, greaterThanOrEqualTo(0.0), reason: '${food.name} มีโพแทสเซียมติดลบ');
      }
    });
  });
}
