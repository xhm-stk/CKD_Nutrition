# ==============================================================================
# สคริปต์แก้ปัญหา Build ช้าถาวร (เพิ่มข้อยกเว้นใน Windows Defender)
# ==============================================================================

Write-Host "🚀 กำลังเพิ่มข้อยกเว้น (Exclusion) ใน Windows Defender เพื่อเร่งความเร็วการ Build..." -ForegroundColor Cyan

# 1. โฟลเดอร์ของโปรเจกต์ปัจจุบัน
$projectPath = (Get-Item -Path ".\").FullName
Write-Host "กำลังเพิ่ม: $projectPath" -ForegroundColor Yellow
Add-MpPreference -ExclusionPath $projectPath

# 2. โฟลเดอร์ Gradle Cache ส่วนกลางของเครื่อง
$gradlePath = "$env:USERPROFILE\.gradle"
Write-Host "กำลังเพิ่ม: $gradlePath" -ForegroundColor Yellow
Add-MpPreference -ExclusionPath $gradlePath

# 3. โฟลเดอร์ Pub Cache (แพ็กเกจของ Dart/Flutter)
$pubCachePath = "$env:LOCALAPPDATA\Pub\Cache"
Write-Host "กำลังเพิ่ม: $pubCachePath" -ForegroundColor Yellow
Add-MpPreference -ExclusionPath $pubCachePath

Write-Host "✅ เสร็จสิ้น! Windows Defender จะไม่สแกนโฟลเดอร์เหล่านี้ระหว่างทำเสร็จ ส่งผลให้ Build เร็วขึ้นแบบถาวร" -ForegroundColor Green
Write-Host "กดปุ่ม Enter เพื่อปิดหน้าต่างนี้..." -ForegroundColor Cyan
Read-Host
