# 💊 PillLine AI - ระบบจัดการสายการผลิตยา

## 📖 ภาพรวมโปรเจกต์

**PillLine AI** เป็นแอปพลิเคชัน Flutter ที่พัฒนาขึ้นเพื่อจัดการและควบคุมสายการผลิตยาแบบอัตโนมัติ โดยใช้เทคโนโลยี AI และ IoT เพื่อเพิ่มประสิทธิภาพและความแม่นยำในการผลิตยา

### 🎯 วัตถุประสงค์

- ควบคุมสายการผลิตยาอัตโนมัติ
- ตรวจสอบคุณภาพยาแบบ Real-time
- จัดการข้อมูลการผลิตและคลังสินค้า
- แสดงผลการผลิตผ่าน Video Stream
- รายงานสถิติการผลิต

---

## 🏗️ สถาปัตยกรรม

### Clean Architecture

โปรเจกต์ใช้ Clean Architecture แบ่งเป็น 3 ชั้น:

```
lib/
├── features/                    # Business Features
│   ├── ex_notdata/             # จัดการข้อมูลยา
│   ├── video_stream/           # Video Stream Management
│   ├── home/                   # หน้าหลัก
│   └── not_found/              # หน้า 404
├── core/                       # Core Components
│   └── di/                     # Dependency Injection
├── services/                   # External Services
│   ├── api/                    # API Services
│   ├── dio/                    # HTTP Client
│   └── ehp_endpoint/           # EHP API Integration
└── utils/                      # Utilities
```

### Features

- **ex_notdata**: จัดการข้อมูลยาและการตรวจสอบ
- **video_stream**: จัดการ Video Stream สำหรับตรวจสอบการผลิต
- **home**: หน้าหลักและ Dashboard
- **not_found**: จัดการ Error Pages

---

## 🛠️ เทคโนโลยีที่ใช้

### Frontend

- **Flutter** - UI Framework
- **Dart** - Programming Language
- **Flutter BLoC** - State Management
- **Provider** - Dependency Injection

### Backend Integration

- **Dio** - HTTP Client
- **WebSocket** - Real-time Communication
- **JWT** - Authentication
- **Encryption** - Data Security

### Testing

- **Flutter Test** - Unit Testing
- **Mockito** - Mocking Framework
- **BLoC Test** - BLoC Testing
- **Build Runner** - Code Generation

---

## 📱 ฟีเจอร์หลัก

### 1. 🎥 Video Stream Management

- Real-time video monitoring
- Zoom และ Pan controls
- Position management
- Connection status monitoring

### 2. 💊 Drug Data Management

- จัดการข้อมูลยา
- ตรวจสอบคุณภาพ
- รายงานสถิติ
- Error handling

### 3. 📊 Dashboard & Analytics

- แสดงข้อมูลการผลิตแบบ Real-time
- กราฟและสถิติ
- การแจ้งเตือน
- Export reports

### 4. 🔐 Security & Authentication

- JWT Authentication
- Data encryption
- Secure API communication
- Role-based access

---

## 🚀 การติดตั้งและรัน

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### ขั้นตอนการติดตั้ง

#### 1. Clone โปรเจกต์

```bash
git clone [repository-url]
cd pill_line_a_i
```

#### 2. ติดตั้ง Dependencies

```bash
flutter pub get
```

#### 3. สร้าง Mock Files (สำหรับ Testing)

```bash
flutter pub run build_runner build
```

#### 4. รันแอปพลิเคชัน

```bash
# Development
flutter run

# Production
flutter run --release
```

---

## 🧪 การทดสอบ

### รัน Unit Tests

```bash
# รัน test ทั้งหมด
flutter test

# รัน test เฉพาะ feature
flutter test test/features/ex_notdata/
flutter test test/features/video_stream/

# รัน test พร้อม coverage
flutter test --coverage
```

### เอกสารการทดสอบ

ดูเอกสารการทดสอบใน `docs/`:

- [Quick Start Guide](docs/QUICK_START.md)
- [Testing Guide](docs/TESTING_GUIDE.md)
- [For Testers](docs/FOR_TESTERS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

---

## 📁 โครงสร้างโปรเจกต์

```
pill_line_a_i/
├── lib/                         # Source Code
│   ├── features/               # Business Features
│   ├── core/                   # Core Components
│   ├── services/               # External Services
│   └── utils/                  # Utilities
├── test/                       # Test Files
│   ├── features/               # Feature Tests
│   └── widget_test.dart        # Widget Tests
├── docs/                       # Documentation
│   ├── README.md              # Documentation Index
│   ├── QUICK_START.md         # Quick Start Guide
│   ├── FOR_TESTERS.md         # Tester Guide
│   ├── TESTING_GUIDE.md       # Testing Guide
│   └── TROUBLESHOOTING.md     # Troubleshooting Guide
├── assets/                     # Assets
│   ├── images/                # Images
│   ├── fonts/                 # Fonts
│   └── jsons/                 # JSON Files
├── android/                    # Android Configuration
├── ios/                       # iOS Configuration
└── pubspec.yaml               # Dependencies
```

---

## 🔧 การพัฒนา

### Code Style

- ใช้ **Clean Architecture**
- ใช้ **BLoC Pattern** สำหรับ State Management
- ใช้ **Repository Pattern** สำหรับ Data Access
- ใช้ **Dependency Injection** สำหรับ Service Management

### Best Practices

- เขียน Unit Tests สำหรับทุก Feature
- ใช้ Mock Objects สำหรับ Testing
- แยก Business Logic ออกจาก UI
- ใช้ Error Handling ที่เหมาะสม

---

## 📊 การ Deploy

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

---

## 🤝 การมีส่วนร่วม

### การรายงาน Bug

1. ตรวจสอบ [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. สร้าง Issue พร้อมรายละเอียด:
   - ขั้นตอนการทำซ้ำ
   - Expected behavior
   - Actual behavior
   - Environment details

### การส่ง Pull Request

1. Fork โปรเจกต์
2. สร้าง Feature Branch
3. เขียน Unit Tests
4. รัน Tests ทั้งหมด
5. ส่ง Pull Request

---

## 📞 การติดต่อ

### ทีมพัฒนา

- **Project Manager**: [ชื่อ]
- **Lead Developer**: [Dew]
- **QA Team**: [ชื่อ]

### การขอความช่วยเหลือ

- ดู [Documentation](docs/README.md)
- สร้าง Issue ใน Repository
- ติดต่อทีมพัฒนาผ่าน [ช่องทาง]

---

## 📄 License

โปรเจกต์นี้เป็นส่วนหนึ่งของ [Bangkok Medical Software Co,Ltd] และใช้สำหรับการพัฒนาระบบจัดการสายการผลิตยา

---

## 🎉 สรุป

**PillLine AI** เป็นระบบที่ทันสมัยสำหรับการจัดการสายการผลิตยา โดยใช้เทคโนโลยี Flutter และ AI เพื่อเพิ่มประสิทธิภาพและความแม่นยำในการผลิต

**เริ่มต้นใช้งาน:**

1. ติดตั้งตาม [ขั้นตอนการติดตั้ง](#การติดตั้งและรัน)
2. อ่าน [เอกสารการทดสอบ](docs/README.md)
3. รันแอปพลิเคชันและเริ่มใช้งาน

---

**🚀 พร้อมใช้งานแล้ว!**
