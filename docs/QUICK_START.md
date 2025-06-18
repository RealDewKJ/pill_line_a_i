# 🚀 Quick Start Guide - Unit Testing

## ⚡ ขั้นตอนด่วน (5 นาที)

### 1. ติดตั้ง Dependencies

```bash
flutter pub get
```

### 2. สร้าง Mock Files

```bash
flutter pub run build_runner build
```

### 3. รัน Test

```bash
flutter test
```

---

## 📋 คำสั่งที่ใช้บ่อย

| คำสั่ง                                     | ความหมาย                    |
| ------------------------------------------ | --------------------------- |
| `flutter test`                             | รัน test ทั้งหมด            |
| `flutter test test/features/ex_notdata/`   | รัน test เฉพาะ ex_notdata   |
| `flutter test test/features/video_stream/` | รัน test เฉพาะ video_stream |
| `flutter test --verbose`                   | รัน test พร้อมรายละเอียด    |
| `flutter test --coverage`                  | รัน test พร้อม coverage     |

---

## 🔍 การอ่านผลลัพธ์

### ✅ ผ่าน

```
✓ VideoStreamEntity should create VideoStreamEntity with default values
✓ VideoStreamController openVideoDialog should set showVideoDialog to true
00:02 +2: All tests passed!
```

### ❌ ล้มเหลว

```
✗ VideoStreamController initial state should be correct
  Expected: true
    Actual: false
00:01 +1 -1: Some tests failed.
```

---

## 🛠️ แก้ปัญหาด่วน

### ปัญหา: Mock Files ไม่มี

```bash
flutter pub run build_runner build
```

### ปัญหา: LateInitializationError

แก้ใน controller:

```dart
// เปลี่ยนจาก
late AnimationController _animationController;

// เป็น
AnimationController? _animationController;
```

### ปัญหา: Test Timeout

เพิ่ม timeout:

```dart
test('long running test', () async {
  // test code
}, timeout: Duration(seconds: 60));
```

---

## 📁 โครงสร้างไฟล์

```
test/
├── features/
│   ├── ex_notdata/          # ทดสอบ ex_notdata feature
│   └── video_stream/        # ทดสอบ video_stream feature
└── widget_test.dart         # Widget test หลัก
```

---

## 🎯 สิ่งที่ทดสอบ

- **Entity** - โครงสร้างข้อมูล
- **Repository** - การจัดการข้อมูล
- **Controller** - Business logic
- **BLoC** - State management

---

## 📞 ขอความช่วยเหลือ

ส่งข้อมูลนี้:

```
Error: [Error message]
File: [file path]
Test: [test file]
Steps: [steps taken]
```

---

**🎉 พร้อมแล้ว! เริ่มทดสอบได้เลย**
