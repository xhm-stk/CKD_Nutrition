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
  double proteinG = 0.0;
  double potassiumMg = 0.0;
  double sodiumMg = 0.0;
  double sugarG = 0.0;
  double carbG = 0.0;
  double waterMl = 0.0;
  double phosphorusMg = 0.0;

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
  double proteinLimitG = 0.0;
  double potassiumLimitMg = 0.0;
  double sodiumLimitMg = 0.0;
  double sugarLimitG = 0.0;
  double carbLimitG = 0.0;
  double waterLimitMl = 0.0;
  double phosphorusLimitMg = 0.0;

  late String syncedAt;
}
