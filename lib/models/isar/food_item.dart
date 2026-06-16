import 'package:isar/isar.dart';
part 'food_item.g.dart';

@collection
class FoodItem {
  Id id =
      Isar.autoIncrement; // Isar บังคับให้ใช้ตัวเลขเป็น Primary Key ภายในเครื่อง

  @Index(unique: true)
  late String foodId; // เก็บ F001, F002 (ใช้เป็นตัวเชื่อมกับ Cloud)

  @Index(type: IndexType.value)
  late String name;

  // รองรับ 16 คอลัมน์จาก Master Data ใหม่
  late String searchKeywords;
  late String category;
  late String ingredients;
  late String servingSize;

  // สารอาหาร 7 ชนิด (รวมฟอสฟอรัส)
  late double proteinG;
  late double potassiumMg;
  late double sodiumMg;
  late double sugarG;
  late double carbG;
  late double waterMl;
  late double phosphorusMg;

  late String cookingMethod;
  late String source;
  String? sourceUrl;
  String? notes;
}

@collection
class CkdRuleCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String stage;
  late double proteinLimitG, potassiumLimitMg;
  late double sodiumLimitMg, sugarLimitG;
  late double carbLimitG, waterLimitMl;
  late double phosphorusLimitMg;

  late String syncedAt;
}
