# CKD Nutrition App 🥗💧

**CKD Nutrition** เป็นแอปพลิเคชันบนมือถือระดับองค์กร (Enterprise-grade) ที่ออกแบบมาเพื่อช่วยเหลือผู้ป่วยโรคไตเรื้อรัง (Chronic Kidney Disease - CKD) ในการจัดการโภชนาการและการดื่มน้ำในแต่ละวันอย่างเคร่งครัด แอปพลิเคชันนี้ถูกพัฒนาด้วยสถาปัตยกรรมที่ทันสมัยของ Flutter โดยเน้นที่การทำงานแบบ **Offline-first** (ใช้งานได้แม้ไม่มีอินเทอร์เน็ต), ความปลอดภัยระดับสูง และการออกแบบ UI ที่เป็น "Dark Mode Only" เพื่อความพรีเมียมและถนอมสายตา

---

## 🌟 ภาพรวมฟีเจอร์หลัก (Key Features)

1. **Dashboard เช็คโควต้าสารอาหารรายวัน:** ติดตามปริมาณ โซเดียม, โพแทสเซียม, ฟอสฟอรัส และโปรตีน แบบเรียลไทม์ พร้อมกราฟวงกลมแสดงสัดส่วนที่ทานไปเทียบกับโควต้าสูงสุดของแต่ละระยะโรคไต (Stage 1-5)
2. **Offline-first Data Sync:** ข้อมูลทั้งหมดจะถูกบันทึกลงฐานข้อมูลในเครื่อง (Local Database) ทันที ทำให้ผู้ใช้บันทึกอาหารได้แม้ไม่มีเน็ต และระบบจะทำการซิงค์ขึ้น Cloud (Supabase) ทันทีเมื่ออินเทอร์เน็ตกลับมาใช้งานได้
3. **ระบบจัดการการดื่มน้ำ (Hydration Tracking):** แถบบันทึกการดื่มน้ำที่ใช้งานง่าย พร้อมหลอดแสดงปริมาณน้ำแบบไดนามิก ป้องกันการดื่มน้ำเกินกำหนดสำหรับผู้ป่วยไตบวมน้ำ
4. **ความปลอดภัยของข้อมูล (Security):** รองรับระบบ Biometrics (สแกนนิ้ว/ใบหน้า) ก่อนเข้าใช้งานแอป และข้อมูลที่เก็บในเครื่องจะถูกเข้ารหัสแบบ AES
5. **หน้าต่างปฏิทินและสถิติ (Calendar & Streak):** ดูประวัติย้อนหลังด้วยปฏิทินไข่ปลา (Dot Indicator) และระบบ Streak ไฟลุกเพื่อสร้างแรงจูงใจในการคุมอาหารอย่างต่อเนื่อง

---

## 🏗 สถาปัตยกรรมและการออกแบบ (Architecture & Design Patterns)

แอปนี้ใช้โครงสร้างแบบ **Layered Architecture (Feature-First approach)** เพื่อให้โค้ดสามารถขยายสเกลได้ง่าย (Scalability) และแยกส่วนการทำงานออกจากกันชัดเจน:

- **Presentation Layer (`lib/pages/`)**: ส่วนติดต่อผู้ใช้ (UI) ทั้งหมด เขียนให้แสดงผลเปลี่ยนไปตาม State ทันทีโดยใช้ `flutter_riverpod`
- **Controller Layer (`lib/controllers/`)**: ตัวกลางระหว่าง UI และฐานข้อมูล ใช้ `StateNotifier` จัดการสถานะที่ซับซ้อน เช่น สถานะล็อกอิน, สถานะการกรอกฟอร์ม
- **Repository Layer (`lib/repositories/`)**: ชั้นจัดการข้อมูล ทำหน้าที่ตัดสินใจว่าจะดึงข้อมูลจาก Local Database (Isar) หรือจาก Cloud Server (Supabase)
- **Provider Layer (`lib/providers/`)**: ศูนย์กลางการทำ Dependency Injection เพื่อแจกจ่าย Controller และ Service ต่างๆ
- **Core Layer (`lib/core/`)**: โค้ดพื้นฐานที่ถูกเรียกใช้บ่อยๆ เช่น ระบบจัดการ Error แบบ `Result<T>` และ Utils ต่างๆ

---

## 🛠 เจาะลึกเทคโนโลยีที่ใช้ (Deep Technical Stack)

### 1. Framework & Core
- **Flutter SDK**: เวอร์ชัน `^3.7.2` (รันจริงบน `3.29.3` Stable ล่าสุด)
- **Dart SDK**: รองรับ Sound Null Safety แบบเต็มรูปแบบ

