import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appName.
  ///
  /// In th, this message translates to:
  /// **'CKD Nutrition'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In th, this message translates to:
  /// **'ยินดีต้อนรับสู่ CKD Nutrition'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In th, this message translates to:
  /// **'ติดตามอาหารเพื่อดูแลสุขภาพไตของคุณ'**
  String get welcomeSubtitle;

  /// No description provided for @login.
  ///
  /// In th, this message translates to:
  /// **'เข้าสู่ระบบ'**
  String get login;

  /// No description provided for @register.
  ///
  /// In th, this message translates to:
  /// **'สมัครสมาชิกใหม่'**
  String get register;

  /// No description provided for @email.
  ///
  /// In th, this message translates to:
  /// **'อีเมลของคุณ'**
  String get email;

  /// No description provided for @password.
  ///
  /// In th, this message translates to:
  /// **'รหัสผ่าน'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันรหัสผ่านอีกครั้ง'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In th, this message translates to:
  /// **'ลืมรหัสผ่าน?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีบัญชีผู้ใช้งาน? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In th, this message translates to:
  /// **'มีบัญชีผู้ใช้งานอยู่แล้ว? '**
  String get alreadyHaveAccount;

  /// No description provided for @orLoginWith.
  ///
  /// In th, this message translates to:
  /// **'หรือล็อกอินด้วย'**
  String get orLoginWith;

  /// No description provided for @navDashboard.
  ///
  /// In th, this message translates to:
  /// **'แดชบอร์ด'**
  String get navDashboard;

  /// No description provided for @navHistory.
  ///
  /// In th, this message translates to:
  /// **'ประวัติ'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In th, this message translates to:
  /// **'บัญชี'**
  String get navProfile;

  /// No description provided for @save.
  ///
  /// In th, this message translates to:
  /// **'บันทึก'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิก'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In th, this message translates to:
  /// **'ยืนยัน'**
  String get confirm;

  /// No description provided for @error.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด'**
  String get error;

  /// No description provided for @success.
  ///
  /// In th, this message translates to:
  /// **'สำเร็จ'**
  String get success;

  /// No description provided for @close.
  ///
  /// In th, this message translates to:
  /// **'ปิด'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In th, this message translates to:
  /// **'ลบ'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In th, this message translates to:
  /// **'แก้ไข'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In th, this message translates to:
  /// **'เพิ่ม'**
  String get add;

  /// No description provided for @search.
  ///
  /// In th, this message translates to:
  /// **'ค้นหา'**
  String get search;

  /// No description provided for @warning.
  ///
  /// In th, this message translates to:
  /// **'คำเตือน'**
  String get warning;

  /// No description provided for @profile.
  ///
  /// In th, this message translates to:
  /// **'บัญชีของฉัน'**
  String get profile;

  /// No description provided for @accountSettings.
  ///
  /// In th, this message translates to:
  /// **'การตั้งค่าบัญชี'**
  String get accountSettings;

  /// No description provided for @changePassword.
  ///
  /// In th, this message translates to:
  /// **'เปลี่ยนรหัสผ่าน'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In th, this message translates to:
  /// **'ออกจากระบบ'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In th, this message translates to:
  /// **'ลบบัญชีผู้ใช้'**
  String get deleteAccount;

  /// No description provided for @confirmLogout.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันออกจากระบบ'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutDesc.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการออกจากระบบใช่หรือไม่?'**
  String get confirmLogoutDesc;

  /// No description provided for @confirmDeleteAcc.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันการลบบัญชี'**
  String get confirmDeleteAcc;

  /// No description provided for @confirmDeleteAccDesc.
  ///
  /// In th, this message translates to:
  /// **'ข้อมูลทั้งหมดของคุณจะถูกลบถาวรและไม่สามารถกู้คืนได้ คุณแน่ใจหรือไม่?'**
  String get confirmDeleteAccDesc;

  /// No description provided for @permanentlyDelete.
  ///
  /// In th, this message translates to:
  /// **'ลบถาวร'**
  String get permanentlyDelete;

  /// No description provided for @healthData.
  ///
  /// In th, this message translates to:
  /// **'ข้อมูลสุขภาพ'**
  String get healthData;

  /// No description provided for @weightKg.
  ///
  /// In th, this message translates to:
  /// **'น้ำหนัก (kg)'**
  String get weightKg;

  /// No description provided for @heightCm.
  ///
  /// In th, this message translates to:
  /// **'ส่วนสูง (cm)'**
  String get heightCm;

  /// No description provided for @gender.
  ///
  /// In th, this message translates to:
  /// **'เพศ'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In th, this message translates to:
  /// **'ชาย'**
  String get male;

  /// No description provided for @female.
  ///
  /// In th, this message translates to:
  /// **'หญิง'**
  String get female;

  /// No description provided for @ckdStage.
  ///
  /// In th, this message translates to:
  /// **'ระยะโรคไต (CKD Stage)'**
  String get ckdStage;

  /// No description provided for @stage1.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 1'**
  String get stage1;

  /// No description provided for @stage2.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 2'**
  String get stage2;

  /// No description provided for @stage3a.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 3a'**
  String get stage3a;

  /// No description provided for @stage3b.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 3b'**
  String get stage3b;

  /// No description provided for @stage4.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 4'**
  String get stage4;

  /// No description provided for @stage5.
  ///
  /// In th, this message translates to:
  /// **'ระยะที่ 5 (ฟอกไต)'**
  String get stage5;

  /// No description provided for @saveHealthData.
  ///
  /// In th, this message translates to:
  /// **'บันทึกข้อมูลสุขภาพ'**
  String get saveHealthData;

  /// No description provided for @saveSuccess.
  ///
  /// In th, this message translates to:
  /// **'บันทึกข้อมูลสำเร็จ'**
  String get saveSuccess;

  /// No description provided for @saveFailed.
  ///
  /// In th, this message translates to:
  /// **'บันทึกข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง'**
  String get saveFailed;

  /// No description provided for @fullName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อผู้ป่วย'**
  String get fullName;

  /// No description provided for @ageYears.
  ///
  /// In th, this message translates to:
  /// **'อายุ (ปี)'**
  String get ageYears;

  /// No description provided for @egfrValue.
  ///
  /// In th, this message translates to:
  /// **'ค่า eGFR (mL/min/1.73ม.²)'**
  String get egfrValue;

  /// No description provided for @fullNameValidationEmpty.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกชื่อผู้ป่วย'**
  String get fullNameValidationEmpty;

  /// No description provided for @ageValidationEmpty.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกอายุ'**
  String get ageValidationEmpty;

  /// No description provided for @ageValidationInvalid.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกอายุที่ถูกต้อง (1-120)'**
  String get ageValidationInvalid;

  /// No description provided for @egfrValidationEmpty.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกค่า eGFR'**
  String get egfrValidationEmpty;

  /// No description provided for @egfrValidationInvalid.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกค่า eGFR ที่ถูกต้อง (0-200)'**
  String get egfrValidationInvalid;

  /// No description provided for @pleaseEnterHealthData.
  ///
  /// In th, this message translates to:
  /// **'กรุณาบันทึกข้อมูลสุขภาพ'**
  String get pleaseEnterHealthData;

  /// No description provided for @notifications.
  ///
  /// In th, this message translates to:
  /// **'การแจ้งเตือน'**
  String get notifications;

  /// No description provided for @mealReminders.
  ///
  /// In th, this message translates to:
  /// **'แจ้งเตือนมื้ออาหาร'**
  String get mealReminders;

  /// No description provided for @mealRemindersDesc.
  ///
  /// In th, this message translates to:
  /// **'เช้า (08:00), กลางวัน (12:00), เย็น (18:00)'**
  String get mealRemindersDesc;

  /// No description provided for @mealRemindersOn.
  ///
  /// In th, this message translates to:
  /// **'เปิดแจ้งเตือนมื้ออาหารแล้ว'**
  String get mealRemindersOn;

  /// No description provided for @mealRemindersOff.
  ///
  /// In th, this message translates to:
  /// **'ปิดแจ้งเตือนมื้ออาหารแล้ว'**
  String get mealRemindersOff;

  /// No description provided for @language.
  ///
  /// In th, this message translates to:
  /// **'ภาษา (Language)'**
  String get language;

  /// No description provided for @currentLanguage.
  ///
  /// In th, this message translates to:
  /// **'ปัจจุบัน: ไทย'**
  String get currentLanguage;

  /// No description provided for @selectAvatar.
  ///
  /// In th, this message translates to:
  /// **'เลือกอวตาร์ของคุณ'**
  String get selectAvatar;

  /// No description provided for @resetPasswordLinkSent.
  ///
  /// In th, this message translates to:
  /// **'ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว'**
  String get resetPasswordLinkSent;

  /// No description provided for @resetPasswordLinkFailed.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการส่งลิงก์รีเซ็ตรหัสผ่าน'**
  String get resetPasswordLinkFailed;

  /// No description provided for @todaysMeals.
  ///
  /// In th, this message translates to:
  /// **'รายการมื้ออาหารวันนี้'**
  String get todaysMeals;

  /// No description provided for @summaryToday.
  ///
  /// In th, this message translates to:
  /// **'สรุปวันนี้'**
  String get summaryToday;

  /// No description provided for @addMeal.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มมื้ออาหารของคุณ'**
  String get addMeal;

  /// No description provided for @addMealDesc.
  ///
  /// In th, this message translates to:
  /// **'เลือกวิธีเพิ่มอาหารที่คุณทานในวันนี้'**
  String get addMealDesc;

  /// No description provided for @addAppMenu.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มเมนูจากแอป'**
  String get addAppMenu;

  /// No description provided for @addAppMenuDesc.
  ///
  /// In th, this message translates to:
  /// **'เลือกจากรายการอาหารสุขภาพในแอป'**
  String get addAppMenuDesc;

  /// No description provided for @addCustomMenu.
  ///
  /// In th, this message translates to:
  /// **'กำหนดเมนูอาหารทำเอง'**
  String get addCustomMenu;

  /// No description provided for @logWater.
  ///
  /// In th, this message translates to:
  /// **'บันทึกดื่มน้ำ'**
  String get logWater;

  /// No description provided for @logWaterDesc.
  ///
  /// In th, this message translates to:
  /// **'บันทึกปริมาณน้ำที่ดื่ม'**
  String get logWaterDesc;

  /// No description provided for @water.
  ///
  /// In th, this message translates to:
  /// **'น้ำเปล่า'**
  String get water;

  /// No description provided for @waterLoggedSuccess.
  ///
  /// In th, this message translates to:
  /// **'บันทึกดื่มน้ำเรียบร้อยแล้ว'**
  String get waterLoggedSuccess;

  /// No description provided for @allNutrients.
  ///
  /// In th, this message translates to:
  /// **'สารอาหารทั้งหมด'**
  String get allNutrients;

  /// No description provided for @goodStreak.
  ///
  /// In th, this message translates to:
  /// **'คุณคุมอาหารได้ดีติดต่อกัน'**
  String get goodStreak;

  /// No description provided for @days.
  ///
  /// In th, this message translates to:
  /// **'วัน'**
  String get days;

  /// No description provided for @onlyLogCurrentDay.
  ///
  /// In th, this message translates to:
  /// **'คุณสามารถบันทึกอาหารได้เฉพาะวันที่ปัจจุบันเท่านั้น'**
  String get onlyLogCurrentDay;

  /// No description provided for @waterVolumeMl.
  ///
  /// In th, this message translates to:
  /// **'ปริมาณ (ml)'**
  String get waterVolumeMl;

  /// No description provided for @protein.
  ///
  /// In th, this message translates to:
  /// **'โปรตีน'**
  String get protein;

  /// No description provided for @sodium.
  ///
  /// In th, this message translates to:
  /// **'โซเดียม'**
  String get sodium;

  /// No description provided for @potassium.
  ///
  /// In th, this message translates to:
  /// **'โพแทสเซียม'**
  String get potassium;

  /// No description provided for @sugar.
  ///
  /// In th, this message translates to:
  /// **'น้ำตาล'**
  String get sugar;

  /// No description provided for @carbs.
  ///
  /// In th, this message translates to:
  /// **'คาร์บ'**
  String get carbs;

  /// No description provided for @searchFoodHint.
  ///
  /// In th, this message translates to:
  /// **'ค้นหาอาหาร... เช่น ข้าวต้ม, ปลา'**
  String get searchFoodHint;

  /// No description provided for @createCustomFood.
  ///
  /// In th, this message translates to:
  /// **'สร้างอาหารแบบกำหนดเอง'**
  String get createCustomFood;

  /// No description provided for @noFoodFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบรายการอาหาร'**
  String get noFoodFound;

  /// No description provided for @saveFood.
  ///
  /// In th, this message translates to:
  /// **'บันทึกเมนูนี้'**
  String get saveFood;

  /// No description provided for @meal.
  ///
  /// In th, this message translates to:
  /// **'มื้ออาหาร'**
  String get meal;

  /// No description provided for @breakfast.
  ///
  /// In th, this message translates to:
  /// **'มื้อเช้า'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In th, this message translates to:
  /// **'มื้อเที่ยง'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In th, this message translates to:
  /// **'มื้อเย็น'**
  String get dinner;

  /// No description provided for @saveThisMeal.
  ///
  /// In th, this message translates to:
  /// **'บันทึกมื้อนี้'**
  String get saveThisMeal;

  /// No description provided for @invalidQuantity.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกจำนวนให้ถูกต้อง (1-100)'**
  String get invalidQuantity;

  /// No description provided for @foodName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อเมนูอาหาร'**
  String get foodName;

  /// No description provided for @proteinG.
  ///
  /// In th, this message translates to:
  /// **'โปรตีน (g)'**
  String get proteinG;

  /// No description provided for @sodiumMg.
  ///
  /// In th, this message translates to:
  /// **'โซเดียม (mg)'**
  String get sodiumMg;

  /// No description provided for @potassiumMg.
  ///
  /// In th, this message translates to:
  /// **'โพแทสเซียม (mg)'**
  String get potassiumMg;

  /// No description provided for @sugarG.
  ///
  /// In th, this message translates to:
  /// **'น้ำตาล (g)'**
  String get sugarG;

  /// No description provided for @carbsG.
  ///
  /// In th, this message translates to:
  /// **'คาร์โบไฮเดรต (g)'**
  String get carbsG;

  /// No description provided for @waterMl.
  ///
  /// In th, this message translates to:
  /// **'น้ำ (ml)'**
  String get waterMl;

  /// No description provided for @eatingHistory.
  ///
  /// In th, this message translates to:
  /// **'ประวัติการกินอาหาร'**
  String get eatingHistory;

  /// No description provided for @tapDateToView.
  ///
  /// In th, this message translates to:
  /// **'แตะวันที่บนปฏิทินเพื่อดูประวัติ'**
  String get tapDateToView;

  /// No description provided for @monthlySummary.
  ///
  /// In th, this message translates to:
  /// **'สรุปรายเดือน'**
  String get monthlySummary;

  /// No description provided for @proteinIntakeGraph.
  ///
  /// In th, this message translates to:
  /// **'กราฟปริมาณโปรตีนที่รับประทาน (g)'**
  String get proteinIntakeGraph;

  /// No description provided for @avgProtein.
  ///
  /// In th, this message translates to:
  /// **'โปรตีนเฉลี่ย'**
  String get avgProtein;

  /// No description provided for @avgSodium.
  ///
  /// In th, this message translates to:
  /// **'โซเดียมเฉลี่ย'**
  String get avgSodium;

  /// No description provided for @avgPotassium.
  ///
  /// In th, this message translates to:
  /// **'โพแทสเซียมเฉลี่ย'**
  String get avgPotassium;

  /// No description provided for @noHistoryThisMonth.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีประวัติการกินอาหารในเดือนนี้'**
  String get noHistoryThisMonth;

  /// No description provided for @noHistoryThisDay.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีประวัติในวันที่เลือก'**
  String get noHistoryThisDay;

  /// No description provided for @onboardingTitle1.
  ///
  /// In th, this message translates to:
  /// **'จัดการโภชนาการ'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In th, this message translates to:
  /// **'ติดตามสารอาหารสำคัญทุกชนิด ทั้ง โปรตีน โซเดียม และโพแทสเซียม ได้แบบเรียลไทม์'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In th, this message translates to:
  /// **'ใช้งานได้แม้ไม่มีเน็ต'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In th, this message translates to:
  /// **'บันทึกอาหารได้ทุกที่ทุกเวลา ข้อมูลจะถูกซิงค์ขึ้น Cloud อัตโนมัติเมื่ออินเทอร์เน็ตกลับมา'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In th, this message translates to:
  /// **'ปลอดภัยสูงสุด'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In th, this message translates to:
  /// **'ข้อมูลสุขภาพของคุณถูกเข้ารหัสและป้องกันด้วยระบบสแกนนิ้ว / ใบหน้า'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In th, this message translates to:
  /// **'เริ่มต้นใช้งาน!'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In th, this message translates to:
  /// **'กรอกข้อมูลสุขภาพเบื้องต้นของคุณ แล้วเริ่มควบคุมอาหารอย่างมืออาชีพ'**
  String get onboardingDesc4;

  /// No description provided for @skip.
  ///
  /// In th, this message translates to:
  /// **'ข้าม'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In th, this message translates to:
  /// **'ถัดไป'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In th, this message translates to:
  /// **'เริ่มต้นใช้งาน'**
  String get getStarted;

  /// No description provided for @aiMealPlanner.
  ///
  /// In th, this message translates to:
  /// **'🧠 AI แนะนำอาหาร 3 มื้อ'**
  String get aiMealPlanner;

  /// No description provided for @calculatingMeals.
  ///
  /// In th, this message translates to:
  /// **'กำลังคำนวณอาหารที่เหมาะสม...'**
  String get calculatingMeals;

  /// No description provided for @randomizeMeals.
  ///
  /// In th, this message translates to:
  /// **'สุ่มใหม่ (Refresh)'**
  String get randomizeMeals;

  /// No description provided for @scanBiometrics.
  ///
  /// In th, this message translates to:
  /// **'สแกนลายนิ้วมือ/ใบหน้า'**
  String get scanBiometrics;

  /// No description provided for @biometricsFailed.
  ///
  /// In th, this message translates to:
  /// **'การยืนยันตัวตนล้มเหลว กรุณาลองอีกครั้ง'**
  String get biometricsFailed;

  /// No description provided for @mustLogin.
  ///
  /// In th, this message translates to:
  /// **'กรุณาเข้าสู่ระบบ'**
  String get mustLogin;

  /// No description provided for @enterEmail.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกอีเมล'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกรหัสผ่าน'**
  String get enterPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In th, this message translates to:
  /// **'รูปแบบอีเมลไม่ถูกต้อง'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In th, this message translates to:
  /// **'รหัสผ่านต้องยาวอย่างน้อย 6 ตัวอักษร'**
  String get passwordTooShort;

  /// No description provided for @enterName.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกชื่อของคุณ'**
  String get enterName;

  /// No description provided for @noMealsToday.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีรายการอาหารวันนี้\nกดปุ่ม + เพื่อบันทึกมื้อแรกเลย!'**
  String get noMealsToday;

  /// No description provided for @requiredField.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกข้อมูล'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In th, this message translates to:
  /// **'ตัวเลขไม่ถูกต้อง'**
  String get invalidNumber;

  /// No description provided for @month.
  ///
  /// In th, this message translates to:
  /// **'เดือน'**
  String get month;

  /// No description provided for @undo.
  ///
  /// In th, this message translates to:
  /// **'เลิกทำ (Undo)'**
  String get undo;

  /// No description provided for @deletedMeal.
  ///
  /// In th, this message translates to:
  /// **'ลบเมนู {foodName} แล้ว'**
  String deletedMeal(Object foodName);

  /// No description provided for @quantity.
  ///
  /// In th, this message translates to:
  /// **'ปริมาณ'**
  String get quantity;

  /// No description provided for @snack.
  ///
  /// In th, this message translates to:
  /// **'ของว่าง'**
  String get snack;

  /// No description provided for @warningOverLimit.
  ///
  /// In th, this message translates to:
  /// **'ระวัง! คุณทาน {nutrients} เกินโควต้าแล้ว'**
  String warningOverLimit(Object nutrients);

  /// No description provided for @warningNearLimit.
  ///
  /// In th, this message translates to:
  /// **'แจ้งเตือน: ปริมาณ {nutrients} ใกล้เกินกำหนด (เกิน 80%)'**
  String warningNearLimit(Object nutrients);

  /// No description provided for @aiPlannerTitle.
  ///
  /// In th, this message translates to:
  /// **'🧠 AI แนะนำอาหาร 3 มื้อ'**
  String get aiPlannerTitle;

  /// No description provided for @refresh.
  ///
  /// In th, this message translates to:
  /// **'สุ่มใหม่ (Refresh)'**
  String get refresh;

  /// No description provided for @noMealsFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่สามารถหาเมนูที่พอดีกับโควต้าได้'**
  String get noMealsFound;

  /// No description provided for @noName.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีชื่อ'**
  String get noName;

  /// No description provided for @offlineModeMessage.
  ///
  /// In th, this message translates to:
  /// **'คุณกำลังอยู่ในโหมดออฟไลน์ ข้อมูลจะถูกซิงก์เมื่อเชื่อมต่ออีกครั้ง'**
  String get offlineModeMessage;

  /// No description provided for @noInternetTitle.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีการเชื่อมต่ออินเทอร์เน็ต'**
  String get noInternetTitle;

  /// No description provided for @noInternetDesc.
  ///
  /// In th, this message translates to:
  /// **'กรุณาตรวจสอบอินเทอร์เน็ตของคุณ\nหากต้องการดูข้อมูลเดิม สามารถเข้าสู่โหมดออฟไลน์ได้'**
  String get noInternetDesc;

  /// No description provided for @retry.
  ///
  /// In th, this message translates to:
  /// **'ลองอีกครั้ง'**
  String get retry;

  /// No description provided for @workOffline.
  ///
  /// In th, this message translates to:
  /// **'ทำงานแบบออฟไลน์'**
  String get workOffline;

  /// No description provided for @canOnlyLogTodayMeals.
  ///
  /// In th, this message translates to:
  /// **'คุณสามารถบันทึกอาหารได้เฉพาะวันที่ปัจจุบันเท่านั้น'**
  String get canOnlyLogTodayMeals;

  /// No description provided for @excellent.
  ///
  /// In th, this message translates to:
  /// **'ยอดเยี่ยมมาก!'**
  String get excellent;

  /// No description provided for @warningOverLimitDash.
  ///
  /// In th, this message translates to:
  /// **'ปริมาณ {nutrients} ที่บริโภคในวันนี้เกินเกณฑ์ที่แนะนำสำหรับสุขภาพไตแล้ว ควรจำกัดการบริโภคในมื้อถัดไป'**
  String warningOverLimitDash(Object nutrients);

  /// No description provided for @warningNearLimitDash.
  ///
  /// In th, this message translates to:
  /// **'ปริมาณ {nutrients} ที่บริโภควันนี้สูงกว่า 80% ของเกณฑ์ควบคุมแล้ว แนะนำให้เลือกเมนูที่มีปริมาณสารอาหารนี้ต่ำลงสำหรับมื้อถัดไป'**
  String warningNearLimitDash(Object nutrients);

  /// No description provided for @weightValidationEmpty.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกน้ำหนัก'**
  String get weightValidationEmpty;

  /// No description provided for @weightValidationInvalid.
  ///
  /// In th, this message translates to:
  /// **'น้ำหนักต้องอยู่ระหว่าง 20 ถึง 300 กิโลกรัม'**
  String get weightValidationInvalid;

  /// No description provided for @heightValidationEmpty.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกส่วนสูง'**
  String get heightValidationEmpty;

  /// No description provided for @heightValidationInvalid.
  ///
  /// In th, this message translates to:
  /// **'ส่วนสูงต้องอยู่ระหว่าง 100 ถึง 250 เซนติเมตร'**
  String get heightValidationInvalid;

  /// No description provided for @privacyPolicy.
  ///
  /// In th, this message translates to:
  /// **'นโยบายความเป็นส่วนตัว'**
  String get privacyPolicy;

  /// No description provided for @navAddMeal.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มเมนู'**
  String get navAddMeal;

  /// No description provided for @logUrine.
  ///
  /// In th, this message translates to:
  /// **'บันทึกปัสสาวะ'**
  String get logUrine;

  /// No description provided for @logUrineDesc.
  ///
  /// In th, this message translates to:
  /// **'บันทึกปริมาณปัสสาวะที่ออก'**
  String get logUrineDesc;

  /// No description provided for @urine.
  ///
  /// In th, this message translates to:
  /// **'ปัสสาวะ'**
  String get urine;

  /// No description provided for @urineLoggedSuccess.
  ///
  /// In th, this message translates to:
  /// **'บันทึกปัสสาวะเรียบร้อยแล้ว'**
  String get urineLoggedSuccess;

  /// No description provided for @urineVolumeMl.
  ///
  /// In th, this message translates to:
  /// **'ปริมาณปัสสาวะ (ml)'**
  String get urineVolumeMl;

  /// No description provided for @netWaterBalance.
  ///
  /// In th, this message translates to:
  /// **'ยอดดุลน้ำสะสม'**
  String get netWaterBalance;

  /// No description provided for @waterIntake.
  ///
  /// In th, this message translates to:
  /// **'น้ำดื่มสะสม'**
  String get waterIntake;

  /// No description provided for @urineOutput.
  ///
  /// In th, this message translates to:
  /// **'ปัสสาวะสะสม'**
  String get urineOutput;

  /// No description provided for @fluidBalanceTitle.
  ///
  /// In th, this message translates to:
  /// **'การประเมินภาวะสมดุลน้ำ (Fluid Balance)'**
  String get fluidBalanceTitle;

  /// No description provided for @gramsUnit.
  ///
  /// In th, this message translates to:
  /// **'กรัม'**
  String get gramsUnit;

  /// No description provided for @milligramsUnit.
  ///
  /// In th, this message translates to:
  /// **'มก.'**
  String get milligramsUnit;

  /// No description provided for @millilitersUnit.
  ///
  /// In th, this message translates to:
  /// **'มล.'**
  String get millilitersUnit;

  /// No description provided for @fluidBalanceSubtitle.
  ///
  /// In th, this message translates to:
  /// **'ความสมดุลระหว่างน้ำดื่มและปัสสาวะ'**
  String get fluidBalanceSubtitle;

  /// No description provided for @fluidBalanceDoctorTip.
  ///
  /// In th, this message translates to:
  /// **'ยอดดุลน้ำสะสมที่เหมาะสมควรเป็นไปตามที่แพทย์แนะนำ'**
  String get fluidBalanceDoctorTip;

  /// No description provided for @remindersTitle.
  ///
  /// In th, this message translates to:
  /// **'ตั้งเวลาแจ้งเตือน'**
  String get remindersTitle;

  /// No description provided for @addReminder.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มการแจ้งเตือน'**
  String get addReminder;

  /// No description provided for @reminderTime.
  ///
  /// In th, this message translates to:
  /// **'เวลาแจ้งเตือน'**
  String get reminderTime;

  /// No description provided for @reminderMenu.
  ///
  /// In th, this message translates to:
  /// **'เมนูอาหาร/น้ำดื่ม'**
  String get reminderMenu;

  /// No description provided for @reminderType.
  ///
  /// In th, this message translates to:
  /// **'ประเภทการแจ้งเตือน'**
  String get reminderType;

  /// No description provided for @reminderMeal.
  ///
  /// In th, this message translates to:
  /// **'เตือนมื้ออาหาร'**
  String get reminderMeal;

  /// No description provided for @reminderWater.
  ///
  /// In th, this message translates to:
  /// **'เตือนดื่มน้ำ'**
  String get reminderWater;

  /// No description provided for @reminderSaved.
  ///
  /// In th, this message translates to:
  /// **'บันทึกการแจ้งเตือนสำเร็จ'**
  String get reminderSaved;

  /// No description provided for @reminderDeleted.
  ///
  /// In th, this message translates to:
  /// **'ลบการแจ้งเตือนแล้ว'**
  String get reminderDeleted;

  /// No description provided for @noReminders.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีการแจ้งเตือนกำหนดเอง\nกดปุ่ม + เพื่อเพิ่มเลย!'**
  String get noReminders;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
