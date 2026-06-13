// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'CKD Nutrition';

  @override
  String get welcomeTitle => 'ยินดีต้อนรับสู่ CKD Nutrition';

  @override
  String get welcomeSubtitle => 'ติดตามอาหารเพื่อดูแลสุขภาพไตของคุณ';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get register => 'สมัครสมาชิกใหม่';

  @override
  String get email => 'อีเมลของคุณ';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่านอีกครั้ง';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get dontHaveAccount => 'ยังไม่มีบัญชีผู้ใช้งาน? ';

  @override
  String get alreadyHaveAccount => 'มีบัญชีผู้ใช้งานอยู่แล้ว? ';

  @override
  String get orLoginWith => 'หรือล็อกอินด้วย';
}
