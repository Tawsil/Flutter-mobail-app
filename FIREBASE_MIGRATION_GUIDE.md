# 🔥 دليل الترحيل إلى Firebase

## ✅ التغييرات التي تم إجراؤها

### 1. تحديث موديل المستخدم (`lib/models/user.dart`)

**التغييرات:**
- ✅ إضافة حقل `uid` (Firebase Auth UID)
- ✅ إضافة حقل `email` (للمصادقة مع Firebase)
- ✅ جعل `password` اختياري (Firebase Auth يدير كلمات المرور)
- ✅ إضافة دالة `toFirestore()` للتوافق مع Firestore
- ✅ تحديث `fromMap()` لدعم تنسيقات البيانات المختلفة

### 2. إنشاء خدمة Firestore (`lib/services/firestore_service.dart`)

**الميزات:**
- ✅ استبدال جميع عمليات SQLite بـ Firestore
- ✅ دوال للمستخدمين (إنشاء، قراءة، تحديث، حذف)
- ✅ دوال للشهداء (إضافة، قراءة، تحديث، حذف)
- ✅ دوال للجرحى (إضافة، قراءة، تحديث، حذف)
- ✅ دوال للأسرى (إضافة، قراءة، تحديث، حذف)
- ✅ دالة للإحصائيات
- ✅ دوال تحويل البيانات من/إلى Firestore

### 3. تحديث خدمة المصادقة (`lib/services/auth_service.dart`)

**التغييرات:**
- ✅ استخدام Firebase Authentication بدلاً من قاعدة البيانات المحلية
- ✅ تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
- ✅ إنشاء حسابات جديدة عبر Firebase Auth
- ✅ تحديث كلمة المرور عبر Firebase
- ✅ إضافة دالة إعادة تعيين كلمة المرور عبر البريد الإلكتروني
- ✅ معالجة أخطاء Firebase Auth برسائل عربية واضحة

---

## ⚠️ **مهم جداً: تغييرات يجب إجراؤها في الكود**

### المشكلة:
الكود الحالي يستخدم `addedByUserId` كـ `int` في الموديلات، لكن Firebase Auth يستخدم `String` (UID).

### الحل:
يجب تحديث جميع الملفات التي تستخدم `addedByUserId` من `int` إلى `String`.

**الملفات المتأثرة:**
1. ✅ `lib/services/firestore_service.dart` - **تم التعديل** (يحول String إلى int للتوافق المؤقت)
2. ⚠️ `lib/screens/` - **يحتاج تحديث** (جميع الشاشات التي تستخدم userId)
3. ⚠️ `lib/blocs/` أو `lib/cubits/` - **يحتاج تحديث** (إذا وجدت)

---

## 📝 الخطوات التالية المطلوبة

### 1. إنشاء مستخدم Admin في Firestore

نظراً لأن Firebase Auth لا يدعم إنشاء مستخدم افتراضي عند الإعداد الأول، يجب إنشاء مستخدم Admin يدوياً.

#### الطريقة الأولى: عبر Firebase Console (موصى بها)

1. **افتح Firebase Console**
   - اذهب إلى: https://console.firebase.google.com
   - اختر مشروعك

2. **أضف مستخدم في Authentication**
   - من القائمة الجانبية، اختر **Authentication**
   - انقر على تبويب **Users**
   - انقر على **Add user**
   - أدخل البيانات:
     - Email: `admin@palestine.com`
     - Password: `admin123456` (أو أي كلمة مرور قوية)
   - انقر **Add user**
   - **احفظ الـ UID** الذي ظهر (سنحتاجه في الخطوة التالية)

3. **أضف بيانات المستخدم في Firestore**
   - من القائمة الجانبية، اختر **Firestore Database**
   - اختر مجموعة **users**
   - انقر على **Add document**
   - **مهم جداً:** في حقل "Document ID"، استخدم نفس الـ UID من الخطوة السابقة
   - أضف الحقول التالية:
     ```
     email: admin@palestine.com (string)
     username: admin (string)
     fullName: المسؤول العام (string)
     userType: admin (string)
     createdAt: [اختر Timestamp واختر التاريخ الحالي] (timestamp)
     phoneNumber: (اختياري) (string)
     ```
   - انقر **Save**

#### الطريقة الثانية: برمجياً (للتطوير فقط)

يمكنك إنشاء شاشة مؤقتة لإنشاء مستخدم Admin، ثم حذفها بعد الاستخدام.

### 2. تحديث شاشات تسجيل الدخول والتسجيل

**يجب تحديث:**
- `lib/screens/login_screen.dart`
- `lib/screens/register_screen.dart`

