# 📋 คู่มือการทดสอบ Unit Tests - Pill Line AI

## 📖 สารบัญ

1. [ภาพรวมการทดสอบ](#ภาพรวมการทดสอบ)
2. [สำหรับ Tester](#สำหรับ-tester)
3. [การติดตั้งและเตรียมการ](#การติดตั้งและเตรียมการ)
4. [โครงสร้างไฟล์ Test](#โครงสร้างไฟล์-test)
5. [ประเภทการทดสอบ](#ประเภทการทดสอบ)
6. [วิธีการรัน Test](#วิธีการรัน-test)
7. [Mock Generation](#mock-generation)
8. [การอ่านผลลัพธ์](#การอ่านผลลัพธ์)
9. [การรายงานผล](#การรายงานผล)
10. [การแก้ไขปัญหา](#การแก้ไขปัญหา)
11. [Best Practices](#best-practices)
12. [ตัวอย่างการใช้งาน](#ตัวอย่างการใช้งาน)

---

## 🎯 ภาพรวมการทดสอบ

### วัตถุประสงค์

- ตรวจสอบความถูกต้องของโค้ด
- ป้องกันการเกิด bug ใหม่
- เพิ่มความมั่นใจในการ deploy
- เป็นเอกสารการใช้งานโค้ด

### สิ่งที่ทดสอบ

- **Entities** - โครงสร้างข้อมูล
- **Repositories** - การจัดการข้อมูล
- **Controllers** - ตรรกะการทำงาน
- **BLoCs** - การจัดการ state

---

## 👨‍💻 สำหรับ Tester

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

### 🚀 ขั้นตอนการทดสอบสำหรับ Tester

#### ขั้นตอนที่ 1: ดึงโปรเจกต์

```bash
# ถ้าใช้ Git
git clone [repository-url]
cd pill_line_a_i

# หรือถ้าได้รับไฟล์ zip
# แตกไฟล์และเปิด terminal ในโฟลเดอร์โปรเจกต์
```

#### ขั้นตอนที่ 2: ติดตั้ง Dependencies

```bash
flutter pub get
```

#### ขั้นตอนที่ 3: สร้าง Mock Files

```bash
flutter pub run build_runner build
```

#### ขั้นตอนที่ 4: รัน Test

```bash
flutter test
```

### 📊 การอ่านผลลัพธ์สำหรับ Tester

#### ✅ Test ผ่าน

```
✓ VideoStreamEntity should create VideoStreamEntity with default values
✓ VideoStreamController openVideoDialog should set showVideoDialog to true
✓ ExNotData should create ExNotData with correct properties
00:03 +3: All tests passed!
```

**หมายความ:** ทุก test ผ่าน ✅

#### ❌ Test ล้มเหลว

```
✗ VideoStreamController initial state should be correct
  Expected: true
    Actual: false
00:01 +2 -1: Some tests failed.
```

**หมายความ:** มี test ล้มเหลว 1 ตัว ❌

#### ⚠️ Test มี Error

```
LateInitializationError: Field '_animationController' has not been initialized.
  at VideoStreamController.dispose (video_stream_controller.dart:310:5)
```

**หมายความ:** มี error ในการรัน test ⚠️

### 🔍 การทดสอบเฉพาะส่วน

#### ทดสอบเฉพาะ Feature

```bash
# ทดสอบ ex_notdata feature
flutter test test/features/ex_notdata/

# ทดสอบ video_stream feature
flutter test test/features/video_stream/
```

#### ทดสอบเฉพาะไฟล์

```bash
# ทดสอบ entity
flutter test test/features/ex_notdata/ex_notdata_entity_test.dart

# ทดสอบ controller
flutter test test/features/video_stream/video_stream_controller_test.dart
```

#### ทดสอบแบบ Verbose

```bash
flutter test --verbose
```

### 📝 การรายงานผลสำหรับ Tester

#### ข้อมูลที่ต้องรายงาน

##### 1. สรุปผลการทดสอบ

```
✅ ผ่าน: X tests
❌ ล้มเหลว: Y tests
⚠️ Error: Z tests
รวม: X+Y+Z tests
```

##### 2. รายละเอียด Test ที่ล้มเหลว

```
Test: [ชื่อ test]
File: [ไฟล์ที่ล้มเหลว]
Error: [ข้อความ error]
Expected: [ค่าที่คาดหวัง]
Actual: [ค่าจริง]
```

##### 3. สิ่งแวดล้อม

```
Flutter Version: [เวอร์ชัน]
OS: [ระบบปฏิบัติการ]
Date: [วันที่ทดสอบ]
```

### 📋 Checklist การทดสอบสำหรับ Tester

#### ก่อนเริ่มทดสอบ

- [ ] ติดตั้ง Flutter SDK
- [ ] ดึงโปรเจกต์มาแล้ว
- [ ] เปิด terminal ในโฟลเดอร์โปรเจกต์
- [ ] รัน `flutter doctor` ผ่าน

#### ขั้นตอนการทดสอบ

- [ ] รัน `flutter pub get`
- [ ] รัน `flutter pub run build_runner build`
- [ ] รัน `flutter test`
- [ ] บันทึกผลลัพธ์

#### หลังการทดสอบ

- [ ] รายงานผลการทดสอบ
- [ ] แจ้งปัญหาที่พบ (ถ้ามี)
- [ ] ส่งข้อมูลตามรูปแบบที่กำหนด

---

## 🛠️ การติดตั้งและเตรียมการ

### Prerequisites

- Flutter SDK installed
- Dart SDK installed
- IDE with Flutter support (VS Code, Android Studio, etc.)

### 1. ตรวจสอบ Dependencies

เปิดไฟล์ `pubspec.yaml` และตรวจสอบว่ามี dependencies เหล่านี้:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  bloc_test: ^9.1.5
  build_runner: ^2.4.8
```

### 2. ติดตั้ง Dependencies

```bash
flutter pub get
```

### 3. สร้าง Mock Files (สำคัญ!)

```bash
flutter pub run build_runner build
```

---

## 📁 โครงสร้างไฟล์ Test

```
test/
├── features/
│   ├── ex_notdata/
│   │   ├── ex_notdata_entity_test.dart
│   │   ├── ex_notdata_bloc_test.dart
│   │   ├── ex_notdata_controller_test.dart
│   │   ├── ex_notdata_repository_impl_test.dart
│   │   └── ex_notdata_bloc_test.mocks.dart (auto-generated)
│   └── video_stream/
│       ├── video_stream_entity_test.dart
│       ├── video_stream_controller_test.dart
│       └── video_stream_controller_test.mocks.dart (auto-generated)
├── widget_test.dart
└── README.md
```

### ความหมายของแต่ละไฟล์:

- **`*_entity_test.dart`** - ทดสอบโครงสร้างข้อมูล
- **`*_bloc_test.dart`** - ทดสอบการจัดการ state
- **`*_controller_test.dart`** - ทดสอบ business logic
- **`*_repository_impl_test.dart`** - ทดสอบการจัดการข้อมูล
- **`*.mocks.dart`** - Mock objects (สร้างอัตโนมัติ)

### Test File Naming Convention

- `*_test.dart` - Test files
- `*_test.mocks.dart` - Auto-generated mock files (don't edit)

---

## 🧪 ประเภทการทดสอบ

### 1. Entity Tests

ทดสอบโครงสร้างข้อมูลและ properties

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';

void main() {
  group('ExNotData Entity', () {
    test('should create ExNotData instance', () {
      // Arrange
      const message = 'test_message';
      const type = 'test_type';
      const details = {'key': 'value'};

      // Act
      final exNotData = ExNotData(
        message: message,
        type: type,
        details: details,
      );

      // Assert
      expect(exNotData.message, equals(message));
      expect(exNotData.type, equals(type));
      expect(exNotData.details, equals(details));
    });

    test('should support equality', () {
      // Arrange
      const exNotData1 = ExNotData(
        message: 'test',
        type: 'type',
        details: {'key': 'value'},
      );
      const exNotData2 = ExNotData(
        message: 'test',
        type: 'type',
        details: {'key': 'value'},
      );
      const exNotData3 = ExNotData(
        message: 'different',
        type: 'type',
        details: {'key': 'value'},
      );

      // Assert
      expect(exNotData1, equals(exNotData2));
      expect(exNotData1, isNot(equals(exNotData3)));
    });
  });
}
```

### 2. Repository Tests

ทดสอบการจัดการข้อมูลและ error handling

```dart
test('should return data when successful', () async {
  when(mockDataSource.getData()).thenAnswer((_) async => testData);
  final result = await repository.getData();
  expect(result, Right(testData));
});
```

### 3. Controller Tests

ทดสอบ business logic และ UI state

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/controllers/ex_notdata_controller.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  group('ExNotDataController', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataController controller;

    setUp(() {
      mockRepository = MockExNotDataRepository();
      controller = ExNotDataController(repository: mockRepository);
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize WebSocket connection', () async {
      // Arrange
      when(mockRepository.initializeWebSocket())
          .thenAnswer((_) async => true);

      // Act
      await controller.initialize();

      // Assert
      verify(mockRepository.initializeWebSocket()).called(1);
      expect(controller.isConnected, isTrue);
    });
  });
}
```

### 4. BLoC Tests

ทดสอบ state transitions และ event handling

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  group('ExNotDataBloc', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataBloc bloc;

    setUp(() {
      mockRepository = MockExNotDataRepository();
      bloc = ExNotDataBloc(repository: mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be ExNotDataInitial', () {
      expect(bloc.state, isA<ExNotDataInitial>());
    });

    blocTest<ExNotDataBloc, ExNotDataState>(
      'emits [ExNotDataLoading, ExNotDataLoaded] when LoadExNotData is successful',
      build: () {
        when(mockRepository.getExNotData())
            .thenAnswer((_) async => Right(testData));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExNotData()),
      expect: () => [
        isA<ExNotDataLoading>(),
        isA<ExNotDataLoaded>(),
      ],
    );

    blocTest<ExNotDataBloc, ExNotDataState>(
      'emits [ExNotDataLoading, ExNotDataError] when LoadExNotData fails',
      build: () {
        when(mockRepository.getExNotData())
            .thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExNotData()),
      expect: () => [
        isA<ExNotDataLoading>(),
        isA<ExNotDataError>(),
      ],
    );
  });
}
```

---

## 🚀 วิธีการรัน Test

### Basic Commands

```bash
# รัน test ทั้งหมด
flutter test

# รัน test แบบ watch mode (auto-rerun on changes)
flutter test --watch

# รัน test เฉพาะไฟล์
flutter test test/features/ex_notdata/ex_notdata_bloc_test.dart

# รัน test พร้อม coverage
flutter test --coverage
```

### รัน Test เฉพาะ Feature

```bash
flutter test test/features/ex_notdata/
flutter test test/features/video_stream/
```

### Using Test Scripts (Windows)

```bash
# รัน test runner script
scripts/test.bat
```

### Using VS Code

1. Install the "Flutter" extension
2. Open test file
3. Click "Run Test" above test functions
4. Or use Command Palette: `Flutter: Run All Tests`

---

## 🔄 Mock Generation

### ⚠️ **สำคัญ: การจัดการ Mock Files**

**❌ อย่าสร้าง mock files เอง**

```dart
// อย่าทำแบบนี้
class MockExNotDataRepository extends Mock implements ExNotDataRepository {}
```

**✅ ใช้ Build Runner**

```dart
// ในไฟล์ test
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  // Build Runner จะสร้าง MockExNotDataRepository อัตโนมัติ
}
```

### Build Runner Commands

```bash
# สร้าง mocks ครั้งเดียว
flutter pub run build_runner build

# สร้าง mocks แบบ watch mode (แนะนำสำหรับการพัฒนา)
flutter pub run build_runner watch

# ลบ mocks เก่าและสร้างใหม่
flutter pub run build_runner clean
flutter pub run build_runner build

# Force rebuild (เมื่อมีปัญหา)
flutter pub run build_runner build --delete-conflicting-outputs
```

### เมื่อไหร่ควรสร้าง Mocks ใหม่

- ✅ หลังจากเพิ่ม class ใหม่ใน `@GenerateMocks`
- ✅ หลังจากเปลี่ยน class signatures
- ✅ หลังจากเพิ่ม dependencies ใหม่
- ✅ เมื่อเจอ error "Mock not found"

### ปัญหาที่พบบ่อยและวิธีแก้

#### ปัญหา: "Mock class not found"

```bash
# วิธีแก้: สร้าง mocks ใหม่
flutter pub run build_runner build
```

#### ปัญหา: "Conflicting outputs"

```bash
# วิธีแก้: Force rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

#### ปัญหา: "Old mock files"

```bash
# วิธีแก้: ลบและสร้างใหม่
flutter pub run build_runner clean
flutter pub run build_runner build
```

---

## 📊 การอ่านผลลัพธ์

### ผลลัพธ์ที่ผ่าน (Success)

```
✓ VideoStreamEntity should create VideoStreamEntity with default values
✓ VideoStreamController openVideoDialog should set showVideoDialog to true
00:02 +2: All tests passed!
```

### ผลลัพธ์ที่ล้มเหลว (Failure)

```
✗ VideoStreamController initial state should be correct
  Expected: true
    Actual: false
00:01 +1 -1: Some tests failed.
```

### การอ่าน Error Messages

```
LateInitializationError: Field '_animationController' has not been initialized.
  at VideoStreamController.dispose (video_stream_controller.dart:310:5)
```

**การแปลความหมาย:**

- `LateInitializationError` - ตัวแปรที่ประกาศ `late` ยังไม่ได้ถูก initialize
- `video_stream_controller.dart:310:5` - ไฟล์:บรรทัด:คอลัมน์
- `VideoStreamController.dispose` - method ที่เกิดปัญหา

---

## 📝 การรายงานผล

### สำหรับ Developer

#### ข้อมูลที่ต้องรายงาน

##### 1. สรุปผลการทดสอบ

```
✅ ผ่าน: X tests
❌ ล้มเหลว: Y tests
⚠️ Error: Z tests
รวม: X+Y+Z tests
```

##### 2. รายละเอียด Test ที่ล้มเหลว

```
Test: [ชื่อ test]
File: [ไฟล์ที่ล้มเหลว]
Error: [ข้อความ error]
Expected: [ค่าที่คาดหวัง]
Actual: [ค่าจริง]
```

##### 3. สิ่งแวดล้อม

```
Flutter Version: [เวอร์ชัน]
OS: [ระบบปฏิบัติการ]
Date: [วันที่ทดสอบ]
```

### สำหรับ Tester

#### ข้อมูลที่ต้องรายงาน

##### 1. สรุปผลการทดสอบ

```
✅ ผ่าน: X tests
❌ ล้มเหลว: Y tests
⚠️ Error: Z tests
รวม: X+Y+Z tests
```

##### 2. รายละเอียด Test ที่ล้มเหลว

```
Test: [ชื่อ test]
File: [ไฟล์ที่ล้มเหลว]
Error: [ข้อความ error]
Expected: [ค่าที่คาดหวัง]
Actual: [ค่าจริง]
```

##### 3. สิ่งแวดล้อม

```
Flutter Version: [เวอร์ชัน]
OS: [ระบบปฏิบัติการ]
Date: [วันที่ทดสอบ]
```

---

## 🔧 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

#### 1. Mock Files ไม่มี

**อาการ:** `Target of URI doesn't exist: '*.mocks.dart'`

**วิธีแก้:**

```bash
flutter pub run build_runner build
```

#### 2. LateInitializationError

**อาการ:** `Field '_field' has not been initialized`

**วิธีแก้:**

- เปลี่ยนจาก `late` เป็น nullable
- เพิ่ม null check ก่อนใช้งาน

#### 3. Test Timeout

**อาการ:** `Test timed out after 30 seconds`

**วิธีแก้:**

```dart
test('should complete within 5 seconds', () async {
  // test code
}, timeout: Timeout(Duration(seconds: 5)));
```

#### 4. Mock Verification Failed

**อาการ:** `No matching calls. All calls: []`

**วิธีแก้:**

- ตรวจสอบว่า mock ถูก setup ถูกต้อง
- ตรวจสอบ method signature

#### 5. Build Runner conflicts

**อาการ:** `Conflicting outputs`

**วิธีแก้:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Performance Tips

- ใช้ `flutter test --coverage` เพื่อตรวจสอบ test coverage
- รัน tests แบบ parallel: `flutter test --concurrency=4`
- ใช้ `--reporter=compact` เพื่อ output ที่เร็วขึ้น

### Debugging Tests

```bash
# รันแบบ verbose
flutter test --verbose

# รัน test เฉพาะพร้อม debug info
flutter test test/features/ex_notdata/ex_notdata_bloc_test.dart --verbose
```

---

## 📋 Best Practices

### 1. Test Organization

- ใช้ `group()` เพื่อจัดกลุ่ม tests ที่เกี่ยวข้อง
- ใช้ชื่อ test ที่อธิบายได้
- ใช้ AAA pattern (Arrange, Act, Assert)

### 2. Mock Usage

- ใช้ `@GenerateMocks` annotation เสมอ
- อย่าสร้าง mock classes เอง
- ใช้ `when()` เพื่อกำหนด mock behavior
- ใช้ `verify()` เพื่อตรวจสอบ mock interactions

### 3. Test Data

- ใช้ constants สำหรับ test data
- สร้าง factory methods สำหรับ objects ที่ซับซ้อน
- ใช้ `setUp()` และ `tearDown()` สำหรับ setup ที่ใช้ร่วมกัน

### 4. Assertions

- ใช้ specific matchers (`equals`, `isA`, `isTrue`)
- ทดสอบทั้ง positive และ negative cases
- ตรวจสอบ error handling

---

## 📚 ตัวอย่างการใช้งาน

### การเขียน Test แบบสมบูรณ์

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  group('ExNotDataBloc', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataBloc bloc;

    setUp(() {
      mockRepository = MockExNotDataRepository();
      bloc = ExNotDataBloc(repository: mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be ExNotDataInitial', () {
      expect(bloc.state, isA<ExNotDataInitial>());
    });

    blocTest<ExNotDataBloc, ExNotDataState>(
      'emits [ExNotDataLoading, ExNotDataLoaded] when LoadExNotData is successful',
      build: () {
        when(mockRepository.getExNotData())
            .thenAnswer((_) async => Right(testData));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExNotData()),
      expect: () => [
        isA<ExNotDataLoading>(),
        isA<ExNotDataLoaded>(),
      ],
    );

    blocTest<ExNotDataBloc, ExNotDataState>(
      'emits [ExNotDataLoading, ExNotDataError] when LoadExNotData fails',
      build: () {
        when(mockRepository.getExNotData())
            .thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExNotData()),
      expect: () => [
        isA<ExNotDataLoading>(),
        isA<ExNotDataError>(),
      ],
    );
  });
}
```

---

## 🔗 ลิงก์ที่เกี่ยวข้อง

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Bloc Testing Documentation](https://bloclibrary.dev/#/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Build Runner Documentation](https://pub.dev/packages/build_runner)

---

## 📞 การขอความช่วยเหลือ

### เมื่อต้องการความช่วยเหลือ:

1. **อ่านเอกสาร** ในโฟลเดอร์นี้ก่อน
2. **ตรวจสอบ Troubleshooting Guide** สำหรับปัญหาที่พบบ่อย
3. **ส่งข้อมูล** ตามรูปแบบที่กำหนดในเอกสาร

### ข้อมูลที่ต้องส่ง:

```
Error: [Error message]
File: [file path:line:column]
Test: [test file name]
Steps: [steps taken]
Environment: [Flutter version, OS]
```

---

## 🎉 สรุป

คู่มือนี้จะช่วยให้คุณ:

- ✅ เข้าใจการทำงานของ Unit Tests
- ✅ รัน test ได้อย่างถูกต้อง
- ✅ แก้ปัญหาได้ด้วยตัวเอง
- ✅ พัฒนา test เพิ่มเติมได้
- ✅ รายงานผลการทดสอบได้อย่างเป็นระบบ

**เริ่มต้นด้วย [Quick Start Guide](./QUICK_START.md) เลย!**