### 2. State Management & Dependency Injection
- **[flutter_riverpod](https://pub.dev/packages/flutter_riverpod) (^2.6.1)**: หัวใจหลักของแอป ใช้จัดการ State, Caching และ Dependency Injection แบบ Reactive
- **[provider](https://pub.dev/packages/provider) (^6.1.5+1)**: ใช้ทำงานร่วมกับบาง Plugin ที่ยังจำเป็นต้องใช้

### 3. ระบบนำทาง (Routing)
- **[go_router](https://pub.dev/packages/go_router) (^17.0.0)**: จัดการการเปลี่ยนหน้าแบบ Declarative รองรับ Deep Link และ Authentication Guards (เตะผู้ใช้ที่ยังไม่ล็อกอินกลับไปหน้า Login อัตโนมัติ)

### 4. ฐานข้อมูลและระบบสมาชิก (Backend / BaaS)
- **[supabase_flutter](https://pub.dev/packages/supabase_flutter) (^2.5.0)**: ระบบ Cloud Backend หลัก (PostgreSQL) ใช้ทำระบบล็อกอิน (Email, Google, Apple) และตั้งกฎ Row Level Security (RLS) ปกป้องข้อมูลผู้ป่วย
- **[google_sign_in](https://pub.dev/packages/google_sign_in) (^6.2.1)**: สำหรับระบบล็อกอินผ่าน Google OAuth 2.0

### 5. ฐานข้อมูลในเครื่อง (Local Database - Offline First)
- **[isar](https://pub.dev/packages/isar) (^3.1.0)**: NoSQL Database ที่ทำงานเร็วมาก ถูกนำมาใช้เก็บข้อมูลอาหารออฟไลน์ เมื่อมีเน็ตจะทำงานร่วมกับ `offline_sync_worker.dart` เพื่ออัปเดตข้อมูลขึ้น Cloud

### 6. ความปลอดภัยและรหัสผ่าน (Security)
- **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) (^10.3.1)**: เก็บ Token สำคัญด้วยการเข้ารหัสขั้นสูง (Keychain ของ iOS และ Keystore ของ Android)
- **[local_auth](https://pub.dev/packages/local_auth) (^2.3.0)**: ระบบสแกนใบหน้า (FaceID) / ลายนิ้วมือ (TouchID)
- **[cryptography](https://pub.dev/packages/cryptography) (^2.9.0)**: ใช้เข้ารหัสข้อมูล Local ภายในตัวเครื่อง

### 7. UI / UX และภาพเคลื่อนไหว (Animations)
- **[flutter_animate](https://pub.dev/packages/flutter_animate) (^4.5.2)**: ทำแอนิเมชันระดับ Micro-interactions (Fade, Slide, Shimmer) ทั่วทั้งแอป
- **[fl_chart](https://pub.dev/packages/fl_chart) (0.69.0)**: สร้างกราฟสถิติแสดงผลโภชนาการ
- **[percent_indicator](https://pub.dev/packages/percent_indicator) (^4.2.5)**: สร้างหลอด Progress แบบวงกลมและเส้นตรง สำหรับโควต้าสารอาหาร
- **[table_calendar](https://pub.dev/packages/table_calendar) (^3.1.3)**: ปฏิทินแสดงประวัติการทานอาหาร
- **[google_fonts](https://pub.dev/packages/google_fonts) (^6.3.2)**: จัดการ Typography ให้ดูทันสมัยและพรีเมียม

### 8. Monitoring & Background Services
- **[sentry_flutter](https://pub.dev/packages/sentry_flutter) (^9.22.0)**: ดักจับแครช (Crash Reporting) และตรวจสอบประสิทธิภาพการทำงานของแอปแบบเรียลไทม์
- **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) (^19.5.0)**: แจ้งเตือนมื้ออาหารและดื่มน้ำผ่านระบบเครื่องโดยตรง (Local Notification)
- **[connectivity_plus](https://pub.dev/packages/connectivity_plus) (^7.1.1)**: ดักจับสถานะอินเทอร์เน็ต เพื่อสลับ UI แอปเข้าโหมดออฟไลน์ (Offline Mode) อัตโนมัติ

---

## 📂 โครงสร้างโปรเจกต์ (Project Structure)

```text
lib/
├── main.dart
├── controllers/ (ตัวกลางจัดการ State ของหน้าต่างๆ)
│   ├── auth_controller.dart
│   ├── food_search_controller.dart
│   ├── meal_controller.dart
│   └── register_controller.dart
├── core/
│   ├── result.dart
│   └── utils/
│       └── date_utils.dart
├── l10n/ (ระบบแปลภาษา Localization)
├── models/
│   ├── isar/ (โมเดลฐานข้อมูล Offline)
│   └── supabase/ (โมเดลฐานข้อมูล Cloud)
├── pages/ (หน้าจอ UI)
│   ├── auth/
│   ├── dashboard/
│   ├── food/
│   ├── history/
│   ├── planner/
│   └── profile/
├── providers/ (ตัวแปร Global จาก Riverpod)
├── repositories/ (จัดการดึงข้อมูลจาก DB/Cloud)
├── router/ (ระบบเปลี่ยนหน้า GoRouter)
├── services/ (Business Logic เชิงลึก)
│   ├── biometric_service.dart
│   ├── ckd_rule_service.dart (กฎการคำนวณโภชนาการสำหรับโรคไต)
│   ├── dashboard_usecase.dart
│   ├── encryption_service.dart
│   ├── health_profile_service.dart
│   ├── isar_seed_service.dart
│   ├── notification_service.dart
│   ├── offline_sync_worker.dart (ซิงค์ข้อมูลเบื้องหลัง)
│   └── quota_engine.dart
├── theme/ (สีและฟอนต์)
│   └── app_theme.dart
└── widgets/ (UI Components ที่ใช้ซ้ำ)
```

---

## 🔒 การตั้งค่าสภาพแวดล้อม (Environment Configuration)

โปรเจกต์นี้ใช้ **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)** เพื่อเก็บค่าตัวแปรความลับ
ก่อนจะรันแอปได้ คุณต้องสร้างไฟล์ 2 ไฟล์ไว้ในโฟลเดอร์นอกสุดของโปรเจกต์ คือ `.env.dev` และ `.env.prod`

**ตัวอย่างข้อมูลข้างในไฟล์ `.env.dev`:**
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_WEB_CLIENT_ID=your-google-web-client-id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=your-google-ios-client-id.apps.googleusercontent.com
SENTRY_DSN=https://your-sentry-dsn
```

---

## 🚀 วิธีการติดตั้งและรันโปรเจกต์

### 1. สิ่งที่ต้องมีเบื้องต้น
- Flutter SDK `3.29.3`
- Dart SDK `3.7.2`
- Cocoapods (สำหรับรันบน iOS)

### 2. การติดตั้ง
```bash
# โหลด Dependencies ทั้งหมด
flutter pub get

# สร้างไฟล์โค้ดอัตโนมัติ (เช่น Isar Schemas และ Freezed Models)
dart run build_runner build --delete-conflicting-outputs
```

### 3. การเปิดใช้งานแอป
```bash
# รันแอปในโหมดนักพัฒนา (Development)
flutter run --flavor dev -t lib/main.dart
```

---

## 🤖 ระบบอัตโนมัติ CI/CD Pipeline (GitHub Actions)

เรามีระบบตรวจสอบคุณภาพโค้ดอัตโนมัติทุกครั้งที่โค้ดถูกดัน (Push) ขึ้น GitHub (อยู่ในไฟล์ `.github/workflows/flutter_ci.yml`):

- **Security Scan (`gitleaks`)**: สแกนหา API Key หรือ Password ที่เผลอหลุดเข้ามาในโค้ด
- **Vulnerability Check**: สแกนช่องโหว่ของ Plugin ที่โหลดมาใช้งาน
- **Format Validation**: บังคับให้หน้าตาโค้ดเว้นบรรทัดและปีกกาตรงตามมาตรฐาน `dart format`
- **Static Code Analysis**: สแกนหาบัคและแจ้งเตือนด้วย `flutter analyze` (โค้ดจะผ่านก็ต่อเมื่อเป็น 0 Issues)

*(เรามีแผนงานที่จะอัปเกรด CI/CD นี้นำ AI เข้ามารีวิวโค้ดเป็นภาษาไทย และเพิ่มการรันเทสบนมือถือจำลองด้วย Firebase Test Lab ในอนาคต)*

---

## 🎨 ปรัชญาการออกแบบ (UI/UX Philosophy)
- **Dark Mode Only**: ล็อคให้แสดงผลเฉพาะโหมดมืด เพื่อให้แอปดูพรีเมียม สุขุม และช่วยถนอมสายตาผู้ป่วยที่ต้องบันทึกอาหารทั้งวัน
- **Mesh Gradients**: พื้นหลังใช้เทคนิคการเบลนสีแบบนุ่มนวล (Mesh Gradients) ให้ดูทันสมัย
- **Glassmorphism**: เมนู Pop-up และการ์ดต่างๆ ใช้เอฟเฟกต์กระจกเบลอ (`BackdropFilter`) เพื่อเพิ่มมิติความลึกของหน้าจอ