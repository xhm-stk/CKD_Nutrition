class DailyLog {
  final String id;
  final String userId;
  final String logDate;

  // ปริมาณรวมสารอาหารที่ได้รับไปแล้ววันนี้
  final double totalProteinG;
  final double totalPotassiumMg;
  final double totalSodiumMg;
  final double totalSugarG;
  final double totalCarbG;
  final double totalWaterMl;

  // ค่าโควต้าเฉพาะบุคคลที่แพทย์กำหนดไว้ (ถ้ามี)
  final double? customProtein;
  final double? customPotassium;
  final double? customSodium;
  final double? customSugar;
  final double? customCarb;
  final double? customWater;

  DailyLog({
    required this.id,
    required this.userId,
    required this.logDate,
    required this.totalProteinG,
    required this.totalPotassiumMg,
    required this.totalSodiumMg,
    required this.totalSugarG,
    required this.totalCarbG,
    required this.totalWaterMl,
    this.customProtein,
    this.customPotassium,
    this.customSodium,
    this.customSugar,
    this.customCarb,
    this.customWater,
  });

  factory DailyLog.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? healthProfile}) {
    return DailyLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      logDate: json['log_date'] as String,
      totalProteinG: (json['total_protein_g'] ?? 0).toDouble(),
      totalPotassiumMg: (json['total_potassium_mg'] ?? 0).toDouble(),
      totalSodiumMg: (json['total_sodium_mg'] ?? 0).toDouble(),
      totalSugarG: (json['total_sugar_g'] ?? 0).toDouble(),
      totalCarbG: (json['total_carb_g'] ?? 0).toDouble(),
      totalWaterMl: (json['total_water_ml'] ?? 0).toDouble(),
      
      // โหลดค่า Custom Limits จาก Profile
      customProtein: healthProfile?['custom_protein_limit_g'] != null 
          ? (healthProfile!['custom_protein_limit_g']).toDouble() 
          : null,
      customPotassium: healthProfile?['custom_potassium_limit_mg'] != null 
          ? (healthProfile!['custom_potassium_limit_mg']).toDouble() 
          : null,
      customSodium: healthProfile?['custom_sodium_limit_mg'] != null 
          ? (healthProfile!['custom_sodium_limit_mg']).toDouble() 
          : null,
      customSugar: healthProfile?['custom_sugar_limit_g'] != null 
          ? (healthProfile!['custom_sugar_limit_g']).toDouble() 
          : null,
      customCarb: healthProfile?['custom_carb_limit_g'] != null 
          ? (healthProfile!['custom_carb_limit_g']).toDouble() 
          : null,
      customWater: healthProfile?['custom_water_limit_ml'] != null 
          ? (healthProfile!['custom_water_limit_ml']).toDouble() 
          : null,
    );
  }
}