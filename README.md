# CKD Nutrition App 🥗💧

**CKD Nutrition** เป็นแอปพลิเคชันบนมือถือระดับองค์กร (Enterprise-grade) ที่ออกแบบมาเพื่อช่วยเหลือผู้ป่วยโรคไตเรื้อรัง (Chronic Kidney Disease - CKD) ในการจัดการโภชนาการและการดื่มน้ำในแต่ละวันอย่างเคร่งครัด พัฒนาด้วยสถาปัตยกรรมที่ทันสมัยของ Flutter โดยเน้นที่การทำงานแบบ **Offline-first** (ใช้งานได้แม้ไม่มีอินเทอร์เน็ต), ความปลอดภัยระดับสูง และการออกแบบ UI ที่เป็น "Dark Mode Only" เพื่อความพรีเมียมและถนอมสายตา

---

## 🌟 ภาพรวมฟีเจอร์หลัก (Key Features)

### 1. Dashboard เช็คโควต้าสารอาหารรายวัน (Daily Quota Engine)
* **การคํานวณแบบไดนามิก:** ติดตามปริมาณ โซเดียม, โพแทสเซียม, ฟอสฟอรัส และโปรตีน แบบเรียลไทม์ โดยโควต้าจะเปลี่ยนตามระดับโรคไตของผู้ป่วย (Stage 1-5) และโปรไฟล์ความสูง/น้ำหนัก
* **กราฟวงกลมและหลอดแสดงผล:** แสดงสัดส่วนสารอาหารที่ทานไปเทียบกับโควต้าสูงสุดของวันอย่างชัดเจน
* **แจ้งเตือนเฝ้าระวัง:** แสดงกล่องข้อควรระวัง/แจ้งเตือน (Warning Card) ทันทีที่มีสารอาหารตัวใดตัวหนึ่งใกล้เต็มโควต้า (>=80%) หรือเกินโควต้าที่กำหนด

### 2. แถบนำทางด้านล่างพรีเมียม (Premium Bottom Nav Bar)
* ปรับแต่งปุ่มวงกลมเพิ่มเมนูด้านล่างสุดตรงกลางใหม่หมดจด ให้มีป้ายกำกับภาษาแปลอัตโนมัติ **"เพิ่มเมนู"** / **"Add Meal"** 
* ตัวไอคอนเพิ่มอาหารล้อมรอบด้วยวงกลมโปร่งแสงมรกตสวยงาม มีขนาดความสูงและน้ำหนักตัวอักษรเท่ากันทุกแท็บ (แดชบอร์ด, ประวัติ, บัญชี) เพื่อความสมมาตรและดีไซน์ระดับโมเดิร์น

### 3. หน้าต่างบันทึกอาหารส่วนกลาง (Polished Add Action Sheet)
* สไลด์ขึ้นมาจากด้านล่างโดยมีความสูงเพียง **60% ของหน้าจอ** (กระชับพอดีเนื้อหาตามสกรีนช็อตรูปแบบ UX สมัยใหม่)
* ฉากหลังลงลายเส้น **เรืองแสงไล่เฉดสีมรกต (Mesh Gradient Background)** สวยงาม
* ปุ่มคีย์ลัดเลือกบันทึก 3 แบบใช้โทนสีแบรนด์ชัดเจน:
  * **เพิ่มเมนูจากแอป:** สีทองแอมเบอร์ (`AppTheme.brandSecondary`)
  * **สร้างอาหารแบบกำหนดเอง:** สีมินต์มรกตสะท้อนแสงอ่อน (`AppTheme.brandAccent`)
  * **บันทึกดื่มน้ำ:** สีฟ้าสว่างเฉดสะอาดตา (`Colors.cyan`)
* มีปุ่ม **"ยกเลิก"** ด้านล่างสุดเพื่อให้ผู้ใช้สัมผัสยกเลิกได้อย่างปลอดภัย

### 4. ระบบค้นหาและบันทึกอาหารจากคลังแอป (Food Search & Log Dialog)
* **แถบ AppBar และกล่องค้นหาแคปซูล:**
  * ฉากหลังหน้าเป็น `MeshGradientBackground` สีมืด
  * ช่องค้นหาเป็นรูปทรงแคปซูลขอบโค้งมน สีพื้นหลังดำโปร่งแสงเข้มขรึม มีขอบสีเขียวแบรนด์บางเบา **ไม่มีเส้นซ้อนทับกันที่ขอบโค้ง** และไม่มีปุ่มบวกเกินเข้ามาด้านขวา
  * แสดงปุ่มกากบาท `X` อัตโนมัติเพื่อล้างคำค้นหาเมื่อมีตัวหนังสือพิมพ์อยู่
