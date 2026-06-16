import '../models/supabase/daily_log.dart';
import '../models/isar/food_item.dart'; // สำหรับ CkdRuleCache

class NutrientQuota {
  final String label, unit;
  final double consumed, limit;

  const NutrientQuota({
    required this.label,
    required this.unit,
    required this.consumed,
    required this.limit,
  });

  double get remaining => (limit - consumed).clamp(0, double.infinity);

  /// ปลดล็อค percent ให้แสดงค่าเกิน 1.0 ได้ เพื่อเตือนคนไข้ว่ากินเกินลิมิต
  /// เช่น 1.5 = กินไป 150% ของโควต้า
  double get percent => limit <= 0 ? 0 : consumed / limit;

  /// ใช้สำหรับแสดง Progress Bar (clamp ไว้ไม่เกิน 1.0)
  double get progressBarPercent => percent.clamp(0, 1);

  /// แก้บั๊ก: ถ้า limit = 0 หมายถึงไม่มีการกำหนดขีดจำกัด → ไม่ถือว่าเกิน
  bool get isOverLimit => limit > 0 && consumed > limit;
  bool get isNearLimit =>
      limit > 0 && percent >= 0.8 && !isOverLimit; // แจ้งเตือนสีส้มที่ 80%
}

class QuotaEngine {
  static List<NutrientQuota> calculate({
    required DailyLog? log,
    CkdRuleCache? rule,
  }) {
    // ดึงค่า Limit จาก log (custom limit ที่ได้จาก View) หรือ fallback ไปใช้ rule
    final proteinLimit = log?.customProtein ?? rule?.proteinLimitG ?? 0;
    final potassiumLimit = log?.customPotassium ?? rule?.potassiumLimitMg ?? 0;
    final sodiumLimit = log?.customSodium ?? rule?.sodiumLimitMg ?? 0;
    final sugarLimit = log?.customSugar ?? rule?.sugarLimitG ?? 0;
    final carbLimit = log?.customCarb ?? rule?.carbLimitG ?? 0;
    final waterLimit = log?.customWater ?? rule?.waterLimitMl ?? 0;
    final phosphorusLimit =
        log?.customPhosphorus ?? rule?.phosphorusLimitMg ?? 0;

    if (proteinLimit == 0 && potassiumLimit == 0)
      return []; // ไม่มีข้อมูล rule และ profile

    return [
      NutrientQuota(
        label: 'โปรตีน',
        unit: 'g',
        consumed: log?.totalProteinG ?? 0,
        limit: proteinLimit,
      ),
      NutrientQuota(
        label: 'โพแทสเซียม',
        unit: 'mg',
        consumed: log?.totalPotassiumMg ?? 0,
        limit: potassiumLimit,
      ),
      NutrientQuota(
        label: 'ฟอสฟอรัส',
        unit: 'mg',
        consumed: log?.totalPhosphorusMg ?? 0,
        limit: phosphorusLimit,
      ),
      NutrientQuota(
        label: 'โซเดียม',
        unit: 'mg',
        consumed: log?.totalSodiumMg ?? 0,
        limit: sodiumLimit,
      ),
      NutrientQuota(
        label: 'น้ำตาล',
        unit: 'g',
        consumed: log?.totalSugarG ?? 0,
        limit: sugarLimit,
      ),
      NutrientQuota(
        label: 'คาร์บ',
        unit: 'g',
        consumed: log?.totalCarbG ?? 0,
        limit: carbLimit,
      ),
      NutrientQuota(
        label: 'น้ำ',
        unit: 'ml',
        consumed: log?.totalWaterMl ?? 0,
        limit: waterLimit,
      ),
    ];
  }
}
