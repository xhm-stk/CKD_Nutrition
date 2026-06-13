import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/services/quota_engine.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';
import 'package:ckd_nutrition_app/models/isar/food_item.dart';

void main() {
  group('QuotaEngine Tests', () {
    test('calculate returns empty list if no limits are provided', () {
      final quotas = QuotaEngine.calculate(log: null, rule: null);
      expect(quotas, isEmpty);
    });

    test('calculate uses custom limit from DailyLog over rule', () {
      const log = DailyLog(
        id: '1',
        userId: 'u1',
        logDate: '2026-06-11',
        totalProteinG: 20.0,
        customProtein: 40.0,
      );

      final rule = CkdRuleCache()
        ..proteinLimitG = 50.0
        ..potassiumLimitMg = 2000.0
        ..sodiumLimitMg = 2000.0
        ..sugarLimitG = 24.0
        ..carbLimitG = 150.0
        ..waterLimitMl = 1500.0;

      final quotas = QuotaEngine.calculate(log: log, rule: rule);
      
      expect(quotas, isNotEmpty);
      final proteinQuota = quotas.firstWhere((q) => q.label == 'โปรตีน');
      expect(proteinQuota.limit, 40.0);
      expect(proteinQuota.consumed, 20.0);
      expect(proteinQuota.remaining, 20.0);
      expect(proteinQuota.percent, 0.5);
    });

    test('calculate uses rule limit when DailyLog has no custom limit', () {
      const log = DailyLog(
        id: '1',
        userId: 'u1',
        logDate: '2026-06-11',
        totalPotassiumMg: 1500.0,
      );

      final rule = CkdRuleCache()
        ..proteinLimitG = 50.0
        ..potassiumLimitMg = 2000.0
        ..sodiumLimitMg = 2000.0
        ..sugarLimitG = 24.0
        ..carbLimitG = 150.0
        ..waterLimitMl = 1500.0;

      final quotas = QuotaEngine.calculate(log: log, rule: rule);
      
      final potassiumQuota = quotas.firstWhere((q) => q.label == 'โพแทสเซียม');
      expect(potassiumQuota.limit, 2000.0);
      expect(potassiumQuota.consumed, 1500.0);
      expect(potassiumQuota.percent, 0.75);
      expect(potassiumQuota.isOverLimit, isFalse);
      expect(potassiumQuota.isNearLimit, isFalse);
    });

    test('NutrientQuota edge cases (over limit, near limit)', () {
      const log = DailyLog(
        id: '1',
        userId: 'u1',
        logDate: '2026-06-11',
        totalSodiumMg: 1900.0,
        customSodium: 2000.0,
        customProtein: 50.0, // Prevent empty return
        customPotassium: 2000.0,
      );

      final quotas = QuotaEngine.calculate(log: log, rule: null);
      final sodiumQuota = quotas.firstWhere((q) => q.label == 'โซเดียม');

      expect(sodiumQuota.percent, 1900.0 / 2000.0);
      expect(sodiumQuota.isNearLimit, isTrue);
      expect(sodiumQuota.isOverLimit, isFalse);

      const logOver = DailyLog(
        id: '2',
        userId: 'u1',
        logDate: '2026-06-11',
        totalSodiumMg: 2100.0,
        customSodium: 2000.0,
        customProtein: 50.0,
        customPotassium: 2000.0,
      );

      final quotasOver = QuotaEngine.calculate(log: logOver, rule: null);
      final sodiumQuotaOver = quotasOver.firstWhere((q) => q.label == 'โซเดียม');

      expect(sodiumQuotaOver.isNearLimit, isFalse); // It's over limit, not just near
      expect(sodiumQuotaOver.isOverLimit, isTrue);
      expect(sodiumQuotaOver.remaining, 0.0);
      expect(sodiumQuotaOver.percent, 1.0); // clamped to 1
    });
  });
}
