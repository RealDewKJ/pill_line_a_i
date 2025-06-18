# 👨‍💻 คู่มือสำหรับ Tester - Unit Testing

## 🎯 สำหรับ Tester ที่จะทดสอบ Unit Tests

### 📋 สิ่งที่ต้องเตรียม

#### 1. เครื่องมือที่จำเป็น

- **Flutter SDK** (เวอร์ชันเดียวกับโปรเจกต์)
- **Git** (ถ้าต้อง clone repository)
- **Terminal/Command Prompt**

#### 2. ตรวจสอบ Flutter

```bash
flutter --version
flutter doctor
```

---

## 🚀 ขั้นตอนการทดสอบ

### ขั้นตอนที่ 1: ดึงโปรเจกต์

```bash
# ถ้าใช้ Git
git clone [repository-url]
cd pill_line_a_i

# หรือถ้าได้รับไฟล์ zip
# แตกไฟล์และเปิด terminal ในโฟลเดอร์โปรเจกต์
```

### ขั้นตอนที่ 2: ติดตั้ง Dependencies

```bash
flutter pub get
```

### ขั้นตอนที่ 3: สร้าง Mock Files

```bash
flutter pub run build_runner build
```

### ขั้นตอนที่ 4: รัน Test

```bash
flutter test
```

---

## 📊 การอ่านผลลัพธ์

### ✅ Test ผ่าน

```
✓ VideoStreamEntity should create VideoStreamEntity with default values
✓ VideoStreamController openVideoDialog should set showVideoDialog to true
✓ ExNotData should create ExNotData with correct properties
00:03 +3: All tests passed!
```

**หมายความ:** ทุก test ผ่าน ✅

### ❌ Test ล้มเหลว

```
✗ VideoStreamController initial state should be correct
  Expected: true
    Actual: false
00:01 +2 -1: Some tests failed.
```

**หมายความ:** มี test ล้มเหลว 1 ตัว ❌

### ⚠️ Test มี Error

```
LateInitializationError: Field '_animationController' has not been initialized.
  at VideoStreamController.dispose (video_stream_controller.dart:310:5)
```

**หมายความ:** มี error ในการรัน test ⚠️

---

## 🔍 การทดสอบเฉพาะส่วน

### ทดสอบเฉพาะ Feature

```bash
# ทดสอบ ex_notdata feature
flutter test test/features/ex_notdata/

# ทดสอบ video_stream feature
flutter test test/features/video_stream/
```

### ทดสอบเฉพาะไฟล์

```bash
# ทดสอบ entity
flutter test test/features/ex_notdata/ex_notdata_entity_test.dart

# ทดสอบ controller
flutter test test/features/video_stream/video_stream_controller_test.dart
```

### ทดสอบแบบ Verbose

```bash
flutter test --verbose
```

---

## 📝 การรายงานผล

### ข้อมูลที่ต้องรายงาน

#### 1. สรุปผลการทดสอบ

```
✅ ผ่าน: X tests
❌ ล้มเหลว: Y tests
⚠️ Error: Z tests
รวม: X+Y+Z tests
```

#### 2. รายละเอียด Test ที่ล้มเหลว

```
Test: [ชื่อ test]
File: [ไฟล์ที่ล้มเหลว]
Error: [ข้อความ error]
Expected: [ค่าที่คาดหวัง]
Actual: [ค่าจริง]
```

#### 3. สิ่งแวดล้อม

```
Flutter Version: [เวอร์ชัน]
OS: [ระบบปฏิบัติการ]
Date: [วันที่ทดสอบ]
```

---

## 🛠️ การแก้ปัญหาพื้นฐาน

### ปัญหา: Mock Files ไม่มี

```bash
flutter pub run build_runner build
```

### ปัญหา: Dependencies ไม่ครบ

```bash
flutter pub get
```

### ปัญหา: Test Timeout

- รอสักครู่แล้วรันใหม่
- หรือแจ้งทีมพัฒนา

