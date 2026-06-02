import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/food_service.dart';
import '../../services/ckd_rule_service.dart';
import '../../services/quota_engine.dart';
import '../../widgets/quota_bar.dart';
import '../../widgets/warning_banner.dart';
import '../food/food_search_page.dart';
import '../auth/health_setup_page.dart'; // ดึงหน้ากรอกสุขภาพเพื่อย้ายไปกรอกกรณีข้อมูลว่าง
import '../auth/login_page.dart'; // ดึงหน้าเข้าสู่ระบบเพื่อใช้ย้อนกลับ

class DashboardPage extends StatefulWidget {
  final Isar isar;
  const DashboardPage({super.key, required this.isar});
  @override State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<NutrientQuota> _quotas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    
    final sb = Supabase.instance.client;
    final user = sb.auth.currentUser;
    if (user == null) return;

    try {
      // 1. ดึงข้อมูลสเตจโรคไตของคนไข้คนนี้
      final data = await sb
          .from('user_health_profiles')
          .select('ckd_stage')
          .eq('user_id', user.id)
          .maybeSingle(); // ใช้ maybeSingle เพื่อป้องกันเออเรอร์หากหาข้อมูลไม่เจอ
      
      if (data == null) {
        // หากไม่มีข้อมูลประวัติสุขภาพของผู้ใช้คนนี้เลย -> พากลับไปหน้ากรอกข้อมูลสุขภาพเพื่อป้องกันแอปค้าง
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่พบข้อมูลสุขภาพของคุณ กรุณากรอกประวัติสุขภาพเริ่มต้นก่อนใช้งาน'),
            backgroundColor: Colors.amber,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HealthSetupPage(isar: widget.isar)),
        );
        return;
      }
      
      final ckdStage = data['ckd_stage'] as String;

      // 2. ดึงกฎข้อบังคับการกินโรคไตของ Stage นั้นจากฐานข้อมูลจำลองในเครื่อง (Isar)
      final rule = await CkdRuleService(widget.isar).getRule(ckdStage);
      
      // 3. ไปดึง "ยอดรวมที่กินไปแล้ววันนี้" จากคลาวด์
      final log = await FoodService(widget.isar).getTodayLog();

      if (mounted) {
        setState(() {
          // 4. คำนวณสารอาหารและแจ้งผลลัพธ์ผ่านตัวแปลง
          _quotas = QuotaEngine.calculate(log: log, rule: rule);
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      
      // แจ้งเตือนความผิดพลาดหากเชื่อมอินเทอร์เน็ตล้มเหลว
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถโหลดข้อมูลโภชนาการได้: กรุณาตรวจสอบอินเทอร์เน็ต ($e)'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โภชนาการวันนี้'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          // เพิ่มปุ่มออกจากระบบเพื่อสลับบัญชีทดสอบในหน้าหลัก
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'ออกจากระบบ',
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
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              children: [
                // โชว์ป้ายเตือน (หากปริมาณสารอาหารใดเกินเกณฑ์)
                WarningBanner(quotas: _quotas),
                // แสดงหลอดแสดงสารอาหารทีละหลอดอย่างสวยงาม
                ..._quotas.map((q) => QuotaBar(quota: q)),
                const SizedBox(height: 80),
              ],
            ),
          ),
      // ปุ่มลอยเพื่อไปยังหน้าจอบันทึกมื้ออาหาร
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('บันทึกมื้ออาหาร'),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => FoodSearchPage(isar: widget.isar)));
          _loadData();
        },
      ),
    );
  }
}