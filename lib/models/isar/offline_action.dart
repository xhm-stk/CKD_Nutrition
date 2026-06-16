import 'package:isar/isar.dart';

part 'offline_action.g.dart';

@collection
class OfflineAction {
  Id id = Isar.autoIncrement;

  /// ระบุชนิดของการกระทำ (เช่น 'CREATE_MEAL', 'UPDATE_PROFILE', 'DELETE_LOG')
  late String actionType;

  /// ข้อมูล Payload ที่แปลงเป็น JSON String แล้ว
  late String payloadJson;

  /// เวลาที่สร้าง Action นี้ขึ้นมา (ใช้เพื่อรันตามลำดับคิว FIFO)
  late DateTime createdAt;

  /// หากส่งข้อมูลล้มเหลวเกินกี่ครั้ง ให้ระบุตรงนี้
  int retryCount = 0;

  /// สาเหตุ Error ล่าสุด (ถ้ามี)
  String? lastError;
}
