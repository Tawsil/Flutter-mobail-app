import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // معلومات التطبيق
  static String getAppName(BuildContext context) {
    return AppLocalizations.of(context)?.appName ?? 'توثيق الشهداء والجرحى والأسرى';
  }
  
  static String getAppVersion(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return localization?.appVersion('1.0.0') ?? 'الإصدار 1.0.0';
  }
  
  static const String appVersionNumber = '1.0.0';
  
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
  static String getStatusPending(BuildContext context) {
    return AppLocalizations.of(context)?.pending ?? 'قيد المراجعة';
  }
  
  static String getStatusApproved(BuildContext context) {
    return AppLocalizations.of(context)?.approved ?? 'تم التوثيق';
  }
  
  static String getStatusRejected(BuildContext context) {
    return AppLocalizations.of(context)?.rejected ?? 'مرفوض';
  }
  
  // درجات الإصابة
  static List<String> getInjuryDegrees(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return [
      localization?.mild ?? 'خفيفة',
      localization?.moderate ?? 'متوسطة',
      localization?.severe ?? 'خطيرة',
      localization?.critical ?? 'حرجة',
    ];
  }
  
  static const List<String> defaultInjuryDegrees = [
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
  static String getSectionMartyrs(BuildContext context) {
    return AppLocalizations.of(context)?.martyrs ?? 'الشهداء';
  }
  
  static String getSectionInjured(BuildContext context) {
    return AppLocalizations.of(context)?.injured ?? 'الجرحى';
  }
  
  static String getSectionPrisoners(BuildContext context) {
    return AppLocalizations.of(context)?.prisoners ?? 'الأسرى';
  }
  
  // رسائل التأكيد
  static String getConfirmLogout(BuildContext context) {
    return AppLocalizations.of(context)?.confirmLogout ?? 'هل أنت متأكد من تسجيل الخروج؟';
  }
  
  static String getConfirmDelete(BuildContext context) {
    return AppLocalizations.of(context)?.confirmDelete ?? 'هل أنت متأكد من حذف هذا السجل؟';
  }
  
  static String getConfirmSubmit(BuildContext context) {
    return AppLocalizations.of(context)?.confirmSubmit ?? 'هل أنت متأكد من إرسال هذا النموذج؟';
  }