# 📋 คู่มือการทดสอบ Unit Tests - Pill Line AI

## 📖 สารบัญ

1. [ภาพรวมการทดสอบ](#ภาพรวมการทดสอบ)
2. [การติดตั้งและเตรียมการ](#การติดตั้งและเตรียมการ)
3. [โครงสร้างไฟล์ Test](#โครงสร้างไฟล์-test)
4. [ประเภทการทดสอบ](#ประเภทการทดสอบ)
5. [วิธีการรัน Test](#วิธีการรัน-test)
6. [การอ่านผลลัพธ์](#การอ่านผลลัพธ์)
7. [การแก้ไขปัญหา](#การแก้ไขปัญหา)
8. [Best Practices](#best-practices)
9. [ตัวอย่างการใช้งาน](#ตัวอย่างการใช้งาน)

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

## 🛠️ การติดตั้งและเตรียมการ

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

### 3. สร้าง Mock Files

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
│   │   ├── ex_notdata_repository_impl_test.dart
│   │   └── ex_notdata_bloc_test.mocks.dart
│   └── video_stream/
│       ├── video_stream_entity_test.dart
│       ├── video_stream_controller_test.dart
│       └── video_stream_controller_test.mocks.dart
├── widget_test.dart
└── README.md
```

### ความหมายของแต่ละไฟล์:

- **`*_entity_test.dart`** - ทดสอบโครงสร้างข้อมูล
- **`*_bloc_test.dart`** - ทดสอบการจัดการ state
- **`*_controller_test.dart`** - ทดสอบ business logic
- **`*_repository_impl_test.dart`** - ทดสอบการจัดการข้อมูล
- **`*.mocks.dart`** - Mock objects (สร้างอัตโนมัติ)

---

## 🧪 ประเภทการทดสอบ

### 1. Entity Tests

ทดสอบโครงสร้างข้อมูลและ properties

```dart
test('should create VideoStreamEntity with default values', () {
  const entity = VideoStreamEntity();
  expect(entity.isConnected, false);
  expect(entity.scale, 1.0);
});
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
test('openVideoDialog should set showVideoDialog to true', () {
  controller.openVideoDialog();
  expect(controller.showVideoDialog, true);
});
```

### 4. BLoC Tests

ทดสอบ state transitions และ event handling

```dart
blocTest<MyBloc, MyState>(
  'emits [Loading, Loaded] when LoadData is successful',
  build: () => bloc,
  act: (bloc) => bloc.add(LoadData()),
  expect: () => [Loading(), Loaded()],
);
```

---

## 🚀 วิธีการรัน Test

### รัน Test ทั้งหมด

```bash
flutter test
```

### รัน Test เฉพาะ Feature

```bash
flutter test test/features/ex_notdata/
flutter test test/features/video_stream/
```

### รัน Test เฉพาะไฟล์

```bash
flutter test test/features/ex_notdata/ex_notdata_entity_test.dart
```

### รัน Test พร้อม Coverage

```bash
flutter test --coverage
```

### รัน Test แบบ Verbose

```bash
flutter test --verbose
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

- เพิ่ม `timeout: Duration(seconds: 60)` ใน test
- ตรวจสอบ async operations

#### 4. Mock Verification Failed

**อาการ:** `No matching calls. All calls: []`

**วิธีแก้:**

- ตรวจสอบว่า mock ถูก setup ถูกต้อง
- ตรวจสอบ method signature

---

## 💡 Best Practices

### 1. การตั้งชื่อ Test

```dart
// ✅ ดี - อธิบายสิ่งที่ทดสอบ
test('should return user data when login is successful', () {
  // test code
});

// ❌ ไม่ดี - ไม่ชัดเจน
test('test login', () {
  // test code
});
```

### 2. Arrange-Act-Assert Pattern

```dart
test('example test', () {
  // Arrange - เตรียมข้อมูล
  final controller = VideoStreamController(mockUseCase);

  // Act - ทำการทดสอบ
  controller.openVideoDialog();

  // Assert - ตรวจสอบผลลัพธ์
  expect(controller.showVideoDialog, true);
});
```

### 3. การใช้ Group

```dart
group('VideoStreamController', () {
  group('Video Dialog Management', () {
    test('openVideoDialog should set showVideoDialog to true', () {
      // test code
    });

    test('hideVideoDialog should set showVideoDialog to false', () {
      // test code
    });
  });
});
```

### 4. การ Mock Dependencies

```dart
setUp(() {
  mockUseCase = MockVideoStreamUseCase();
  controller = VideoStreamController(mockUseCase);
});

tearDown(() {
  controller.dispose();
});
```

---

## 📝 ตัวอย่างการใช้งาน

### ตัวอย่าง 1: ทดสอบ Entity

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';

void main() {
  group('ExNotData', () {
    test('should create ExNotData with correct properties', () {
      const exNotData = ExNotData(
        message: 'Test message',
        type: 'test',
        details: {'key': 'value'},
      );

      expect(exNotData.message, 'Test message');
      expect(exNotData.type, 'test');
      expect(exNotData.details, {'key': 'value'});
    });
  });
}
```

### ตัวอย่าง 2: ทดสอบ Controller

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([VideoStreamUseCase])
void main() {
  group('VideoStreamController', () {
    late MockVideoStreamUseCase mockUseCase;
    late VideoStreamController controller;

    setUp(() {
      mockUseCase = MockVideoStreamUseCase();
      controller = VideoStreamController(mockUseCase);
    });

    test('initial state should be correct', () {
      expect(controller.showVideoDialog, false);
      expect(controller.currentScale, 1.0);
    });
  });
}
```

### ตัวอย่าง 3: ทดสอบ BLoC

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ExNotDataBloc', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataBloc bloc;

    setUp(() {
      mockRepository = MockExNotDataRepository();
      bloc = ExNotDataBloc(repository: mockRepository);
    });

    blocTest<ExNotDataBloc, ExNotDataState>(
      'emits [Loading, Loaded] when LoadExNotData is successful',
      build: () {
        when(mockRepository.getExNotData())
            .thenAnswer((_) async => Right(testData));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExNotData()),
      expect: () => [ExNotDataLoading(), ExNotDataLoaded(testData)],
    );
  });
}
```

---

## 📞 การขอความช่วยเหลือ

### เมื่อเจอปัญหา:

1. **อ่าน Error Message** อย่างละเอียด
2. **ตรวจสอบ Stack Trace** เพื่อหาตำแหน่งปัญหา
3. **ดูตัวอย่างในคู่มือ** นี้
4. **ถามทีมพัฒนา** พร้อมข้อมูล:
   - Error message
   - ไฟล์ที่เกิดปัญหา
   - ขั้นตอนที่ทำ

### ข้อมูลที่ควรส่งเมื่อขอความช่วยเหลือ:

```
Error: LateInitializationError
File: video_stream_controller.dart:310
Test: video_stream_controller_test.dart
Steps: 1. flutter pub get 2. flutter test
```

---

## 🎉 สรุป

การทดสอบ Unit Tests ช่วยให้:

- ✅ โค้ดมีความน่าเชื่อถือ
- ✅ กล้าแก้ไขและปรับปรุงโค้ด
- ✅ ลดเวลาในการ debug
- ✅ เพิ่มความมั่นใจในการ deploy

**เริ่มต้นด้วยการรัน:**

```bash
flutter test
```

**และดูผลลัพธ์เพื่อเข้าใจสถานะของโปรเจกต์!**
