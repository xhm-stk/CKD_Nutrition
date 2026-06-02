import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import 'health_setup_page.dart'; // ดึงหน้าตั้งค่าสุขภาพเพื่อไปต่อหลังจากสมัครสำเร็จ

class RegisterPage extends StatefulWidget {
  final Isar isar;
  const RegisterPage({super.key, required this.isar});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // GlobalKey สำหรับใช้เช็คสถานะและตรวจสอบข้อมูลใน Form
  final _formKey = GlobalKey<FormState>();
  
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;

  // ฟังก์ชันสมัครสมาชิก
  void _register() async {
    // 1. ตรวจสอบความถูกต้องของข้อมูลทั้งหมดในฟอร์มก่อน
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 2. เรียกใช้ AuthService เพื่อส่งข้อมูลอีเมลและรหัสผ่านไปยัง Supabase
      final err = await AuthService(widget.isar).register(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (err == null) {
        // เช็คว่าลงทะเบียนแล้ว Supabase ล็อกอินให้เลยหรือไม่ (ขึ้นอยู่กับการตั้งค่า Confirm Email บนบอร์ด Supabase)
        final user = Supabase.instance.client.auth.currentUser;
        
        if (user == null) {
          // กรณีที่ Supabase มีการเปิด Confirm Email ไว้ (ยังไม่ได้กดยืนยันทางเมล)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('สมัครสมาชิกสำเร็จ! กรุณาเปิดกล่องจดหมายของคุณและคลิกลิงก์ยืนยันตัวตนในอีเมลก่อนเริ่มใช้งาน'),
              backgroundColor: Colors.amber,
              duration: Duration(seconds: 8),
            ),
          );
          // ย้อนกลับไปหน้าเข้าสู่ระบบ เพื่อให้มาล็อกอินหลังกดยืนยันตัวตนแล้ว
          Navigator.pop(context);
        } else {
          // กรณีที่ไม่ต้องยืนยันอีเมล หรือยืนยันเสร็จแล้ว -> เข้าสู่หน้าตั้งค่าสุขภาพทันที
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('สมัครสมาชิกสำเร็จแล้ว! กำลังนำคุณไปยังขั้นตอนตั้งค่าสุขภาพ'),
              backgroundColor: Colors.teal,
            ),
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HealthSetupPage(isar: widget.isar),
            ),
          );
        }
      } else {
        // แสดงข้อผิดพลาดหาก Supabase แจ้งเตือนข้อผิดพลาดกลับมา
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการลงทะเบียน: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        // ปรับพื้นหลังเป็น Gradient ไล่เฉดสี Teal (เขียวหัวเป็ด) สื่อถึงความสะอาดและสุขภาพที่ดี
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey, // เชื่อมโยงตัวเช็คข้อมูล
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ส่วนแสดงโลโก้ของแอปพลิเคชัน (รูปใบไม้/สปา สื่อถึงธรรมชาติและโภชนาการที่ดี)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.spa_rounded,
                          size: 72,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'เริ่มดูแลสุขภาพไตของคุณ',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'สร้างแผนโภชนาการสำหรับโรคไตเพื่อดูแลตัวเองในระยะยาว',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.teal.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // การ์ดสีขาวใส่ข้อมูลการกรอก
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // 1. ช่องกรอก Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'อีเมลของคุณ',
                                hintText: 'example@gmail.com',
                                prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.teal.shade600),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'กรุณากรอกอีเมล';
                                // ใช้ Regular Expression เช็คความถูกต้องของ Format อีเมล
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                  return 'กรุณากรอกอีเมลที่ถูกต้อง';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 2. ช่องกรอก รหัสผ่าน
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                hintText: 'อย่างน้อย 6 ตัวอักษร',
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.teal.shade600),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.teal.shade600,
                                  ),
                                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'กรุณากรอกรหัสผ่าน';
                                if (val.length < 6) return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 3. ช่องยืนยันรหัสผ่าน
                            TextFormField(
                              controller: _confirmPassCtrl,
                              obscureText: _obscureConfirmPass,
                              decoration: InputDecoration(
                                labelText: 'ยืนยันรหัสผ่านอีกครั้ง',
                                prefixIcon: Icon(Icons.lock_clock_outlined, color: Colors.teal.shade600),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.teal.shade600,
                                  ),
                                  onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'กรุณากรอกรหัสยืนยัน';
                                if (val != _passCtrl.text) return 'รหัสผ่านไม่ตรงกัน';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // ปุ่มดำเนินการสมัครสมาชิกไล่เฉดสีเขียวสวยงาม
                            _isLoading
                                ? const CircularProgressIndicator()
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.teal.shade700,
                                          Colors.green.shade600,
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'สมัครสมาชิกใหม่',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ปุ่มเปลี่ยนกลับไปหน้าเข้าสู่ระบบ (สำหรับคนที่มีบัญชีแล้ว)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'มีบัญชีผู้ใช้งานอยู่แล้ว? ',
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context), // ปิดหน้านี้เพื่อย้อนกลับไปหน้าเดิม (Login)
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}