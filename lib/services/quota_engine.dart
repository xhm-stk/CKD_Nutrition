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

  double get percent => limit <= 0 ? 0 : consumed / limit;

  double get progressBarPercent => percent.clamp(0, 1);

  bool get isOverLimit => limit > 0 && consumed > limit;
  bool get isNearLimit => limit > 0 && percent >= 0.8 && !isOverLimit;
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
        log?.customPhosphorus ?? rule?.phosphorusLimitMg ?? 1000;

    if (proteinLimit == 0 && potassiumLimit == 0) {
      return []; // ไม่มีข้อมูล rule และ profile
    }

    // ใช้ English key เป็น label เพื่อให้แปลภาษาได้ที่ UI layer
    return [
      NutrientQuota(
        label: 'protein',
        unit: 'g',
        consumed: log?.totalProteinG ?? 0,
        limit: proteinLimit,
      ),
      NutrientQuota(
        label: 'sodium',
        unit: 'mg',
        consumed: log?.totalSodiumMg ?? 0,
        limit: sodiumLimit,
      ),
      NutrientQuota(
        label: 'potassium',
        unit: 'mg',
        consumed: log?.totalPotassiumMg ?? 0,
        limit: potassiumLimit,
      ),
      NutrientQuota(
        label: 'sugar',
        unit: 'g',
        consumed: log?.totalSugarG ?? 0,
        limit: sugarLimit,
      ),
      NutrientQuota(
        label: 'carb',
        unit: 'g',
        consumed: log?.totalCarbG ?? 0,
        limit: carbLimit,
      ),
      NutrientQuota(
        label: 'phosphorus',
        unit: 'mg',
        consumed: log?.totalPhosphorusMg ?? 0,
        limit: phosphorusLimit,
      ),
      NutrientQuota(
        label: 'water',
        unit: 'ml',
        consumed: log?.totalWaterMl ?? 0,
        limit: waterLimit,
      ),
    ];
  }
}
