class AppDateUtils {
  /// คืนค่าเวลาปัจจุบันตาม Local Timezone ของเครื่องผู้ใช้
  /// (ยกเลิกการบังคับ UTC+7 เพื่อให้แอปทำงานได้ทั่วโลก)
  static DateTime get now => DateTime.now();

  /// คืนค่าวันที่ของวันนี้ในรูปแบบ YYYY-MM-DD
  static String getTodayString() {
    return now.toIso8601String().substring(0, 10);
  }

  /// คืนค่าเวลาปัจจุบันแบบ ISO8601 String
  static String getNowIsoString() {
    return now.toIso8601String();
  }

  /// แปลง DateTime เป็น String แบบ YYYY-MM-DD
  static String formatDate(DateTime date) {
    return date.toIso8601String().substring(0, 10);
  }
}
