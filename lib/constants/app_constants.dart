class AppConstants {
  // معلومات التطبيق
  static const String appName = 'توثيق الشهداء والجرحى والأسرى';
  static const String appVersion = '1.0.0';
  
  // مفاتيح التخزين المحلي
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserType = 'user_type';
  static const String keyIsLoggedIn = 'is_logged_in';
  
  // أنواع المستخدمين
  static const String userTypeAdmin = 'admin';
  static const String userTypeRegular = 'regular';
  
  // أسماء الجداول في قاعدة البيانات
  static const String tableUsers = 'users';
  static const String tableMartyrs = 'martyrs';
  static const String tableInjured = 'injured';
  static const String tablePrisoners = 'prisoners';
  
  // حالات السجلات
  static const String statusPending = 'قيد المراجعة';
  static const String statusApproved = 'تم التوثيق';
  static const String statusRejected = 'مرفوض';
  
  // درجات الإصابة
  static const List<String> injuryDegrees = [
    'خفيفة',
    'متوسطة',
    'خطيرة',
    'حرجة'
  ];
  
  // أنواع الملفات المدعومة
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> supportedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // الحد الأقصى لحجم الملفات (بالميجابايت)
  static const int maxImageSizeMB = 5;
  static const int maxDocumentSizeMB = 10;
  
  // أقسام التطبيق
  static const String sectionMartyrs = 'الشهداء';
  static const String sectionInjured = 'الجرحى';
  static const String sectionPrisoners = 'الأسرى';
  
  // رسائل التأكيد
  static const String confirmLogout = 'هل أنت متأكد من تسجيل الخروج؟';
  static const String confirmDelete = 'هل أنت متأكد من حذف هذا السجل؟';
  static const String confirmSubmit = 'هل أنت متأكد من إرسال هذا النموذج؟';
}