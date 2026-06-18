import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/isar/food_item.dart';

class CkdRuleService {
  final _sb = Supabase.instance.client;
  final Isar _isar;

  CkdRuleService(this._isar);

  // ฟังก์ชันดูดข้อมูลจาก Cloud ลง Local
  Future<void> syncToIsar(String stage) async {
    try {
      final data =
          await _sb.from('ckd_rules').select().eq('stage', stage).single();
      final cache =
          CkdRuleCache()
            ..stage = stage
            ..proteinLimitG = (data['protein_limit_g'] ?? 0).toDouble()
            ..potassiumLimitMg = (data['potassium_limit_mg'] ?? 0).toDouble()
            ..sodiumLimitMg = (data['sodium_limit_mg'] ?? 0).toDouble()
            ..sugarLimitG = (data['sugar_limit_g'] ?? 0).toDouble()
            ..carbLimitG = (data['carb_limit_g'] ?? 0).toDouble()
            ..waterLimitMl = (data['water_limit_ml'] ?? 0).toDouble()
            ..phosphorusLimitMg = (data['phosphorus_limit_mg'] ?? 0).toDouble()
            ..syncedAt = DateTime.now().toIso8601String();

      await _isar.writeTxn(() async => await _isar.ckdRuleCaches.put(cache));
    } catch (e) {
      debugPrint('Sync Error (ใช้แคชเดิมแทน): $e');
    }
  }

  // ฟังก์ชันดึงกฎที่เซฟไว้ในเครื่องออกมาใช้
  Future<CkdRuleCache?> getRule(String stage) async {
    return await _isar.ckdRuleCaches.filter().stageEqualTo(stage).findFirst();
  }
}
