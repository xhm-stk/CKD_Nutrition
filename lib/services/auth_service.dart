import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ckd_rule_service.dart';

class AuthService {
  final _sb = Supabase.instance.client;
  final Isar _isar;
  late final CkdRuleService _ckdSvc;

  AuthService(this._isar) { 
    _ckdSvc = CkdRuleService(_isar); 
  }

  // สมัครสมาชิกใหม่
  Future<String?> register(String email, String password) async {
    try {
      await _sb.auth.signUp(email: email, password: password);
      return null; // สำเร็จ
    } on AuthException catch (e) { 
      return e.message; // คืนค่าข้อความ Error จาก Supabase
    } catch (e) {
      // ดักจับข้อผิดพลาดทั่วไป (เช่น เครือข่ายหลุด หรือไม่ได้กำหนดค่าคีย์ Supabase)
      return 'ไม่สามารถสมัครสมาชิกได้: กรุณาตรวจสอบอินเทอร์เน็ตของคุณ ($e)';
    }
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
    
    await _sb.from('user_health_profiles').upsert({
      'user_id': user.id,
      'weight_kg': weightKg, 
      'height_cm': heightCm,
      'gender': gender, 
      'ckd_stage': ckdStage,
    });
    
    // โหลดกฎการแพทย์ลงเครื่องทันทีที่เซฟโปรไฟล์!
    await _ckdSvc.syncToIsar(ckdStage);
  }

  // เข้าสู่ระบบ
  Future<String?> login(String email, String password) async {
    try {
      await _sb.auth.signInWithPassword(email: email, password: password);
      
      // ดึงระยะโรคไตของผู้ใช้ เพื่อโหลดกฎการกินให้ถูกต้อง
      final h = await _sb.from('user_health_profiles').select('ckd_stage').eq('user_id', _sb.auth.currentUser!.id).single();
      await _ckdSvc.syncToIsar(h['ckd_stage']);
      return null; // สำเร็จ
    } on AuthException catch (e) { 
      return e.message; // คืนค่าข้อความ Error จาก Supabase
    } catch (e) {
      // ดักจับข้อผิดพลาดทั่วไป (เช่น เครือข่ายหลุด)
      return 'ไม่สามารถเข้าสู่ระบบได้: กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณ ($e)';
    }
  }
}