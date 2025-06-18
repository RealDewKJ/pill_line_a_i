# 🔧 Troubleshooting Guide - Unit Testing

## 🚨 ปัญหาที่พบบ่อยและวิธีแก้ไข

---

## 1. Mock Files ไม่มี

### อาการ

```
Target of URI doesn't exist: 'ex_notdata_bloc_test.mocks.dart'
Undefined class 'MockExNotDataRepository'
```

### วิธีแก้

```bash
# สร้าง mock files
flutter pub run build_runner build

# หรือลบไฟล์เก่าแล้วสร้างใหม่
flutter pub run build_runner clean
flutter pub run build_runner build
```

### วิธีป้องกัน

- รัน `build_runner` ทุกครั้งหลังแก้ไข `@GenerateMocks`
- ตรวจสอบว่า `build_runner` อยู่ใน `dev_dependencies`

---

## 2. LateInitializationError

### อาการ

```
LateInitializationError: Field '_animationController' has not been initialized
```

### วิธีแก้

**ใน Controller:**

```dart
// เปลี่ยนจาก
late AnimationController _animationController;

// เป็น
AnimationController? _animationController;

// และแก้ dispose()
@override
void dispose() {
  _stateSubscription?.cancel();
  _messageSubscription?.cancel();
  _animationController?.dispose(); // เพิ่ม ? check
  super.dispose();
}
```

**ใน Test:**

```dart
setUp(() {
  binding = TestWidgetsFlutterBinding.ensureInitialized();
  mockUseCase = MockVideoStreamUseCase();
  controller = VideoStreamController(mockUseCase);
  controller.initialize(binding); // เพิ่มการ initialize
});
```

---

## 3. Test Timeout

### อาการ

```
Test timed out after 30 seconds
```

### วิธีแก้

```dart
test('long running test', () async {
  // test code
}, timeout: Duration(seconds: 60));
```

หรือ

```dart
blocTest<MyBloc, MyState>(
  'test description',
  build: () => bloc,
  act: (bloc) => bloc.add(Event()),
  expect: () => [State()],
  timeout: Duration(seconds: 60),
);
```

---

## 4. Mock Verification Failed

### อาการ

```
No matching calls. All calls: []
```

### วิธีแก้

**ตรวจสอบ Mock Setup:**

```dart
setUp(() {
  mockRepository = MockExNotDataRepository();
  // ต้อง setup mock ก่อน
  when(mockRepository.getExNotData())
      .thenAnswer((_) async => Right(testData));
  bloc = ExNotDataBloc(repository: mockRepository);
});
```

**ตรวจสอบ Method Signature:**

```dart
// ต้องตรงกับ method จริง
when(mockRepository.getExNotData())
    .thenAnswer((_) async => Right(testData));

// ไม่ใช่
when(mockRepository.getExNotData(any))
    .thenAnswer((_) async => Right(testData));
```

---

## 5. Import Error

### อาการ

```
Target of URI doesn't exist: 'package:pill_line_a_i/...'
```

### วิธีแก้

```bash
# ตรวจสอบ dependencies
flutter pub get

# ตรวจสอบ import path
# ต้องตรงกับโครงสร้างโปรเจกต์
import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';
```

---

## 6. BLoC Test Error

### อาการ

```
blocTest: No states were emitted
```

### วิธีแก้

**ตรวจสอบ Event:**

```dart
blocTest<ExNotDataBloc, ExNotDataState>(
  'test description',
  build: () => bloc,
  act: (bloc) => bloc.add(LoadExNotData()), // ต้องตรงกับ event จริง
  expect: () => [ExNotDataLoading(), ExNotDataLoaded()],
);
```

**ตรวจสอบ State:**

```dart
// ต้องตรงกับ state ที่ emit จริง
expect: () => [
  ExNotDataLoading(),
  ExNotDataLoaded(testData),
],
```

---

## 7. Widget Test Error

### อาการ

```
RenderFlex overflowed by X pixels
```

### วิธีแก้

**เพิ่ม MediaQuery:**

```dart
testWidgets('widget test', (WidgetTester tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(800, 600)),
      child: MyWidget(),
    ),
  );
});
```

**หรือใช้ MaterialApp:**

```dart
testWidgets('widget test', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyWidget(),
    ),
  );
});
```

---

## 8. Async Test Error

### อาการ

```
Expected: <true>
  Actual: <false>
```

### วิธีแก้

**รอ async operation:**

```dart
test('async test', () async {
  final result = await someAsyncOperation();
  expect(result, true);
});
```

**สำหรับ Widget Test:**

```dart
testWidgets('async widget test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.pump(); // รอ frame
  await tester.pump(Duration(seconds: 1)); // รอเวลา
});
```

---

## 9. Coverage Report Error

### อาการ

```
No coverage data was collected
```

### วิธีแก้

```bash
# รัน test พร้อม coverage
flutter test --coverage

# ตรวจสอบไฟล์ coverage
ls coverage/
```

**หรือใช้ lcov:**

```bash
# ติดตั้ง lcov
flutter pub global activate lcov

# สร้าง report
genhtml coverage/lcov.info -o coverage/html
```

---

## 10. Build Runner Error

### อาการ

```
Build failed
```

### วิธีแก้

```bash
# ลบ cache
flutter clean
flutter pub get

# ลบ build files
flutter pub run build_runner clean

# สร้างใหม่
flutter pub run build_runner build
```

---

## 🔍 การ Debug

### 1. ใช้ print() ใน test

```dart
test('debug test', () {
  print('Debug info');
  expect(true, true);
});
```

### 2. ใช้ debugPrint

```dart
test('debug test', () {
  debugPrint('Debug info');
  expect(true, true);
});
```

### 3. ใช้ verbose mode

```bash
flutter test --verbose
```

### 4. ตรวจสอบ Stack Trace

```
Error: LateInitializationError
  at VideoStreamController.dispose (video_stream_controller.dart:310:5)
  at test_file.dart:28:18
```

---

## 📞 ขอความช่วยเหลือ

### ข้อมูลที่ต้องส่ง:

```
Error: [Error message]
File: [file path:line:column]
Test: [test file name]
Steps: [steps taken]
Environment: [Flutter version, OS]
```

### ตัวอย่าง:

```
Error: LateInitializationError: Field '_animationController' has not been initialized
File: video_stream_controller.dart:310:5
Test: video_stream_controller_test.dart
Steps: 1. flutter pub get 2. flutter test
Environment: Flutter 3.16.0, Windows 10
```

---

## 🎯 Best Practices

1. **แก้ปัญหาใน source code** ไม่ใช่ใน test
2. **ใช้ descriptive test names**
3. **แยก test cases ให้ชัดเจน**
4. **ใช้ setUp() และ tearDown()**
5. **mock external dependencies**
6. **ทดสอบทั้ง success และ error cases**

---

**💡 ข้อแนะนำ:** เริ่มจากปัญหาเล็กๆ ก่อน แล้วค่อยๆ แก้ปัญหาที่ซับซ้อนขึ้น
