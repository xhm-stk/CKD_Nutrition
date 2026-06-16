# 🚀 คู่มือการ Build และ Deploy แอปพลิเคชัน (ระดับ Enterprise)

คู่มือนี้สำหรับทีม Release Engineer เพื่อป้องกันไม่ให้แฮกเกอร์สามารถทำ Reverse Engineering (Decompile) แกะซอร์สโค้ดของแอป CKD Nutrition ไปขโมยข้อมูล หรือลอจิกทางการแพทย์ของเราได้

## 🔐 กฎเหล็ก: การซ่อนซอร์สโค้ด (Code Obfuscation)

**ห้ามใช้คำสั่ง `flutter build apk` หรือ `flutter build ipa` ธรรมดาโดยเด็ดขาด!** 
การ Build แบบธรรมดา แฮกเกอร์สามารถแกะโค้ดออกมาเห็นชื่อตัวแปร, ชื่อฟังก์ชัน, และ API Keys ได้ง่ายมาก

ให้ใช้คำสั่งที่พ่วง `--obfuscate` เสมอ เพื่อเปลี่ยนชื่อตัวแปรทั้งหมดให้กลายเป็นภาษาต่างดาว (เช่น `a`, `b`, `c`)

### 🤖 สำหรับ Android (Google Play Store)
รันคำสั่งนี้ใน Terminal:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=./debug_info
```
*(ถ้าต้องการไฟล์ APK สำหรับเทส ให้เปลี่ยน `appbundle` เป็น `apk`)*

### 🍎 สำหรับ iOS (Apple App Store)
รันคำสั่งนี้ใน Terminal:
```bash
flutter build ipa --release --obfuscate --split-debug-info=./debug_info
```

---

## 📂 โฟลเดอร์ `debug_info` คืออะไร?
เมื่อเรารันคำสั่ง `--obfuscate` แล้ว หากแอปไปค้าง (Crash) ที่เครื่องคนไข้ รายงาน Error ที่ส่งกลับมาที่ Crashlytics จะเป็นภาษาต่างดาวอ่านไม่ออก
ดังนั้น ระบบจะสร้างไฟล์ถอดรหัสไว้ในโฟลเดอร์ `./debug_info` 
**⚠️ สำคัญ:** ห้ามลบโฟลเดอร์นี้ทิ้ง และห้ามอัปโหลดขึ้น GitHub สาธารณะ ให้เก็บไว้เฉพาะในเครื่องของทีม Dev หรืออัปโหลดเข้า Sentry/Crashlytics เพื่อใช้แปลภาษาต่างดาวกลับเป็นโค้ดที่มนุษย์อ่านได้ตอนเกิด Error เท่านั้น
