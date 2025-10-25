# 🇵🇸 Palestine Martyrs Documentation System - Firebase Edition

نظام توثيق الشهداء والجرحى والأسرى الفلسطينيين - تطبيق موبايل مع قاعدة بيانات سحابية متقدمة

> **🎉 تحديث كبير:** تم التحويل الكامل من SQLite إلى Firebase Firestore!  
> **رقم الكوميت:** 60a1778  
> **التاريخ:** 2025-10-25

## 📱 مميزات التطبيق

### 🔐 نظام المصادقة
- تسجيل دخول آمن للمستخدمين والمسؤولين
- إنشاء حسابات جديدة مع مستويات صلاحية مختلفة
- نظام JWT للحماية والأمان

### 📊 إدارة البيانات
- **توثيق الشهداء**: إضافة وإدارة بيانات الشهداء مع الصور والوثائق
- **توثيق الجرحى**: تسجيل حالات الإصابة والعلاج
- **توثيق الأسرى**: متابعة أوضاع المعتقلين والأسرى

### 🌐 العمل المتصل والمنقطع
- **وضع متصل**: مزامنة فورية مع Firebase Firestore السحابية
- **وضع منقطع**: العمل بدون إنترنت مع المزامنة اللاحقة
- **مزامنة تلقائية**: نقل البيانات عند استعادة الاتصال
- **قاعدة بيانات حقيقية**: بيانات سحابية متاحة من أي جهاز

### 🔥 Firebase Integration
- **Firebase Firestore**: قاعدة بيانات NoSQL سحابية
- **Firebase Authentication**: مصادقة آمنة مع Google وEmail
- **Real-time Sync**: مزامنة فورية للبيانات
- **Security Rules**: حماية شاملة للبيانات الحساسة
- **Cloud Functions**: إدارة متقدمة للأدوار والصلاحيات

### 👨‍💼 لوحة تحكم إدارية
- مراجعة وتصديق البيانات المرسلة
- إحصائيات شاملة ومفصلة
- إدارة المستخدمين والصلاحيات

## 🏗️ البنية التقنية

### 📱 التطبيق (Flutter)
```
lib/
├── services/              # خدمات قاعدة البيانات
│   ├── firebase_database_service.dart  # خدمة Firebase الرئيسية
│   ├── statistics_service.dart         # حساب الإحصائيات
│   └── advanced_search_service.dart    # البحث المتقدم
├── models/                # نماذج البيانات
│   ├── user.dart          # نموذج المستخدم
│   ├── martyr.dart        # نموذج الشهيد
│   ├── injured.dart       # نموذج الجريح
│   └── prisoner.dart      # نموذج الأسير
├── screens/               # واجهات المستخدم
│   ├── firebase_test_screen.dart      # اختبار Firebase
│   └── statistics_screen.dart        # شاشة الإحصائيات
├── utils/                 # أدوات مساعدة
│   └── sample_data_generator.dart    # مولد البيانات التجريبية
└── constants/             # الثوابت والإعدادات
    └── app_constants.dart
```

### 🖥️ الخادم (FastAPI)
```
backend/
├── main.py           # تطبيق FastAPI الرئيسي
├── models.py         # نماذج قاعدة البيانات
├── schemas.py        # تحقق من البيانات
├── database.py       # إعدادات قاعدة البيانات
├── config.py         # إعدادات التطبيق
├── templates/        # لوحة التحكم الإدارية
└── uploads/          # ملفات المستخدمين المرفوعة
```

## 🚀 طريقة التشغيل

### 📋 المتطلبات المسبقة
- **Flutter SDK** (3.0.0+)
- **Firebase Account** (للقاعدة السحابية)
- **Google Services JSON** (من Firebase Console)

### 🔧 إعداد التطبيق

1. **تحميل المشروع**
```bash
git clone <repository-url>
cd palestine_martyrs
```

2. **تنصيب dependencies**
```bash
flutter pub get
```

3. **تشغيل التطبيق**
```bash
flutter run
```

### 🔥 إعداد Firebase

