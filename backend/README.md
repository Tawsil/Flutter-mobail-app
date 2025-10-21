# Palestine Martyrs Backend API 🇵🇸

نظام backend كامل مطور بـ FastAPI لإدارة بيانات الشهداء والجرحى والأسرى في فلسطين.

## 🌟 الميزات

### 🔐 المصادقة والأمان
- مصادقة JWT آمنة
- تشفير كلمات المرور باستخدام bcrypt
- حماية CORS محكمة
- التحقق من صحة البيانات باستخدام Pydantic

### 📊 إدارة البيانات
- **الشهداء**: إدارة كاملة لبيانات الشهداء
- **الجرحى**: تتبع الجرحى وحالاتهم
- **الأسرى**: إدارة بيانات الأسرى
- **الإحصائيات**: تقارير مفصلة ورؤى تحليلية

### 🖥️ لوحة الإدارة
- واجهة ويب تفاعلية للإدارة
- عرض البيانات في جداول ديناميكية
- فلترة وبحث متقدم
- إحصائيات مرئية

### 🔄 دعم العمل غير المتصل
- مزامنة تلقائية مع التطبيق
- دعم العمل offline/online
- تخزين محلي مؤقت

## 🏗️ الهيكل التقني

### Backend Stack:
- **FastAPI**: إطار عمل API سريع وحديث
- **PostgreSQL**: قاعدة بيانات احترافية
- **SQLAlchemy**: ORM متقدم للتفاعل مع قاعدة البيانات
- **JWT**: مصادقة آمنة
- **Pydantic**: التحقق من صحة البيانات

### Frontend Integration:
- **Flutter**: تطبيق الهاتف المحمول
- **Dio**: مكتبة HTTP للاتصال بالـ API
- **BLoC**: إدارة الحالة في Flutter
- **Repository Pattern**: تجريد طبقة البيانات

## 📁 هيكل المشروع

```
backend/
├── main.py              # خادم FastAPI الرئيسي
├── models.py            # نماذج قاعدة البيانات
├── schemas.py           # مخططات التحقق من البيانات
├── database.py          # إعدادات قاعدة البيانات
├── config.py            # إعدادات التطبيق
├── requirements.txt     # تبعيات Python
├── Dockerfile          # ملف Docker للنشر
├── railway.toml        # إعدادات Railway
├── .env.example        # مثال على متغيرات البيئة
├── init_db.py          # سكريبت تهيئة قاعدة البيانات
├── deploy.sh           # سكريبت النشر السريع
├── update_url.sh       # سكريبت تحديث URL في Flutter
├── DEPLOYMENT.md       # دليل النشر المفصل
└── templates/
    ├── admin.html      # لوحة الإدارة
    └── admin.js        # JavaScript للوحة الإدارة
```

## 🚀 النشر السريع على Railway

### المتطلبات الأساسية:
1. حساب GitHub
2. حساب Railway
3. Git CLI

### خطوات النشر:

#### 1. إعداد Railway
```bash
# تثبيت Railway CLI
npm install -g @railway/cli

# تسجيل الدخول
railway login

# إنشاء مشروع جديد
railway init

# ربط مع GitHub repo
railway link
```

#### 2. إضافة قاعدة البيانات
```bash
# إضافة PostgreSQL
railway add postgresql
```

#### 3. تعيين متغيرات البيئة
```bash
railway variables set JWT_SECRET_KEY="your-super-secret-jwt-key-2024"
railway variables set DEBUG="False"
railway variables set EMAIL_HOST="smtp.gmail.com"
railway variables set EMAIL_PORT="587"
railway variables set EMAIL_USER="your-email@gmail.com"
railway variables set EMAIL_PASS="your-app-password"
```

#### 4. نشر التطبيق
```bash
railway up
```

#### 5. تهيئة قاعدة البيانات
بعد النشر، اذهب إلى:
```
https://your-app-url.railway.app/init-db
```

## 🔧 API Endpoints

### المصادقة
- `POST /auth/login` - تسجيل الدخول
- `POST /admin/register` - تسجيل مدير جديد

