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

  Future<void> saveHealthProfile({
    required double weightKg,
    required double heightCm,
    required String gender,
    required String ckdStage,
    bool isOnDialysis = false,
    String? fullName,
    int? age,
    double? egfr,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      throw Exception(
        'ไม่พบข้อมูลผู้ใช้งานที่ล็อกอินอยู่ กรุณาเข้าสู่ระบบใหม่อีกครั้ง',
      );
    }

    final payload = {
      'user_id': user.id,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'gender': gender,
      'ckd_stage': ckdStage,
      'is_on_dialysis': isOnDialysis,
      'full_name': fullName,
      'age': age,
      'egfr': egfr,
    };

    try {
      await _sb
          .from('user_health_profiles')
          .upsert(payload, onConflict: 'user_id');
      
      // Update name in Supabase Auth user metadata so it matches and email templates work
      if (fullName != null && fullName.isNotEmpty) {
        await _sb.auth.updateUser(
          UserAttributes(
            data: {'name': fullName},
          ),
        );
      }
    } catch (e) {
      debugPrint('🚨 Supabase failed, falling back to offline queue: $e');

      final action =
          OfflineAction()
            ..actionType = 'UPSERT_PROFILE'
            ..payloadJson = jsonEncode(payload)
            ..createdAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.offlineActions.put(action);
      });
      rethrow;
    }

    await _ckdSvc.syncToIsar(ckdStage);
  }

  // ดึงข้อมูลโปรไฟล์
  Future<Map<String, dynamic>?> getHealthProfile() async {
    final user = _sb.auth.currentUser;
    if (user == null) return null;
    try {
      final data =
          await _sb
              .from('user_health_profiles')
              .select()
              .eq('user_id', user.id)
              .maybeSingle();
      return data;
    } catch (e) {
      debugPrint('Error getting health profile: $e');
      return null;
    }
  }
}
