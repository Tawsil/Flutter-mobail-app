import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'admin_dashboard_screen.dart';
import 'user_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _cleanAndCheckAuth();
  }

  // تنظيف البيانات القديمة وفحص حالة المصادقة
  Future<void> _cleanAndCheckAuth() async {
    try {
      // تنظيف البيانات القديمة من SharedPreferences
      print('=== Cleaning old data ===');
      final prefs = await SharedPreferences.getInstance();
      
      // حذف أي مفاتيح قديمة قد تسبب مشاكل
      final keysToCheck = ['user_role', 'role'];
      for (var key in keysToCheck) {
        if (prefs.containsKey(key)) {
          print('Removing old key: $key');
          await prefs.remove(key);
        }
      }
      
      print('Old data cleaned successfully');
    } catch (e) {
      print('Error cleaning old data: $e');
    }
    
    // الآن فحص حالة المصادقة
    await _checkAuthStatus();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    // انتظار لمدة ثانيتين لعرض شاشة البداية
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      print('=== DEBUG: Checking auth status ===');
      final bool isLoggedIn = await _authService.isLoggedIn();
      print('DEBUG: isLoggedIn = $isLoggedIn');
      
      if (!mounted) return;

      if (isLoggedIn) {
        final bool isAdmin = await _authService.isAdmin();
        print('DEBUG: isAdmin = $isAdmin');
        
        // للتحقق: طباعة بيانات المستخدم الحالي
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          print('DEBUG: Current user email = ${currentUser.email}');
          print('DEBUG: Current user userType = ${currentUser.userType}');
        } else {
          print('DEBUG: Current user is null!');
        }
        
        if (!mounted) return;
        
        // توجيه المستخدم حسب نوعه
        if (isAdmin) {
          print('DEBUG: Navigating to Admin Dashboard');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          );
        } else {
          print('DEBUG: Navigating to User Dashboard');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserDashboardScreen()),
          );
        }
      } else {
        print('DEBUG: Navigating to Login Screen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e, stackTrace) {
      print('=== ERROR in _checkAuthStatus ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      // في حالة حدوث خطأ، انتقل إلى شاشة تسجيل الدخول
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.freedomGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // شعار التطبيق
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlack.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          size: 60,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // اسم التطبيق
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                          shadows: [
                            Shadow(
                              color: AppColors.primaryBlack,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // وصف مختصر
                      Text(
                        'منصة توثيق الشهداء والجرحى والأسرى',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryWhite.withOpacity(0.9),
                          shadows: const [
                            Shadow(
                              color: AppColors.primaryBlack,
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // مؤشر التحميل
                      const SpinKitWave(
                        color: AppColors.primaryWhite,
                        size: 40,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'جاري التحميل...',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryWhite.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}