### إدارة البيانات
- `GET /martyrs` - قائمة الشهداء
- `POST /martyrs` - إضافة شهيد جديد
- `PUT /martyrs/{id}` - تحديث بيانات شهيد
- `DELETE /martyrs/{id}` - حذف شهيد

- `GET /injured` - قائمة الجرحى
- `POST /injured` - إضافة جريح جديد
- `PUT /injured/{id}` - تحديث بيانات جريح
- `DELETE /injured/{id}` - حذف جريح

- `GET /prisoners` - قائمة الأسرى
- `POST /prisoners` - إضافة أسير جديد
- `PUT /prisoners/{id}` - تحديث بيانات أسير
- `DELETE /prisoners/{id}` - حذف أسير

### الإحصائيات والتقارير
- `GET /stats` - إحصائيات شاملة
- `GET /health` - فحص صحة الخادم

### لوحة الإدارة
- `GET /admin` - الوصول للوحة الإدارة

## 📱 تحديث تطبيق Flutter

بعد النشر، قم بتحديث URL في التطبيق:

```dart
// في lib/services/api_service.dart
static const String baseUrl = 'https://your-railway-app-url.railway.app';
```

أو استخدم السكريبت المساعد:
```bash
./update_url.sh https://your-railway-app-url.railway.app
```

## 📊 لوحة الإدارة

### الوصول:
اذهب إلى: `https://your-app-url.railway.app/admin`

### المعلومات الافتراضية:
- **اسم المستخدم**: admin
- **كلمة المرور**: admin123
- **البريد الإلكتروني**: admin@palestine-martyrs.org

### الميزات:
- عرض جميع البيانات في جداول تفاعلية
- فلترة وبحث متقدم
- إحصائيات مرئية
- إضافة وتعديل البيانات
- تصدير التقارير

## 🔒 الأمان

### إعدادات الحماية:
- تشفير كلمات المرور باستخدام bcrypt
- مصادقة JWT مع انتهاء صلاحية
- التحقق من صحة جميع المدخلات
- حماية CORS محكمة
- معالجة الأخطاء الآمنة

### نصائح الأمان:
1. غيّر JWT_SECRET_KEY في الإنتاج
2. استخدم HTTPS دائماً
3. قم بتحديث كلمة مرور المدير الافتراضية
4. راقب السجلات بانتظام
5. احتفظ بنسخ احتياطية من قاعدة البيانات

## 📈 المراقبة والصيانة

### Health Check:
```bash
curl https://your-app-url.railway.app/health
```

### مراقبة الأداء:
- Railway توفر مراقبة تلقائية
- سجلات مفصلة لجميع العمليات
- تنبيهات عند حدوث أخطاء

### النسخ الاحتياطية:
- Railway توفر نسخ احتياطية تلقائية لـ PostgreSQL
- يُنصح بإعداد نسخ احتياطية إضافية

## 🆘 استكشاف الأخطاء

### مشاكل شائعة وحلولها:

#### 1. فشل الاتصال بقاعدة البيانات:
```bash
railway logs
```
تحقق من متغيرات البيئة والـ DATABASE_URL

#### 2. أخطاء المصادقة:
تأكد من JWT_SECRET_KEY في متغيرات البيئة

#### 3. مشاكل CORS:
تحقق من إعدادات CORS في main.py

## 🤝 المساهمة والتطوير

### متطلبات التطوير المحلي:
```bash
# إنشاء بيئة افتراضية
python -m venv venv
source venv/bin/activate  # Linux/Mac
# أو
venv\Scripts\activate     # Windows

# تثبيت التبعيات
pip install -r requirements.txt

# تشغيل الخادم المحلي
uvicorn main:app --reload
```

### إضافة ميزات جديدة:
1. أضف النموذج في `models.py`
2. أضف المخطط في `schemas.py`
3. أضف النقاط النهائية في `main.py`
4. اختبر الـ API
5. حدث الوثائق

## 📞 الدعم والمساعدة

للحصول على المساعدة:
1. راجع الوثائق التفصيلية في `DEPLOYMENT.md`
2. تحقق من السجلات باستخدام `railway logs`
3. راجع الـ API docs في `/docs`

---

**تم تطوير هذا النظام بواسطة MiniMax Agent لخدمة القضية الفلسطينية** 🇵🇸