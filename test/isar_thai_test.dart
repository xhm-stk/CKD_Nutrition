import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:ckd_nutrition_app/models/isar/food_item.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  test('Isar Thai Search Test with OR', () async {
    await Isar.initializeIsarCore(download: true);
    final isar = await Isar.open(
      [FoodItemSchema, CkdRuleCacheSchema],
      directory: Directory.systemTemp.path,
    );

    await isar.writeTxn(() async {
      await isar.foodItems.clear();
      await isar.foodItems.put(FoodItem()
        ..foodId = 'T001'
        ..name = 'ข้าวต้มปลา'
        ..searchKeywords = 'ข้าวต้ม,ปลา,ข้าวต้มปลาช่อน'
        ..category = 'test'
        ..ingredients = 'test'
        ..servingSize = 'test'
        ..proteinG = 0
        ..potassiumMg = 0
        ..sodiumMg = 0
        ..sugarG = 0
        ..carbG = 0
        ..waterMl = 0
        ..cookingMethod = 'test'
        ..source = 'test'
      );
    });

    const query = 'ข้าว';
    final isUnicode = query.codeUnits.any((unit) => unit > 127);
    final useCaseSensitive = isUnicode;

    final res1 = await isar.foodItems.filter()
      .nameContains(query, caseSensitive: useCaseSensitive)
      .or()
      .searchKeywordsContains(query, caseSensitive: useCaseSensitive)
      .findAll();
    debugPrint('Found with OR -> ${res1.length}');
    
    await isar.close(deleteFromDisk: true);
  });
}
