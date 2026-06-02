import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../services/auth_service.dart';
import 'register_page.dart'; // โหลดหน้าจอสมัครสมาชิกเพื่อเปลี่ยนหน้าเมื่อกดลิงก์

class LoginPage extends StatefulWidget {
  final Isar isar;
  const LoginPage({super.key, required this.isar});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey สำหรับใช้เช็คสถานะและตรวจสอบข้อมูลใน Form ของล็อกอิน
  final _formKey = GlobalKey<FormState>();
  
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  
  bool _obscurePass = true;
  bool _isLoading = false;

  // ฟังก์ชันเข้าสู่ระบบ
  void _login() async {
    // 1. ตรวจสอบความถูกต้องของการกรอกข้อมูลในช่อง Input
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // 2. เรียกใช้งาน AuthService เพื่อล็อกอินเข้า Supabase
    final err = await AuthService(widget.isar).login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    // 3. หากเข้าสู่ระบบไม่สำเร็จ ให้แสดงป้ายสีแดงเตือนความผิดพลาด
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
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
        // ปรับแต่งพื้นหลังไล่เฉดสี Teal เหมือนหน้า Register เพื่อให้ความรู้สึกที่โปร่ง สะอาด และใส่ใจสุขภาพ
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
                key: _formKey, // เชื่อมตัวตรวจสอบฟอร์ม
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // โลโก้และหัวข้อการรักษาโภชนาการสำหรับโรคไต (รูปสัญลักษณ์ฟื้นฟู/สุขภาพ)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.healing_outlined, // รูปพลาสเตอร์/การรักษาเชิงสุขภาพ
                          size: 72,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CKD Nutrition',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ยินดีต้อนรับกลับมา! กรุณาเข้าสู่ระบบเพื่อติดตามอาหารและไตของคุณ',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.teal.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // การ์ดกรอกข้อมูลเข้าสู่ระบบสีขาวขอบมนละมุน
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
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 2. ช่องกรอก Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
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
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // ปุ่มเข้าสู่ระบบไล่เฉดสี Teal & Green เหมือนกัน
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
                                      onPressed: _login,
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
                                          'เข้าสู่ระบบ',
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

                    // ลิงก์ย้ายเปลี่ยนหน้าไปหน้าสมัครสมาชิกใหม่
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีบัญชีผู้ใช้งาน? ',
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                        TextButton(
                          onPressed: () {
                            // เปิดหน้าจอสมัครสมาชิกใหม่ โดยการ Push ไปยัง RegisterPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterPage(isar: widget.isar),
                              ),
                            );
                          },
                          child: Text(
                            'สมัครสมาชิกใหม่',
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