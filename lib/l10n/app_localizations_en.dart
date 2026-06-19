// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CKD Nutrition';

  @override
  String get welcomeTitle => 'Welcome to CKD Nutrition';

  @override
  String get welcomeSubtitle =>
      'Track your nutrition to care for your kidney health';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Sign Up';

  @override
  String get email => 'Your Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get orLoginWith => 'Or sign in with';
}
