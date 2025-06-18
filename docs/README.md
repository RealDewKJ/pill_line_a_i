# 📚 Pill Line AI - Documentation

## 📖 สารบัญ

### 🚀 Getting Started

- **[Quick Start Guide](./QUICK_START.md)** - เริ่มต้นใช้งานโปรเจกต์
- **[Project Structure](./STRUCTURE.md)** - โครงสร้างโปรเจกต์และสถาปัตยกรรม

### 🧪 Testing

- **[Testing Guide](./TESTING_GUIDE.md)** - คู่มือการทดสอบ Unit Tests (สำหรับ Developer และ Tester)
- **[Troubleshooting Guide](./TROUBLESHOOTING.md)** - แก้ไขปัญหาที่พบบ่อย

---

## 🎯 ภาพรวม

Pill Line AI เป็นแอปพลิเคชัน Flutter สำหรับระบบจัดการสายการผลิตยา โดยใช้ AI และ WebSocket สำหรับการสื่อสารแบบ Real-time

### ✨ Features หลัก

- **Real-time WebSocket Communication** - การสื่อสารแบบ Real-time กับ backend
- **Video Streaming** - การแสดงผลวิดีโอสตรีม
- **AI Integration** - การใช้งาน AI สำหรับการวิเคราะห์
- **Clean Architecture** - สถาปัตยกรรมที่สะอาดและ maintainable
- **Comprehensive Testing** - การทดสอบที่ครอบคลุม

### 🏗️ Architecture

โปรเจกต์ใช้ Clean Architecture แบบ Feature-based:

```
lib/
├── core/                 # Core utilities และ configurations
├── features/            # Feature modules
│   ├── ex_notdata/     # ExNotData feature
│   ├── video_stream/   # Video streaming feature
│   └── home/           # Home feature
├── pages/              # Shared UI pages
├── services/           # Shared services
└── utils/              # Utility functions
```

### 🧪 Testing Strategy

- **Unit Tests** - ทดสอบ business logic และ components
- **Widget Tests** - ทดสอบ UI components
- **Integration Tests** - ทดสอบการทำงานร่วมกันของ features

---

## 🛠️ การพัฒนา

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- IDE (VS Code, Android Studio)
- Git

### การติดตั้ง

```bash
# Clone repository
git clone [repository-url]
cd pill_line_a_i

# Install dependencies
flutter pub get

# Generate mock files for testing
flutter pub run build_runner build

# Run tests
flutter test
```

### การรันแอป

```bash
# Development mode
flutter run

# Production build
flutter build apk
```

---

## 📋 การทดสอบ

### สำหรับ Developer

1. **อ่าน [Testing Guide](./TESTING_GUIDE.md)** - คู่มือการเขียนและรัน tests
2. **เขียน Unit Tests** สำหรับ business logic
3. **เขียน Widget Tests** สำหรับ UI components
4. **รัน tests** ก่อน commit

### สำหรับ Tester

1. **อ่าน [Testing Guide](./TESTING_GUIDE.md)** - คู่มือการรัน tests
2. **ติดตั้ง Flutter SDK**
3. **รัน tests** ตามขั้นตอนที่กำหนด
4. **รายงานผล** ตามรูปแบบที่กำหนด

---

## 🔧 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

- **Dependencies issues** - ดู [Troubleshooting Guide](./TROUBLESHOOTING.md)
- **Test failures** - ดู [Testing Guide](./TESTING_GUIDE.md)
- **Build errors** - ดู [Quick Start Guide](./QUICK_START.md)

### การขอความช่วยเหลือ

1. **อ่านเอกสาร** ในโฟลเดอร์นี้ก่อน
2. **ตรวจสอบ Troubleshooting Guide**
3. **ส่งข้อมูล** ตามรูปแบบที่กำหนด

---

## 📞 ติดต่อ

### ทีมพัฒนา

- **Project Lead** - [ชื่อ] ([email])
- **Backend Developer** - [ชื่อ] ([email])
- **Frontend Developer** - [ชื่อ] ([email])

### การรายงานปัญหา

- **Bug Reports** - ส่งผ่าน [issue tracker]
- **Feature Requests** - ส่งผ่าน [issue tracker]
- **Documentation Issues** - ส่งผ่าน [issue tracker]

---

## 📄 License

โปรเจกต์นี้เป็นส่วนหนึ่งของ [ชื่อบริษัท/องค์กร] และใช้สำหรับการพัฒนาระบบ Pill Line AI เท่านั้น

---

## 🎉 สรุป

เอกสารนี้จะช่วยให้คุณ:

- ✅ เข้าใจโครงสร้างโปรเจกต์
- ✅ เริ่มต้นการพัฒนาได้อย่างรวดเร็ว
- ✅ ทดสอบแอปได้อย่างถูกต้อง
- ✅ แก้ไขปัญหาได้ด้วยตัวเอง
- ✅ รายงานปัญหาได้อย่างเป็นระบบ

**เริ่มต้นด้วย [Quick Start Guide](./QUICK_START.md) เลย!**
