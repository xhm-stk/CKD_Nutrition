import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import '../models/isar/food_item.dart'; // แก้ path ให้ตรงกับโฟลเดอร์จริงของคุณ

class IsarSeedService {
  static Future<void> seedFoodData(Isar isar, {bool forceUpdate = false}) async {
    // เช็คก่อนว่าในเครื่องมีข้อมูลอาหารหรือยัง ถ้ามีแล้วไม่ต้องโหลดซ้ำ (ประหยัดเวลาเปิดแอป)
    final count = await isar.foodItems.count();
    if (count > 0 && !forceUpdate) return;

    // อ่านไฟล์ JSON จาก Assets
    final String fJson = await rootBundle.loadString('assets/data/food_master.json');
    final List<dynamic> rawData = jsonDecode(fJson);

    // แปลง JSON แต่ละก้อนให้กลายเป็นออบเจกต์ FoodItem
    final List<FoodItem> foods = rawData.map((j) {
      
      // ฟังก์ชันปราบเซียน: เปลี่ยนช่องว่างหรือเครื่องหมาย '-' ให้ปลอดภัยต่อแอป
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
        
        // ถ้าคอลัมน์โภชนาการเป็นข้อความว่างเปล่า จะถูกตีค่าเป็น 0.0 ทันที
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

    // บันทึกข้อมูลทั้ง 156 รายการลงฐานข้อมูลรวดเดียว
    await isar.writeTxn(() async {
      if (forceUpdate) {
         await isar.foodItems.clear(); // ล้างของเก่าถ้ามีคำสั่งบังคับอัปเดต
      }
      await isar.foodItems.putAll(foods);
    });
  }
}