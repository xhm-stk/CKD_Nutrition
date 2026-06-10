import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../dashboard/dashboard_page.dart'; // import ให้ตรง
import 'login_page.dart'; // ดึงหน้าเข้าสู่ระบบเพื่อใช้ย้อนกลับ
import 'package:provider/provider.dart';

class HealthSetupPage extends StatefulWidget {
  final Isar isar;
  const HealthSetupPage({super.key, required this.isar});
  @override State<HealthSetupPage> createState() => _HealthSetupPageState();
}

class _HealthSetupPageState extends State<HealthSetupPage> {
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStage  = 'stage_3a'; // ตั้งค่าเริ่มต้นเป็นระยะ 3a
  bool _isLoading = false;

  void _saveProfile() async {
    if (_weightCtrl.text.isEmpty || _heightCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกน้ำหนักและส่วนสูงให้ครบถ้วน'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      // เซฟโปรไฟล์ขึ้น Cloud
      await context.read<AuthService>().saveHealthProfile(
        weightKg: double.parse(_weightCtrl.text.trim()),
        heightCm: double.parse(_heightCtrl.text.trim()),
        gender: _selectedGender,
        ckdStage: _selectedStage,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // เซฟเสร็จพาไปหน้า Dashboard เลย
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => DashboardPage(isar: widget.isar)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // แสดงข้อความแจ้งเตือนข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกโปรไฟล์สุขภาพล้มเหลว: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลสุขภาพของคุณ'),
        actions: [
          // เพิ่มปุ่มออกจากระบบ (Sign Out) เพื่อย้อนกลับไปหน้าเข้าสู่ระบบได้ทุกเมื่อ
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'ย้อนกลับ / ออกจากระบบ',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage(isar: widget.isar)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _weightCtrl, decoration: const InputDecoration(labelText: 'น้ำหนัก (kg)'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextField(controller: _heightCtrl, decoration: const InputDecoration(labelText: 'ส่วนสูง (cm)'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'เพศ'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('ชาย')),
              DropdownMenuItem(value: 'female', child: Text('หญิง')),
            ],
            onChanged: (val) => setState(() => _selectedGender = val!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedStage,
            decoration: const InputDecoration(labelText: 'ระยะโรคไต (CKD Stage)'),
            items: const [
              DropdownMenuItem(value: 'stage_1', child: Text('ระยะที่ 1')),
              DropdownMenuItem(value: 'stage_2', child: Text('ระยะที่ 2')),
              DropdownMenuItem(value: 'stage_3a', child: Text('ระยะที่ 3a')),
              DropdownMenuItem(value: 'stage_3b', child: Text('ระยะที่ 3b')),
              DropdownMenuItem(value: 'stage_4', child: Text('ระยะที่ 4')),
              DropdownMenuItem(value: 'stage_5', child: Text('ระยะที่ 5 (ฟอกไต)')),
            ],
            onChanged: (val) => setState(() => _selectedStage = val!),
          ),
          const SizedBox(height: 32),
          _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _saveProfile, child: const Text('บันทึกและเริ่มใช้งาน')),
        ],
      ),
    );
  }
}