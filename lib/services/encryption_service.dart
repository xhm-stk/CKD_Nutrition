import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _isarKeyName = 'isar_encryption_key';

  /// ดึงคีย์สำหรับเข้ารหัส Isar หากไม่มีให้สร้างใหม่ (256-bit / 32 bytes)
  static Future<List<int>> getOrCreateIsarKey() async {
    final existingKey = await _storage.read(key: _isarKeyName);
    
    if (existingKey != null) {
      // มีคีย์อยู่แล้ว (เคยสร้างไว้) แปลงกลับเป็น List<int>
      return base64Decode(existingKey).toList();
    }

    // ยังไม่มีคีย์ (ติดตั้งแอปครั้งแรก) สร้างคีย์สุ่ม 32 bytes (256-bit)
    final random = Random.secure();
    final newKey = List<int>.generate(32, (_) => random.nextInt(256));
    
    // บันทึกลง Keystore/Keychain ของ OS ผ่าน flutter_secure_storage
    await _storage.write(key: _isarKeyName, value: base64Encode(newKey));
    
    return newKey;
  }

  /// รีเซ็ตคีย์ (สำหรับตอนลบบัญชีหรือข้อมูลพัง)
  static Future<void> deleteIsarKey() async {
    await _storage.delete(key: _isarKeyName);
  }
}
