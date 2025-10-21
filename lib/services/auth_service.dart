import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';
import 'firestore_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // تسجيل الدخول
  Future<User?> login(String email, String password) async {
    try {
      // تسجيل الدخول عبر Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // جلب بيانات المستخدم من Firestore
        final user = await _firestoreService.getUserByUid(userCredential.user!.uid);
        
        if (user != null) {
          // حفظ بيانات المستخدم محلياً
          await _saveUserSession(user);
          // تحديث آخر تسجيل دخول
          await _firestoreService.updateUserLastLogin(user.uid!);
          return user;
        }
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'خطأ في تسجيل الدخول';
      switch (e.code) {
        case 'user-not-found':
          message = 'البريد الإلكتروني غير مسجل';
          break;
        case 'wrong-password':
          message = 'كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صالح';
          break;
        case 'user-disabled':
          message = 'هذا الحساب معطل';
          break;
        default:
          message = 'خطأ في تسجيل الدخول: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: $e');
    }
  }

  // إنشاء حساب جديد
  Future<User?> register({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? phoneNumber,
  }) async {
    try {
      // التحقق من وجود البريد الإلكتروني
      final exists = await _firestoreService.isEmailExists(email);
      if (exists) {
        throw Exception('البريد الإلكتروني موجود بالفعل');
      }

      // إنشاء حساب عبر Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // إنشاء مستخدم جديد
        final user = User(
          uid: userCredential.user!.uid,
          email: email,
          username: username ?? email.split('@')[0],
          fullName: fullName,
          userType: AppConstants.userTypeRegular,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
        );

        // حفظ المستخدم في Firestore
        await _firestoreService.createUser(user);

        // حفظ بيانات الجلسة
        await _saveUserSession(user);

        return user;
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'خطأ في إنشاء الحساب';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'البريد الإلكتروني مستخدم بالفعل';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صالح';
          break;
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جداً';
          break;
        default:
          message = 'خطأ في إنشاء الحساب: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('خطأ في إنشاء الحساب: $e');
    }
  }

  // حفظ جلسة المستخدم
  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserId, user.uid ?? '');
    await prefs.setString(AppConstants.keyUserName, user.fullName);
    await prefs.setString(AppConstants.keyUserType, user.userType);
    await prefs.setString('user_email', user.email);
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }

  // الحصول على المستخدم الحالي
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      return await _firestoreService.getUserByUid(firebaseUser.uid);
    } catch (e) {
      return null;
    }
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // التحقق من نوع المستخدم
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString(AppConstants.keyUserType);
    return userType == AppConstants.userTypeAdmin;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyUserId);
      await prefs.remove(AppConstants.keyUserName);
      await prefs.remove(AppConstants.keyUserType);
      await prefs.remove('user_email');
      await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: $e');
    }
  }

  // الحصول على معرف المستخدم الحالي
  Future<String?> getCurrentUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  // الحصول على اسم المستخدم الحالي
  Future<String?> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyUserName);
  }

  // التحقق من صحة كلمة المرور
  bool isValidPassword(String password) {
    // كلمة المرور يجب أن تكون 6 أحرف على الأقل
    return password.length >= 6;
  }

  // التحقق من صحة البريد الإلكتروني
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // التحقق من صحة اسم المستخدم
  bool isValidUsername(String username) {
    // اسم المستخدم يجب أن يكون 3 أحرف على الأقل ولا يحتوي على مسافات
    return username.length >= 3 && !username.contains(' ');
  }

  // التحقق من كلمة المرور
  Future<bool> verifyPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  // تغيير كلمة المرور
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null || firebaseUser.email == null) return false;

      // إعادة المصادقة أولاً
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: currentPassword,
      );
      
      await firebaseUser.reauthenticateWithCredential(credential);

      // تحديث كلمة المرور
      await firebaseUser.updatePassword(newPassword);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('كلمة المرور الحالية غير صحيحة');
      } else if (e.code == 'weak-password') {
        throw Exception('كلمة المرور الجديدة ضعيفة جداً');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // إرسال بريد إلكتروني لإعادة تعيين كلمة المرور
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'خطأ في إرسال البريد الإلكتروني';
      switch (e.code) {
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صالح';
          break;
        case 'user-not-found':
          message = 'البريد الإلكتروني غير مسجل';
          break;
        default:
          message = 'خطأ: ${e.message}';
      }
      throw Exception(message);
    }
  }
}