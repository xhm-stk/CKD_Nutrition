import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../services/auth_service.dart';
import 'register_page.dart'; // โหลดหน้าจอสมัครสมาชิกเพื่อเปลี่ยนหน้าเมื่อกดลิงก์
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // สำหรับป้องกันการ Brute Force (Rate Limiting ฝั่ง Client)
  int _loginAttempts = 0;
  DateTime? _lockoutUntil;

  // ฟังก์ชันเข้าสู่ระบบ
  void _login() async {
    // ตรวจสอบว่าโดนระงับการล็อกอิน (Lockout) อยู่หรือไม่
    if (_lockoutUntil != null) {
      final now = DateTime.now();
      if (now.isBefore(_lockoutUntil!)) {
        final diffSeconds = _lockoutUntil!.difference(now).inSeconds;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('คุณล็อกอินผิดพลาดเกินกำหนด กรุณารองอีกครั้งในอีก $diffSeconds วินาที'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      } else {
        // เลยเวลาระงับการล็อกอินแล้ว ให้ทำการรีเซ็ตใหม่
        setState(() {
          _lockoutUntil = null;
          _loginAttempts = 0;
        });
      }
    }

    // 1. ตรวจสอบความถูกต้องของการกรอกข้อมูลในช่อง Input
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // 2. เรียกใช้งาน AuthService เพื่อล็อกอินเข้า Supabase
    final err = await context.read<AuthService>().login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    // 3. หากเข้าสู่ระบบไม่สำเร็จ ให้แสดงป้ายสีแดงเตือนความผิดพลาด
    if (err != null) {
      setState(() {
        _loginAttempts++;
        // หากกรอกผิดครบ 5 ครั้ง จะทำการระงับการล็อกอินชั่วคราวเป็นเวลา 1 นาที
        if (_loginAttempts >= 5) {
          _lockoutUntil = DateTime.now().add(const Duration(minutes: 1));
        }
      });

      String errorMsg = err;
      if (_loginAttempts >= 5) {
        errorMsg = 'กรอกรหัสผ่านผิดครบ 5 ครั้ง! โดนระงับการเข้าใช้งานชั่วคราว 1 นาที';
      } else {
        errorMsg = '$err (เหลือสิทธิ์ให้ลองอีก ${5 - _loginAttempts} ครั้ง)';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // ล็อกอินสำเร็จ รีเซ็ตข้อมูลจำนวนครั้งที่ล็อกอินผิดพลาด
      setState(() {
        _loginAttempts = 0;
        _lockoutUntil = null;
      });
    }
  }

  // ฟังก์ชันสำหรับแสดง Dialog ให้ผู้ใช้กรอกอีเมลเพื่อส่งลิงก์รีเซ็ตรหัสผ่าน
  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isDialogLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // ห้ามกดปิดข้างนอกระหว่างที่กำลังโหลดส่งข้อมูล
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.lock_reset_rounded, color: Colors.teal.shade700, size: 28),
                  const SizedBox(width: 8),
                  const Text('รีเซ็ตรหัสผ่าน'),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'กรุณากรอกอีเมลที่ใช้สมัครบัญชีของคุณ ระบบจะส่งลิงก์ตั้งรหัสผ่านใหม่ไปให้ที่กล่องจดหมายของคุณ',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'อีเมลของคุณ',
                        hintText: 'example@gmail.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.teal.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'กรุณากรอกอีเมล';
                        // เช็ครูปแบบของอีเมลเพื่อให้ชัวร์ก่อนส่งไปยัง Supabase
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                          return 'รูปแบบอีเมลไม่ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isDialogLoading ? null : () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
                isDialogLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          
                          setDialogState(() => isDialogLoading = true);
                          
                          // เรียกใช้งานฟังก์ชันรีเซ็ตรหัสผ่านใน AuthService
                          final err = await context.read<AuthService>().resetPassword(
                            emailCtrl.text.trim(),
                          );
                          
                          if (!context.mounted) return;
                          setDialogState(() => isDialogLoading = false);
                          
                          Navigator.pop(context); // ปิด Dialog หลังส่งเสร็จสิ้น
                          
                          if (err != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('ระบบได้ส่งลิงก์ตั้งรหัสผ่านใหม่ไปยังอีเมลของคุณเรียบร้อยแล้ว กรุณาตรวจสอบกล่องจดหมาย'),
                                backgroundColor: Colors.green.shade600,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                        child: const Text('ส่งลิงก์'),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
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
                      l10n.appName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
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
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                  return 'กรุณากรอกอีเมลที่ถูกต้อง';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 2. ช่องกรอก Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: l10n.password,
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
                            const SizedBox(height: 8),

                            // ปุ่มลืมรหัสผ่าน (Forgot Password)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _showForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l10n.forgotPassword,
                                  style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

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
                                      child: Center(
                                        child: Text(l10n.login),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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

                    // ลิงก์ย้ายเปลี่ยนหน้าไปหน้าสมัครสมาชิกใหม่
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
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
                            l10n.register,
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