**التغييرات المطلوبة:**
```dart
// من:
await authService.login(username, password);

// إلى:
await authService.login(email, password);
```

```dart
// من:
await authService.register(
  username: username,
  password: password,
  fullName: fullName,
);

// إلى:
await authService.register(
  email: email,
  password: password,
  fullName: fullName,
  username: username, // اختياري
);
```

### 3. تحديث استخدام `userId` في التطبيق

ابحث عن جميع الأماكن التي تستخدم `getCurrentUserId()` وتأكد من أنها تتعامل مع `String` بدلاً من `int`.

```dart
// من:
final userId = await authService.getCurrentUserId(); // int?

// إلى:
final userId = await authService.getCurrentUserId(); // String?
```

### 4. اختبار التطبيق

**خطوات الاختبار:**
1. ✅ تسجيل مستخدم جديد
2. ✅ تسجيل الدخول
3. ✅ إضافة شهيد/جريح/أسير
4. ✅ عرض القوائم
5. ✅ تحديث البيانات
6. ✅ حذف البيانات
7. ✅ تسجيل الخروج

### 5. تنظيف الكود القديم (اختياري)

بعد التأكد من أن كل شيء يعمل بشكل صحيح، يمكنك:
- حذف `lib/services/database_service.dart` (قاعدة البيانات المحلية القديمة)
- إزالة تبعية `sqflite` من `pubspec.yaml`

---

## 🔒 قواعد الأمان في Firestore

**⚠️ مهم:** حالياً، قاعدة البيانات في "Test Mode" وتسمح بالوصول للجميع لمدة 30 يوماً.

**يجب تحديث قواعد الأمان قبل الإنتاج!**

### قواعد الأمان الموصى بها:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // قواعد للمستخدمين
    match /users/{userId} {
      // السماح بالقراءة للمستخدم المسجل فقط
      allow read: if request.auth != null && request.auth.uid == userId;
      // السماح بالكتابة للمستخدم نفسه فقط
      allow write: if request.auth != null && request.auth.uid == userId;
      // السماح للأدمن بقراءة كل المستخدمين
      allow read: if request.auth != null && 
                    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin';
    }
    
    // قواعد للشهداء
    match /martyrs/{martyrId} {
      // السماح بالقراءة للجميع المسجلين
      allow read: if request.auth != null;
      // السماح بالإضافة للمستخدمين المسجلين
      allow create: if request.auth != null;
      // السماح بالتحديث للمستخدم الذي أضاف البيانات أو الأدمن
      allow update, delete: if request.auth != null && 
        (resource.data.added_by_user_id == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
    
    // نفس القواعد للجرحى
    match /injured/{injuredId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.added_by_user_id == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
    
    // نفس القواعد للأسرى
    match /prisoners/{prisonerId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.added_by_user_id == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
  }
}
```

### كيفية تطبيق قواعد الأمان:

1. افتح Firebase Console
2. اذهب إلى **Firestore Database**
3. اختر تبويب **Rules**
4. الصق القواعد أعلاه
5. انقر **Publish**

---

## 📊 مقارنة بين SQLite و Firestore

| الميزة | SQLite (القديم) | Firestore (الجديد) |
|--------|----------------|-------------------|
| **التخزين** | محلي على الجهاز | سحابي (Cloud) |
| **المزامنة** | غير متوفرة | تلقائية في الوقت الفعلي |
| **الوصول من أجهزة متعددة** | ❌ غير ممكن | ✅ ممكن |
| **النسخ الاحتياطي** | يدوي | تلقائي |
| **الأمان** | محلي فقط | قواعد أمان قوية |
| **الأداء مع البيانات الكبيرة** | محدود | ممتاز |
| **التكلفة** | مجاني | مجاني (حتى حد معين) |

---

## 🎯 الخلاصة

تم ترحيل التطبيق بنجاح من SQLite إلى Firebase! 🎉

**ما تبقى:**
1. ✅ إنشاء مستخدم Admin في Firestore
2. ⚠️ تحديث شاشات تسجيل الدخول/التسجيل
3. ⚠️ اختبار جميع الوظائف
4. ⚠️ تحديث قواعد الأمان قبل الإنتاج

**إذا واجهت أي مشاكل، تحقق من:**
- Firebase Console للتأكد من إعداد المشروع بشكل صحيح
- `android/app/google-services.json` و `ios/Runner/GoogleService-Info.plist`
- الاتصال بالإنترنت

---

## 🆘 المساعدة

إذا واجهت أي مشكلة:
1. تحقق من سجلات الأخطاء (Logs)
2. تأكد من أن Firebase مهيأ بشكل صحيح
3. راجع [وثائق Firebase](https://firebase.google.com/docs)

**حظاً موفقاً! 🚀**
