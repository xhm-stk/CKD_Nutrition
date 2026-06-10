import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import 'health_setup_page.dart'; // ดึงหน้าตั้งค่าสุขภาพเพื่อไปต่อหลังจากสมัครสำเร็จ
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _acceptPrivacyPolicy = false;

  // ฟังก์ชันสำหรับเปิด Dialog แสดงนโยบายความเป็นส่วนตัว
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Colors.teal.shade700, size: 28),
              const SizedBox(width: 8),
              const Text('นโยบายความเป็นส่วนตัว'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อตกลงและนโยบายความเป็นส่วนตัว (Privacy Policy)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  '1. การรวบรวมข้อมูลสุขภาพ\n'
                  'แอปพลิเคชัน CKD Nutrition จำเป็นต้องรวบรวมข้อมูลสุขภาพส่วนบุคคลของคุณ เช่น น้ำหนัก ส่วนสูง เพศ และระยะโรคไต (CKD Stage) เพื่อใช้ในการคำนวณโควต้าโปรตีน โซเดียม โพแทสเซียม และปริมาณน้ำที่เหมาะสมสำหรับสุขภาพไตของคุณ\n\n'
                  '2. การรักษาความปลอดภัยของข้อมูล\n'
                  'ข้อมูลทั้งหมดของคุณจะถูกจัดเก็บอย่างปลอดภัยบนระบบฐานข้อมูล Supabase ภายใต้เกราะป้องกัน Row Level Security (RLS) ซึ่งจะจำกัดสิทธิ์ให้เข้าถึงได้เฉพาะเจ้าของบัญชีเท่านั้น\n\n'
                  '3. การแบ่งปันข้อมูล\n'
                  'เราไม่มีนโยบายการเปิดเผยข้อมูลส่วนบุคคลหรือข้อมูลสุขภาพของคุณให้กับบริษัทภายนอกเพื่อประโยชน์ทางการค้าใดๆ ทั้งสิ้น ข้อมูลทั้งหมดจะใช้เพื่อวัตถุประสงค์ในการคำนวณอาหารภายในแอปพลิเคชันนี้เท่านั้น',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('รับทราบ'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสมัครสมาชิก
  void _register() async {
    // ตรวจสอบว่าผู้ใช้กดยอมรับนโยบายความเป็นส่วนตัวหรือยัง
    if (!_acceptPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากดยอมรับนโยบายความเป็นส่วนตัวก่อนสมัครสมาชิก'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    // 1. ตรวจสอบความถูกต้องของข้อมูลทั้งหมดในฟอร์มก่อน
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 2. เรียกใช้ AuthService เพื่อส่งข้อมูลอีเมลและรหัสผ่านไปยัง Supabase
      final err = await context.read<AuthService>().register(
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
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
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
                      l10n.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.welcomeSubtitle,
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
                                labelText: l10n.email,
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
                                labelText: l10n.password,
                                hintText: 'อย่างน้อย 8 ตัวอักษร (A-Z, a-z, 0-9, อักขระพิเศษ)',
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
                                if (val.length < 8) return 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร';
                                if (!RegExp(r'[A-Z]').hasMatch(val)) return 'ต้องมีตัวพิมพ์ใหญ่ (A-Z) อย่างน้อย 1 ตัว';
                                if (!RegExp(r'[a-z]').hasMatch(val)) return 'ต้องมีตัวพิมพ์เล็ก (a-z) อย่างน้อย 1 ตัว';
                                if (!RegExp(r'[0-9]').hasMatch(val)) return 'ต้องมีตัวเลข (0-9) อย่างน้อย 1 ตัว';
                                if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(val)) {
                                  return 'ต้องมีอักขระพิเศษ (เช่น !@#\$%^&*) อย่างน้อย 1 ตัว';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 3. ช่องยืนยันรหัสผ่าน
                            TextFormField(
                              controller: _confirmPassCtrl,
                              obscureText: _obscureConfirmPass,
                              decoration: InputDecoration(
                                labelText: l10n.confirmPassword,
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
                            const SizedBox(height: 16),

                            // แถวเช็คบ็อกซ์ยอมรับนโยบายความเป็นส่วนตัว
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: Colors.teal.shade700,
                                  value: _acceptPrivacyPolicy,
                                  onChanged: (val) {
                                    setState(() {
                                      _acceptPrivacyPolicy = val ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _showPrivacyPolicyDialog,
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.teal.shade800,
                                          fontSize: 13,
                                          fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                                        ),
                                        children: [
                                          const TextSpan(text: 'ฉันยอมรับ '),
                                          TextSpan(
                                            text: 'นโยบายความเป็นส่วนตัว และ ข้อตกลงการใช้งาน',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                              color: Colors.teal.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

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
                                      child: Center(
                                        child: Text(l10n.register),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    l10n.orLoginWith,
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final messenger = ScaffoldMessenger.of(context);
                                      final err = await context.read<AuthService>().signInWithGoogle();
                                      if (err != null && mounted) {
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
                                    label: const Text('Google', style: TextStyle(color: Colors.black)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final messenger = ScaffoldMessenger.of(context);
                                      final err = await context.read<AuthService>().signInWithApple();
                                      if (err != null && mounted) {
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.apple, color: Colors.black, size: 20),
                                    label: const Text('Apple', style: TextStyle(color: Colors.black)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                          l10n.alreadyHaveAccount,
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context), // ปิดหน้านี้เพื่อย้อนกลับไปหน้าเดิม (Login)
                          child: Text(
                            l10n.login,
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