1. **إنشاء Firebase Project**
   - اذهب إلى [Firebase Console](https://console.firebase.google.com/)
   - أنشئ مشروع جديد: `palestine-martyrs-db`
   - فعّل Firestore Database
   - فعّل Authentication

2. **تحميل google-services.json**
   - من Firebase Console
   - ضعه في `android/app/google-services.json`

3. **تطبيق Security Rules**
   ```bash
   # انسخ القواعد من:
   firestore_security_rules.txt
   ```

4. **اختبار النظام**
   ```dart
   // أضف شاشة الاختبار
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => FirebaseTestScreen()),
   );
   ```

### 📋 الوثائق الشاملة

| الملف | الوصف | الحالة |
|-------|---------|--------|
| `FIREBASE_SETUP_GUIDE.md` | دليل شامل لإعداد Firebase | ✅ |
| `FIREBASE_QUICK_SETUP.md` | دليل سريع في 15 دقيقة | ✅ |
| `FIREBASE_COMPLETE_REPORT.md` | تقرير نهائي شامل | ✅ |
| `firestore_security_rules.txt` | قواعد الأمان | ✅ |
| `firebase_cloud_functions.js` | Cloud Functions | ✅ |
| `firebase_test_service.dart` | خدمة اختبار | ✅ |

### 🖥️ إعداد الخادم (للمستقبل)

1. **الانتقال لمجلد الخادم**
```bash
cd backend
```

2. **إنشاء بيئة افتراضية**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate     # Windows
```

3. **تنصيب المتطلبات**
```bash
pip install -r requirements.txt
```

4. **إعداد متغيرات البيئة**
```bash
cp .env.example .env
# قم بتحرير .env وإضافة البيانات المطلوبة
```

5. **تشغيل الخادم**
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 🌐 النشر على Railway

1. **إنشاء حساب على Railway.app**
2. **ربط المستودع بـ Railway**
3. **إضافة PostgreSQL database**
4. **تحديث متغيرات البيئة في Railway**
5. **النشر التلقائي**

## 📡 API Endpoints

### 🔐 Authentication
- `POST /auth/login` - تسجيل الدخول
- `POST /auth/register` - إنشاء حساب جديد
- `GET /auth/me` - معلومات المستخدم الحالي

### 👥 Martyrs
- `GET /martyrs` - قائمة الشهداء
- `POST /martyrs` - إضافة شهيد جديد
- `PUT /martyrs/{id}/status` - تحديث حالة الشهيد

### 🏥 Injured
- `GET /injured` - قائمة الجرحى
- `POST /injured` - إضافة جريح جديد
- `PUT /injured/{id}/status` - تحديث حالة الجريح

### 🔒 Prisoners
- `GET /prisoners` - قائمة الأسرى
- `POST /prisoners` - إضافة أسير جديد
- `PUT /prisoners/{id}/status` - تحديث حالة الأسير

### 📎 File Upload
- `POST /upload/photo` - رفع صورة
- `POST /upload/document` - رفع وثيقة

### 📊 Admin
- `GET /admin/stats` - الإحصائيات العامة
- `GET /admin/users` - قائمة المستخدمين

## 🔧 الإعدادات والتكوين

### 📱 إعدادات التطبيق
```dart
// lib/services/api_service.dart
static const String baseUrl = 'https://your-backend-url.railway.app';
```

### 🖥️ إعدادات الخادم
```python
# backend/.env
DATABASE_URL=postgresql://user:password@host:port/database
JWT_SECRET_KEY=your-secret-key
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=your-email@gmail.com
```

## 🎨 واجهة المستخدم

### 📱 التطبيق
- تصميم عصري ومتجاوب
- دعم اللغة العربية والاتجاه من اليمين لليسار
- واجهات سهلة الاستخدام
- انتقالات سلسة بين الشاشات

### 💻 لوحة التحكم الإدارية
- واجهة ويب تفاعلية
- إحصائيات مباشرة
- إدارة شاملة للبيانات
- تصديق أو رفض البيانات المرسلة

## 🔒 الأمان والحماية

- **تشفير كلمات المرور** باستخدام bcrypt
- **مصادقة JWT** لحماية API endpoints
- **تحقق من البيانات** باستخدام Pydantic
- **رفع آمن للملفات** مع فحص الأنواع المسموحة
- **CORS protection** للتحكم في الوصول

## 📊 قاعدة البيانات

### الجداول الرئيسية:
- **users**: بيانات المستخدمين
- **martyrs**: بيانات الشهداء
- **injured**: بيانات الجرحى  
- **prisoners**: بيانات الأسرى

### العلاقات:
- كل سجل مرتبط بالمستخدم الذي أضافه
- تتبع تواريخ الإنشاء والتحديث
- حفظ حالات التصديق (معلق/مصدق/مرفوض)

## 🤝 المساهمة

نرحب بالمساهمات لتطوير هذا المشروع:

1. **Fork** المشروع
2. إنشاء **feature branch** جديد
3. **Commit** التغييرات
4. **Push** للبرنش
5. إنشاء **Pull Request**

## 📄 الترخيص

هذا المشروع مفتوح المصدر ومخصص لتوثيق تاريخ الشعب الفلسطيني.

## 🔥 Firebase Integration

### المميزات الجديدة مع Firebase:
- **قاعدة بيانات سحابية حقيقية** - البيانات متاحة من أي جهاز
- **مزامنة فورية** - التحديثات تحدث في الوقت الفعلي
- **أمان متقدم** - Security Rules شاملة لحماية البيانات
- **نظام أدوار متطور** - Admin, Moderator, User
- **إدارة محلية سهلة** - إدارة المستخدمين من التطبيق
- **اختبار متقدم** - أدوات تشخيص شاملة

### الاستخدام:
```dart
// تهيئة Firebase
FirebaseDatabaseService service = FirebaseDatabaseService();

// العمليات الأساسية
List<Martyr> martyrs = await service.getAllMartyrs();
await service.createMartyr(martyr);

// إدارة الأدوار
final role = await service.getCurrentUserRole();
bool isAdmin = await service.isCurrentUserAdmin();

// الاختبار
FirebaseTestService testService = FirebaseTestService();
final results = await testService.fullFirebaseTest();
```

### الوثائق الكاملة:
- `FIREBASE_SETUP_GUIDE.md` - دليل الإعداد الشامل
- `FIREBASE_QUICK_SETUP.md` - دليل سريع في 15 دقيقة
- `firestore_security_rules.txt` - قواعد الأمان
- `firebase_test_service.dart` - خدمة الاختبار

## 📞 التواصل

للدعم والاستفسارات، يرجى فتح **Issue** جديد في المستودع.

---

**🇵🇸 في ذكرى شهدائنا الأبرار وأسرانا البواسل وجرحانا الصامدين**

تم تطوير هذا النظام بهدف الحفاظ على ذاكرة الشعب الفلسطيني وتوثيق تضحياته العظيمة.