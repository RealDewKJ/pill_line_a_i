# 📚 เอกสารคู่มือการทดสอบ - Pill Line AI

## 📖 สารบัญเอกสาร

### 🚀 [Quick Start Guide](./QUICK_START.md)

คู่มือเริ่มต้นด่วนสำหรับการทดสอบ Unit Tests

- ขั้นตอนการติดตั้ง (5 นาที)
- คำสั่งที่ใช้บ่อย
- การอ่านผลลัพธ์
- แก้ปัญหาด่วน

### 👨‍💻 [For Testers](./FOR_TESTERS.md)

คู่มือสำหรับ Tester โดยเฉพาะ

- ขั้นตอนการทดสอบ
- การอ่านผลลัพธ์
- การรายงานผล
- Checklist การทดสอบ

### 📋 [Testing Guide](./TESTING_GUIDE.md)

คู่มือการทดสอบแบบละเอียด

- ภาพรวมการทดสอบ
- โครงสร้างไฟล์ Test
- ประเภทการทดสอบ
- Best Practices
- ตัวอย่างการใช้งาน

### 🔧 [Troubleshooting Guide](./TROUBLESHOOTING.md)

คู่มือแก้ปัญหาที่พบบ่อย

- ปัญหา Mock Files
- LateInitializationError
- Test Timeout
- BLoC Test Error
- การ Debug

---

## 🎯 เริ่มต้นใช้งาน

### สำหรับ Tester

1. อ่าน [For Testers](./FOR_TESTERS.md) ก่อน
2. ทำตามขั้นตอนการทดสอบ
3. รายงานผลตามรูปแบบที่กำหนด

### สำหรับผู้เริ่มต้น

1. อ่าน [Quick Start Guide](./QUICK_START.md) ก่อน
2. ทำตามขั้นตอนการติดตั้ง
3. รัน test ครั้งแรก

### สำหรับผู้มีประสบการณ์

1. อ่าน [Testing Guide](./TESTING_GUIDE.md)
2. ดูตัวอย่างการใช้งาน
3. ปรับแต่งตามความต้องการ

### เมื่อเจอปัญหา

1. ดู [Troubleshooting Guide](./TROUBLESHOOTING.md)
2. หาปัญหาที่ตรงกับอาการ
3. ทำตามวิธีแก้ไข

---

## 📁 โครงสร้างเอกสาร

```
docs/
├── README.md                    # ไฟล์นี้ (สารบัญเอกสาร)
├── QUICK_START.md              # คู่มือเริ่มต้นด่วน
├── FOR_TESTERS.md              # คู่มือสำหรับ Tester
├── TESTING_GUIDE.md            # คู่มือการทดสอบแบบละเอียด
└── TROUBLESHOOTING.md          # คู่มือแก้ปัญหา
```

---

## 🔗 ลิงก์ที่เกี่ยวข้อง

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [BLoC Testing Documentation](https://bloclibrary.dev/#/testing)

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

เอกสารในโฟลเดอร์นี้จะช่วยให้คุณ:

- ✅ เข้าใจการทำงานของ Unit Tests
- ✅ รัน test ได้อย่างถูกต้อง
- ✅ แก้ปัญหาได้ด้วยตัวเอง
- ✅ พัฒนา test เพิ่มเติมได้
- ✅ รายงานผลการทดสอบได้อย่างเป็นระบบ

**เริ่มต้นด้วย [Quick Start Guide](./QUICK_START.md) หรือ [For Testers](./FOR_TESTERS.md) เลย!**
