<div align="center">
  <h1>🥗 CKD Nutrition App</h1>
  <p><strong>แอปพลิเคชันบนมือถือที่ออกแบบมาเพื่อช่วยเหลือผู้ป่วยโรคไตเรื้อรัง (Chronic Kidney Disease - CKD)</strong></p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
  [![Isar](https://img.shields.io/badge/Isar_Database-F05F70?style=for-the-badge&logo=mongodb&logoColor=white)](https://isar.dev/)
  [![Sentry](https://img.shields.io/badge/Sentry-362D59?style=for-the-badge&logo=sentry&logoColor=white)](https://sentry.io/)
</div>

<br/>

แอปพลิเคชันนี้ออกแบบมาเพื่อช่วยเหลือผู้ป่วยในการบันทึกโภชนาการ และติดตามปริมาณสารอาหารในแต่ละวันอย่างใกล้ชิด เพื่อป้องกันไม่ให้ไตทำงานหนักเกินไป และดูแลรักษาสุขภาพไตอย่างยั่งยืน

---

## 🎯 วิสัยทัศน์และเป้าหมาย (Vision & Goals)
เป้าหมายของแอปพลิเคชันนี้คือการเป็น **"ผู้ช่วยส่วนตัวประจำวัน"** สำหรับผู้ป่วยโรคไตทั่วโลก (Global Product) ที่ใช้งานง่าย รวดเร็ว และมีความปลอดภัยสูง ช่วยให้ผู้ป่วยสามารถควบคุมอาหารได้อย่างแม่นยำตามระยะของโรค (CKD Stage) เพื่อชะลอความเสื่อมของไตและเพิ่มคุณภาพชีวิตให้ดีขึ้น

---

## ✨ ฟีเจอร์ที่มีในปัจจุบัน (Current Features)

### 🔐 Authentication & Security
* **ระบบเข้าสู่ระบบ:** รองรับ Email/Password, Google Sign-In และ Apple Sign-In
* **Biometrics Lock:** รองรับการสแกนใบหน้า (FaceID) และลายนิ้วมือ (TouchID) ในการเข้าแอป
* **Data Privacy:** ปกป้องข้อมูลผู้ใช้งานด้วยระบบ Row Level Security (RLS) ของ Supabase
* **Environment Security:** ปกปิดคีย์และรหัสผ่านด้วยระบบไฟล์ `.env`

### 🩺 Health & Nutrition
* **Health Profile Setup:** การตั้งค่าประวัติสุขภาพเบื้องต้น (น้ำหนัก, ส่วนสูง, เพศ, และระยะโรคไต) เพื่อใช้คำนวณโควต้าอาหารเฉพาะบุคคล
* **Daily Nutrition Dashboard:** แดชบอร์ดแสดงผลโควต้าสารอาหารแบบ Real-time (โปรตีน, โพแทสเซียม, โซเดียม, น้ำตาล, คาร์โบไฮเดรต, น้ำ) พร้อมป้ายแจ้งเตือนเมื่อทานใกล้เกินกำหนด
* **Water Reminder:** ระบบแจ้งเตือนให้ดื่มน้ำตามความเหมาะสม

### 🍎 Food Data & Offline-First
* **Food Search & Logging:** ระบบค้นหาเมนูอาหารกว่า 156 รายการ พร้อมรายละเอียดโภชนาการและบันทึกมื้ออาหาร
* **Offline-First Capabilities:** ข้อมูลและประวัติการกินถูกเก็บไว้ในมือถือด้วย Local Database (Isar) ทำให้ค้นหาและทำงานได้อย่างรวดเร็วแม้ไม่มีอินเทอร์เน็ต
* **Background Sync Worker:** ระบบบันทึกข้อมูลอัตโนมัติ (Sync) ไปยัง Cloud (Supabase) เมื่อกลับมามีสัญญาณอินเทอร์เน็ต

---

## 🚀 ฟีเจอร์ที่วางแผนจะทำในอนาคต (Future Features)
* **🌙 Dark Mode:** รองรับโหมดมืดแบบเต็มรูปแบบเพื่อถนอมสายตาผู้ใช้งาน
* **🖼️ Food Images:** เพิ่มรูปภาพอาหารประกอบเมนูทั้ง 156 เมนู (ใช้ไฟล์ `.webp` แบบ Local Assets เพื่อให้แอปโหลดไวและทำงานได้แม้ออฟไลน์)
* **📷 Barcode Scanner:** ระบบสแกนบาร์โค้ดสำหรับค้นหาโภชนาการของอาหารสำเร็จรูป
* **🧑‍🍳 Custom Food Creation:** อนุญาตให้ผู้ใช้สร้างและบันทึกเมนูอาหารหรือสูตรอาหารของตัวเองได้
* **📈 Historical Charts & Reports:** กราฟแสดงสถิติการกินย้อนหลัง (รายสัปดาห์/รายเดือน)
* **📄 PDF Export:** สร้างรายงานโภชนาการเป็นไฟล์ PDF เพื่อให้ผู้ป่วยนำไปปรึกษาแพทย์หรือนักกำหนดอาหารได้
* **🌍 Multi-language Support (i18n):** รองรับหลายภาษา (เช่น ภาษาอังกฤษ) เพื่อก้าวสู่ความเป็น Global App

---

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

| หมวดหมู่ | เทคโนโลยี / เครื่องมือ |
| :--- | :--- |
| **Frontend Framework** | [Flutter](https://flutter.dev/) (Dart) |
| **Backend & Cloud DB** | [Supabase](https://supabase.com/) (PostgreSQL & Auth) |
| **Local Database** | [Isar](https://isar.dev/) (NoSQL) |
| **State Management** | [Riverpod](https://riverpod.dev/) |
| **Error Monitoring** | [Sentry](https://sentry.io/) |

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)
```text
lib/
├── controllers/            # จัดการ Business Logic ฝั่ง UI
├── core/                   # การตั้งค่าพื้นฐานของโปรเจกต์และ Utility tools
├── models/                 # โครงสร้างของข้อมูล (Isar, Supabase, Freezed)
├── pages/                  # หน้าจอ UI ต่างๆ (Auth, Dashboard, Food, History)
├── providers/              # State Management (Riverpod Providers)
├── repositories/           # จัดการ Data Access Layer (Supabase API)
├── router/                 # ระบบจัดการ Navigator (GoRouter)
├── services/               # ลอจิกการทำงานเบื้องหลัง (Auth, Offline Sync, Quota)
├── widgets/                # คอมโพเนนต์ UI ที่ถูกนำมาใช้ซ้ำ (Reusable Widgets)
└── main.dart               # จุดเริ่มต้นของแอปพลิเคชัน
```

---

## 🚀 วิธีการติดตั้งและรันโปรเจกต์ (Getting Started)

### 1. ความต้องการของระบบ (Prerequisites)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (เวอร์ชัน 3.7.2 หรือสูงกว่า)
- **Android:** Android Studio พร้อม NDK เวอร์ชัน `27.0.12077973`
- **iOS:** Xcode (สำหรับทดสอบบน Mac)

### 2. การเตรียมไฟล์ตั้งค่า (.env)
โปรเจกต์นี้ใช้ไฟล์ `.env` ในการเก็บคีย์ของ Supabase และ Sentry กรุณาสร้างไฟล์ `.env.dev` และ `.env.prod` ในโฟลเดอร์หลักของโปรเจกต์:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SENTRY_DSN=your_sentry_dsn
```

### 3. การรันโปรเจกต์
รันคำสั่งเหล่านี้ใน Terminal เพื่อโหลด Dependencies และสร้างโค้ด (Code Generation):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```