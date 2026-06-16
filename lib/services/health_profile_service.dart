import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/isar/offline_action.dart';
import 'ckd_rule_service.dart';

class HealthProfileService {
  final Isar _isar;
  final SupabaseClient _sb;
  late final CkdRuleService _ckdSvc;

  HealthProfileService(this._isar) : _sb = Supabase.instance.client {
    _ckdSvc = CkdRuleService(_isar);
  }

  // บันทึกโปรไฟล์สุขภาพ
  Future<void> saveHealthProfile({
    required double weightKg, required double heightCm,
    required String gender, required String ckdStage,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      throw Exception('ไม่พบข้อมูลผู้ใช้งานที่ล็อกอินอยู่ กรุณาเข้าสู่ระบบใหม่อีกครั้ง');
    }
    
    final payload = {
      'user_id': user.id,
      'weight_kg': weightKg, 
      'height_cm': heightCm,
      'gender': gender, 
      'ckd_stage': ckdStage,
    };

    try {
      await _sb.from('user_health_profiles').upsert(payload, onConflict: 'user_id');
    } catch (e) {
      debugPrint('🚨 Supabase failed, falling back to offline queue: $e');
      
      final action = OfflineAction()
        ..actionType = 'UPSERT_PROFILE'
        ..payloadJson = jsonEncode(payload)
        ..createdAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.offlineActions.put(action);
      });
    }
    
    await _ckdSvc.syncToIsar(ckdStage);
  }
}