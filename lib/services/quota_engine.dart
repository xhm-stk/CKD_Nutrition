import '../models/supabase/daily_log.dart';
import '../models/isar/food_item.dart'; // สำหรับ CkdRuleCache

class NutrientQuota {
  final String label, unit;
  final double consumed, limit;

  const NutrientQuota({
    required this.label, required this.unit,
    required this.consumed, required this.limit
  });

  double get remaining => (limit - consumed).clamp(0, limit);
  double get percent   => limit <= 0 ? 0 : (consumed / limit).clamp(0, 1);
  bool get isOverLimit  => consumed > limit;
  bool get isNearLimit  => percent >= 0.8 && !isOverLimit; // แจ้งเตือนสีส้มที่ 80%
}

class QuotaEngine {
  static List<NutrientQuota> calculate({required DailyLog? log, required CkdRuleCache? rule}) {
    if (rule == null) return [];
    
    // ถ้าหมอกำหนดค่าพิเศษ (custom) ให้คนไข้ ให้ใช้ค่าหมอ ถ้าไม่มี ให้ใช้ค่ามาตรฐาน (rule)
    return [
      NutrientQuota(label: 'โปรตีน', unit: 'g', consumed: log?.totalProteinG ?? 0, limit: log?.customProtein ?? rule.proteinLimitG),
      NutrientQuota(label: 'โพแทสเซียม', unit: 'mg', consumed: log?.totalPotassiumMg ?? 0, limit: log?.customPotassium ?? rule.potassiumLimitMg),
      NutrientQuota(label: 'โซเดียม', unit: 'mg', consumed: log?.totalSodiumMg ?? 0, limit: log?.customSodium ?? rule.sodiumLimitMg),
      NutrientQuota(label: 'น้ำตาล', unit: 'g', consumed: log?.totalSugarG ?? 0, limit: log?.customSugar ?? rule.sugarLimitG),
      NutrientQuota(label: 'คาร์บ', unit: 'g', consumed: log?.totalCarbG ?? 0, limit: log?.customCarb ?? rule.carbLimitG),
      NutrientQuota(label: 'น้ำ', unit: 'ml', consumed: log?.totalWaterMl ?? 0, limit: log?.customWater ?? rule.waterLimitMl),
    ];
  }
}