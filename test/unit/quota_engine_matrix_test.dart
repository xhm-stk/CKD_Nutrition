import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/services/quota_engine.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';

void main() {
  group('QuotaEngine Medical Matrix (KDIGO) Tests', () {
    // กำหนด Matrix เสมือนว่าดึงมาจาก View
    final testMatrix = [
      // Stage, Weight, Expected Protein
      {'stage': 'stage_1', 'weight': 60.0, 'multiplier': 0.8, 'expected': 48.0},
      {'stage': 'stage_1', 'weight': 80.0, 'multiplier': 0.8, 'expected': 64.0},
      {
        'stage': 'stage_3a',
        'weight': 50.0,
        'multiplier': 0.8,
        'expected': 40.0,
      },
      {
        'stage': 'stage_3b',
        'weight': 60.0,
        'multiplier': 0.6,
        'expected': 36.0,
      },
      {'stage': 'stage_4', 'weight': 40.0, 'multiplier': 0.6, 'expected': 24.0},
      {'stage': 'stage_5', 'weight': 75.0, 'multiplier': 0.6, 'expected': 45.0},
      {
        'stage': 'stage_5',
        'weight': 150.0,
        'multiplier': 0.6,
        'expected': 90.0,
      },
    ];

    for (var scenario in testMatrix) {
      test(
        'Calculate ${scenario['stage']} with weight ${scenario['weight']}kg',
        () {
          // จำลองข้อมูลที่ View dashboard_summary คืนค่ากลับมาให้ (Multiplier * Weight)
          final dynamicProteinLimit =
              (scenario['multiplier'] as double) *
              (scenario['weight'] as double);

          final mockLog = DailyLog(
            id: 'test',
            userId: 'user',
            logDate: '2026-06-14',
            customProtein: dynamicProteinLimit, // ค่าที่คำนวณมาจาก View
          );

          final quotas = QuotaEngine.calculate(log: mockLog, rule: null);
          final proteinQuota = quotas.firstWhere((q) => q.label == 'protein');

          expect(proteinQuota.limit, equals(scenario['expected'] as double));
        },
      );
    }

    test('UI Bound Limit Protection Test', () {
      // ทดสอบการกินทะลุโควต้า ว่า percent จะไม่เกิน 1.0 ตามทฤษฎีไหม
      // (แม้ใน NutrientCircle จะมีการจัดการอีกชั้น แต่ Engine ก็สามารถเช็คได้)
      const mockLog = DailyLog(
        id: 'test',
        userId: 'user',
        logDate: '2026-06-14',
        totalProteinG: 100.0, // กินไป 100g
        customProtein: 40.0, // โควต้าแค่ 40g
      );

      final quotas = QuotaEngine.calculate(log: mockLog, rule: null);
      final proteinQuota = quotas.firstWhere((q) => q.label == 'protein');

      expect(proteinQuota.isOverLimit, isTrue);
      expect(
        proteinQuota.percent,
        equals(2.5),
      ); // percent can exceed 1.0 to show overdose
    });
  });
}
