<div align="center">
  <img src="https://raw.githubusercontent.com/xhm-stk/CKD_Nutrition/main/assets/app_icon.png" width="120" alt="CKD Nutrition Logo" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3003/3003035.png'"/>

  <h1>🥗 CKD Nutrition App</h1>
  <p><strong>แอปพลิเคชันบนมือถือที่ออกแบบมาเพื่อช่วยเหลือผู้ป่วยโรคไตเรื้อรัง (Chronic Kidney Disease - CKD) ระดับพรีเมียม</strong></p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
  [![Isar](https://img.shields.io/badge/Isar_Database-F05F70?style=for-the-badge&logo=mongodb&logoColor=white)](https://isar.dev/)
  [![Sentry](https://img.shields.io/badge/Sentry-362D59?style=for-the-badge&logo=sentry&logoColor=white)](https://sentry.io/)
</div>

<br/>

แอปพลิเคชันนี้ออกแบบมาเพื่อช่วยเหลือผู้ป่วยในการบันทึกโภชนาการ และติดตามปริมาณสารอาหารในแต่ละวันอย่างใกล้ชิด เพื่อป้องกันไม่ให้ไตทำงานหนักเกินไป ช่วยให้คุณดูแลรักษาสุขภาพไตได้อย่างยั่งยืนด้วย **UI/UX ดีไซน์ที่ทันสมัยและใช้งานง่าย**

---

## 🎯 วิสัยทัศน์และเป้าหมาย (Vision & Goals)
เป้าหมายของแอปพลิเคชันนี้คือการเป็น **"ผู้ช่วยส่วนตัวประจำวัน"** สำหรับผู้ป่วยโรคไต ที่รวดเร็ว ปลอดภัย และมีความสวยงาม ช่วยให้ผู้ป่วยสามารถควบคุมอาหารได้อย่างแม่นยำตามระยะของโรค (CKD Stage) เพื่อชะลอความเสื่อมของไตและเพิ่มคุณภาพชีวิตให้ดีขึ้น

---

## ✨ ฟีเจอร์เด่น (Key Features)

### 🔐 Authentication & Security (ปลอดภัยสูงสุด)
* **เข้าสู่ระบบลื่นไหล:** รองรับ Email/Password แบบ Premium UI พร้อมเอฟเฟกต์สุดล้ำ
* **Login ทางเลือก:** รองรับ Google Sign-In และ Apple Sign-In
* **ระบบป้องกันชั้นยอด:** Data Privacy ด้วย Row Level Security (RLS) ของ Supabase 

### 🩺 Health & Nutrition (ดูแลลึกถึงระดับบุคคล)
* **Health Profile Setup:** การตั้งค่าประวัติสุขภาพเบื้องต้น (น้ำหนัก, ส่วนสูง, เพศ, และระยะโรคไต) พร้อมระบบประเมินค่า GFR
* **Daily Nutrition Dashboard:** แดชบอร์ดสุดหรูแสดงผลโควต้าสารอาหารแบบ Real-time (โปรตีน, โพแทสเซียม, โซเดียม, น้ำตาล, คาร์โบไฮเดรต, น้ำ) 
* **Smart Alert:** ป้ายแจ้งเตือนสีสันชัดเจนเมื่อทานใกล้เกินกำหนด
* **Water Reminder:** ระบบเตือนดื่มน้ำแบบรวดเร็ว (Quick Entry)

### 🍎 Food Data & Offline-First (ทำงานไวดั่งใจ)
* **ค้นหาเมนูอาหาร:** ฐานข้อมูลเมนูอาหารกว่า 156 รายการ 
* **Offline-First:** ข้อมูลทั้งหมดถูกดึงและเก็บไว้ในมือถือ (Local Database) ใช้งานได้ปรู๊ดปร๊าดแม้ไม่มีอินเทอร์เน็ต
* **Auto Sync:** ทำงานผสานรวมข้อมูลกลับสู่ Cloud (Supabase) ทันทีเมื่อต่อเน็ต

---

## 🚀 ฟีเจอร์ที่กำลังมา (Coming Soon)
* **🌙 Dark Mode:** รองรับโหมดมืดแบบเต็มรูปแบบเพื่อถนอมสายตาผู้ใช้งาน
* **🖼️ ภาพอาหารสุดน่ากิน:** ภาพประกอบเมนูอาหารที่จะช่วยกระตุ้นความอยากอาหารที่ถูกต้อง
* **📷 สแกนบาร์โค้ด:** ค้นหาข้อมูลโภชนาการได้ทันทีจากฉลากสินค้า
* **📈 กราฟสุขภาพ:** แสดงสถิติย้อนหลังในรูปแบบกราฟสุดสวยงาม

---

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

| หมวดหมู่ | เทคโนโลยี / เครื่องมือ |
| :--- | :--- |
| **Frontend Framework** | [Flutter](https://flutter.dev/) (Dart) 💙 |
| **Backend & Auth** | [Supabase](https://supabase.com/) (PostgreSQL) ⚡ |
| **Local Database** | [Isar](https://isar.dev/) (NoSQL Offline-first) 📦 |
| **State Management** | [Riverpod](https://riverpod.dev/) 🌊 |
| **CI/CD** | GitHub Actions ⚙️ |

---

## 📁 โครงสร้างโปรเจกต์ (Clean Architecture)
```text
lib/
├── controllers/            # ลอจิกการเชื่อมโยง UI และ State (Riverpod)
├── core/                   # Utility tools และการตั้งค่าพื้นฐาน
├── models/                 # โครงสร้างข้อมูล Data Models
├── pages/                  # หน้าจอ UI ทันสมัย (Premium UI)
├── providers/              # การจัดการ State ข้าม Widget
├── repositories/           # ติดต่อกับ Supabase และ API ภายนอก
├── router/                 # ระบบจัดการเส้นทาง (GoRouter)
├── services/               # ลอจิกการทำงาน Background (เช่น Sync)
├── theme/                  # ระบบธีม (Colors, Typography, UI Components)
└── widgets/                # คอมโพเนนต์ที่เรียกใช้ซ้ำ
```

---

## 🚀 วิธีการติดตั้งและรันโปรเจกต์ (Getting Started)

### 1. ความต้องการของระบบ
- **Flutter SDK:** เวอร์ชัน 3.29.3 หรือสูงกว่า
- **Android:** Android Studio พร้อม NDK `27.0.12077973`
- **iOS:** Xcode (สำหรับรันบน macOS)

### 2. การเตรียมไฟล์ตั้งค่า (.env)
โปรเจกต์นี้ใช้ไฟล์ `.env` กรุณาสร้างไฟล์ `.env.dev` และ `.env.prod` ในโฟลเดอร์หลัก:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SENTRY_DSN=your_sentry_dsn
```

### 3. เริ่มต้นรันโปรเจกต์
```bash
# โหลด Dependencies
flutter pub get

# สร้างไฟล์ Generated Code (สำหรับ Isar, Freezed, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# รันแอปพลิเคชัน
flutter run
```

---
<div align="center">
  <i>สร้างสรรค์เพื่อสุขภาพที่ดีของผู้ป่วยโรคไต</i> 💙
</div>