# Unit Testing Guide

## การทดสอบ Unit Tests สำหรับ Pill Line AI

### โครงสร้างการทดสอบ

```
test/
├── features/
│   ├── ex_notdata/
│   │   ├── ex_notdata_entity_test.dart
│   │   ├── ex_notdata_bloc_test.dart
│   │   └── ex_notdata_repository_impl_test.dart
│   └── video_stream/
│       ├── video_stream_entity_test.dart
│       └── video_stream_controller_test.dart
└── README.md
```

### การติดตั้ง Dependencies

เพิ่ม dependencies ต่อไปนี้ใน `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  bloc_test: ^9.1.5
  build_runner: ^2.4.8
```

### การรัน Tests

1. **ติดตั้ง dependencies:**

   ```bash
   flutter pub get
   ```

2. **สร้าง mock files:**

   ```bash
   flutter packages pub run build_runner build
   ```

3. **รัน tests ทั้งหมด:**

   ```bash
   flutter test
   ```

4. **รัน test เฉพาะ feature:**
   ```bash
   flutter test test/features/ex_notdata/
   flutter test test/features/video_stream/
   ```

### ประเภทการทดสอบ

#### 1. Entity Tests

- ทดสอบการสร้าง objects
- ทดสอบ equality และ comparison
- ทดสอบ methods และ properties

#### 2. Repository Tests

- ทดสอบการเรียกใช้ data sources
- ทดสอบ error handling
- ทดสอบ data transformation

#### 3. BLoC Tests

- ทดสอบ state transitions
- ทดสอบ event handling
- ทดสอบ business logic

#### 4. Controller Tests

- ทดสอบ UI state management
- ทดสอบ user interactions
- ทดสอบ lifecycle methods

### Best Practices

1. **ใช้ Arrange-Act-Assert pattern**
2. **Mock external dependencies**
3. **ทดสอบทั้ง success และ error cases**
4. **ใช้ descriptive test names**
5. **แยก test groups ตาม functionality**

### ตัวอย่างการทดสอบ

ดูไฟล์ test ที่สร้างไว้เป็นตัวอย่าง:

- `ex_notdata_entity_test.dart` - Entity testing
- `ex_notdata_bloc_test.dart` - BLoC testing
- `video_stream_controller_test.dart` - Controller testing
