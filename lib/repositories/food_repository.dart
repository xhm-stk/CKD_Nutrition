import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/isar/food_item.dart';
import '../core/result.dart';

import '../services/offline_sync_worker.dart';

class FoodRepository {
  final Isar _isar;
  final SupabaseClient _sb;
  final OfflineSyncWorker _syncWorker;

  FoodRepository(this._isar, this._sb, this._syncWorker);

  Future<List<FoodItem>> searchFood(String query) async {
    List<FoodItem> localResults = [];
    if (query.isEmpty) {
      localResults = await _isar.foodItems.where().limit(20).findAll();
    } else {
      final isUnicode = query.codeUnits.any((unit) => unit > 127);
      if (isUnicode) {
        final allFoods = await _isar.foodItems.where().findAll();
        final qLower = query.toLowerCase();
        localResults =
            allFoods
                .where((f) {
                  return f.name.toLowerCase().contains(qLower) ||
                      f.searchKeywords.toLowerCase().contains(qLower);
                })
                .take(50)
                .toList();
      } else {
        localResults =
            await _isar.foodItems
                .filter()
                .nameContains(query, caseSensitive: false)
                .or()
                .searchKeywordsContains(query, caseSensitive: false)
                .findAll();
      }
    }

    // Search custom foods from Supabase
    List<FoodItem> customResults = [];
    try {
      final user = _sb.auth.currentUser;
      if (user != null) {
        var queryBuilder = _sb
            .from('custom_foods')
            .select('*')
            .eq('user_id', user.id)
            .isFilter('deleted_at', null);
        if (query.isNotEmpty) {
          queryBuilder = queryBuilder.ilike('name', '%$query%');
        }
        final List<dynamic> customData = await queryBuilder.limit(20);
        customResults =
            customData
                .map(
                  (e) =>
                      FoodItem()
                        ..foodId = e['id']
                        ..name = '⭐ ${e['name']}'
                        ..category = 'custom'
                        ..servingSize = e['serving_size']
                        ..proteinG = (e['protein_g'] as num).toDouble()
                        ..potassiumMg = (e['potassium_mg'] as num).toDouble()
                        ..sodiumMg = (e['sodium_mg'] as num).toDouble()
                        ..sugarG = (e['sugar_g'] as num).toDouble()
                        ..carbG = (e['carb_g'] as num).toDouble()
                        ..waterMl = (e['water_ml'] as num).toDouble(),
                )
                .toList();
      }
    } catch (e) {
      // Ignore network errors for custom foods, just show local
    }

    return [...customResults, ...localResults];
  }

  Future<Result<void>> addCustomFood({
    required String name,
    required String servingSize,
    required double proteinG,
    required double potassiumMg,
    required double sodiumMg,
    required double sugarG,
    required double carbG,
    required double waterMl,
  }) async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return Failure('กรุณาเข้าสู่ระบบก่อนเพิ่มอาหาร');

      await _sb.from('custom_foods').insert({
        'user_id': user.id,
        'name': name,
        'serving_size': servingSize,
        'protein_g': proteinG,
        'potassium_mg': potassiumMg,
        'sodium_mg': sodiumMg,
        'sugar_g': sugarG,
        'carb_g': carbG,
        'water_ml': waterMl,
      });
      return Success(null);
    } catch (e) {
      // 🛜 Offline Fallback
      final payload = {
        'name': name,
        'serving_size': servingSize,
        'protein_g': proteinG,
        'potassium_mg': potassiumMg,
        'sodium_mg': sodiumMg,
        'sugar_g': sugarG,
        'carb_g': carbG,
        'water_ml': waterMl,
      };
      await _syncWorker.enqueueAction('ADD_CUSTOM_FOOD', payload);
      return Success(null);
    }
  }
}