* **การ์ดรายการอาหารแบบขยายพื้นที่แสดงผล:**
  * มีกรอบสี่เหลี่ยมพรีวิวขนาดใหญ่ 64x64 โค้งมน สำหรับใส่รูปถ่ายอาหารในอนาคต (ชั่วคราวเป็นไอคอนช้อนส้อมมินต์มรกต)
  * **แสดงโภชนาการครบทั้ง 6 สารอาหารหลัก:** โปรตีน (Protein), คาร์บ (Carbs), น้ำตาล (Sugar), โซเดียม (Sodium), โพแทสเซียม (Potassium) และฟอสฟอรัส (Phosphorus) ในรูปป้ายกำกับขนาดเล็กแยกสีชัดเจน
  * ปุ่มบวกบันทึกขวาการ์ดเป็นวงกลมสีเขียวมรกตแบรนด์เดี่ยวๆ สวยงามสะดุดตา
* **หน้าต่าง Log บันทึกอาหาร:** แสดงผลครึ่งหน้าจอเรืองแสงมรกต พร้อมช่องป้อนจำนวนและดรอปดาวน์เลือกมื้ออาหารขอบเรืองแสงเมื่อแตะสัมผัส พร้อมปุ่มย้อนกลับคู่บันทึก

### 5. ระบบสร้างอาหารแบบกำหนดเอง (Custom Food Creator)
* ไม่มีสัญลักษณ์ `➕` ในชื่อ AppBar และในชุดคำแปล (คีย์ `createCustomFood`) เพื่อความเป็นทางการของแอปการแพทย์
* ประดับหลังหน้าจอด้วยสีเรืองแสงไล่เฉด `MeshGradientBackground`
* **อินพุต PremiumTextField:** ช่องกรอกข้อมูลทั้งหมดแปลงเป็นขอบโค้งมน `30` มีเอฟเฟกต์ **Reversing Glow / เรืองแสงเขียวมรกตออร่ารอบกล่อง (Emerald Focus Bloom)** เมื่อผู้ใช้แตะสัมผัสและพิมพ์ พร้อมไอคอนนำหน้าแสดงประเภทสารอาหาร
* ปุ่มบันทึกด้านล่างปรับเป็นทรงมนกลมกว้างเด่นชัดและถอดอีโมจิออกทั้งหมดเพื่อความสะอาดตา

### 6. ระบบบันทึกน้ำดื่มเรืองแสงพรีเมียม (Polished Hydration Sheet)
* สไลด์ขึ้นแบบจำกัดความสูงพอดีคอนเทนต์ และแต่งขอบมน `32` บนฉากหลังเรืองแสงไล่เฉด
* **ปุ่มดื่มน้ำด่วนแบบเรืองแสงนีออน (Action Chips):** ชิป +100ml, +250ml, +500ml มีพื้นหลังน้ำเงินโปร่งแสง ขอบขลิบฟ้าเรืองแสง และข้อความสีฟ้าสว่างเฉดนีออนมืด
* **ช่องกรอกน้ำกำหนดเอง:** ดีไซน์ขอบมน `30` เรืองแสงรอบขอบเวลากดพิมพ์ด้วย `PremiumTextField` คู่กับปุ่มสีมรกตขนาดใหญ่เต็มขอบด้านล่าง

### 7. รายการประวัติมื้ออาหารวันนี้ครบ 6 สารอาหาร (All-Nutrients Meals List)
* กล่องแสดงรายการอาหารที่ทานไปแล้วในหน้าหลัก เปลี่ยนมาใช้พื้นหลังสีเข้มลอยเด่น `AppTheme.bgElevated` ขอบมน `16`
* เพิ่มการแสดงผลสรุป **โภชนาการครบถ้วนทั้ง 6 อย่าง** (โปรตีน, คาร์บ, น้ำตาล, โซเดียม, โพแทสเซียม, ฟอสฟอรัส) ในกล่องประวัติมื้ออาหารแต่ละรายการ ช่วยให้ผู้ป่วยโรคไตดูข้อมูลย้อนหลังประจำวันได้ครบถ้วนโดยไม่ต้องกดเข้าไปดูรายละเอียด
* ใช้ไอคอนนำหน้าตามมื้ออาหาร (เช้า, กลางวัน, เย็น, ว่าง) คุมโทนสีมินต์มรกตแบรนด์ร่วมสมัย

### 8. Offline-first Data Sync & Security
* ข้อมูลทั้งหมดจะถูกบันทึกลงฐานข้อมูลในเครื่อง (Local Database) ทันที ทำให้ผู้ใช้บันทึกอาหารได้แม้ไม่มีเน็ต และระบบจะทำการซิงค์ขึ้น Cloud (Supabase) ทันทีเมื่ออินเทอร์เน็ตกลับมาใช้งานได้
* รองรับระบบ Biometrics (สแกนนิ้ว/ใบหน้า) ก่อนเข้าใช้งานแอป และข้อมูลที่เก็บในเครื่องจะถูกเข้ารหัสแบบ AES

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