### ปัญหา: Import Error

- ตรวจสอบว่าเปิด terminal ในโฟลเดอร์โปรเจกต์
- รัน `flutter pub get` อีกครั้ง

---

## 📋 Checklist การทดสอบ

### ก่อนเริ่มทดสอบ

- [ ] ติดตั้ง Flutter SDK
- [ ] ดึงโปรเจกต์มาแล้ว
- [ ] เปิด terminal ในโฟลเดอร์โปรเจกต์
- [ ] รัน `flutter doctor` ผ่าน

### ขั้นตอนการทดสอบ

- [ ] รัน `flutter pub get`
- [ ] รัน `flutter pub run build_runner build`
- [ ] รัน `flutter test`
- [ ] บันทึกผลลัพธ์

### หลังการทดสอบ

- [ ] รายงานผลการทดสอบ
- [ ] แจ้งปัญหาที่พบ (ถ้ามี)
- [ ] ส่งข้อมูลตามรูปแบบที่กำหนด

---

## 📞 การขอความช่วยเหลือ

### เมื่อเจอปัญหา:

1. **อ่าน Troubleshooting Guide** ใน `docs/TROUBLESHOOTING.md`
2. **ลองแก้ปัญหาพื้นฐาน** ตามคู่มือ
3. **แจ้งทีมพัฒนา** พร้อมข้อมูล:

```
Error: [ข้อความ error]
File: [ไฟล์:บรรทัด:คอลัมน์]
Test: [ชื่อไฟล์ test]
Steps: [ขั้นตอนที่ทำ]
Environment: [Flutter version, OS]
```

### ตัวอย่างการแจ้งปัญหา:

```
Error: LateInitializationError: Field '_animationController' has not been initialized
File: video_stream_controller.dart:310:5
Test: video_stream_controller_test.dart
Steps: 1. flutter pub get 2. flutter test
Environment: Flutter 3.16.0, Windows 10
```

---

## 🎯 สิ่งที่ต้องทดสอบ

### 1. Entity Tests

- ✅ การสร้าง objects
- ✅ การตรวจสอบ properties
- ✅ การอัพเดทข้อมูล

### 2. Controller Tests

- ✅ การจัดการ UI state
- ✅ การเรียกใช้ methods
- ✅ การอัพเดท position

### 3. Repository Tests

- ✅ การเรียกใช้ data sources
- ✅ การจัดการ errors
- ✅ การ return ข้อมูล

### 4. BLoC Tests

- ✅ การจัดการ events
- ✅ การเปลี่ยน states
- ✅ การเรียกใช้ repository

---

## 📈 การประเมินผล

### เกณฑ์การประเมิน

- **ดีเยี่ยม:** ทุก test ผ่าน (100%)
- **ดี:** ผ่าน 90% ขึ้นไป
- **พอใช้:** ผ่าน 80% ขึ้นไป
- **ต้องปรับปรุง:** ผ่านน้อยกว่า 80%

### สิ่งที่ต้องรายงาน

1. **จำนวน test ทั้งหมด**
2. **จำนวน test ที่ผ่าน**
3. **จำนวน test ที่ล้มเหลว**
4. **รายละเอียด test ที่ล้มเหลว**
5. **ข้อเสนอแนะ (ถ้ามี)**

---

## 🎉 สรุป

### หน้าที่ของ Tester

- ✅ รัน test ตามขั้นตอน
- ✅ บันทึกผลลัพธ์
- ✅ รายงานปัญหาที่พบ
- ✅ แจ้งทีมพัฒนาทันที

### ประโยชน์ของการทดสอบ

- 🛡️ ป้องกัน bug
- 📝 ตรวจสอบความถูกต้อง
- 🚀 เพิ่มความมั่นใจ
- 📊 วัดคุณภาพโค้ด

---

**🎯 เริ่มต้นด้วยการรัน `flutter test` เลย!**
