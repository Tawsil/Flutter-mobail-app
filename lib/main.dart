import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'screens/debug_error_screen.dart';

void main() async {
  // تهيئة Flutter مع معالجة أخطاء شاملة
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    print('=== APP STARTING ===');
    print('Flutter initialized successfully');
    
    // تهيئة Firebase مع معالجة الأخطاء
    bool firebaseInitialized = false;
    String? firebaseError;
    
    try {
      print('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
      print('Firebase initialized successfully!');
    } catch (e, stackTrace) {
      print('=== FATAL ERROR: Firebase initialization failed ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      firebaseError = 'Firebase Init Error: $e';
    }
    
    // معالج الأخطاء العالمي لـ Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      print('=== FLUTTER ERROR CAUGHT ===');
      print('Error: ${details.exception}');
      print('StackTrace: ${details.stack}');
      FlutterError.presentError(details);
    };
    
    // تشغيل التطبيق
    runApp(PalestineMartyrApp(
      firebaseInitialized: firebaseInitialized,
      initError: firebaseError,
    ));
  } catch (e, stackTrace) {
    print('=== CRITICAL ERROR IN MAIN ===');
    print('Error: $e');
    print('StackTrace: $stackTrace');
    
    // محاولة تشغيل التطبيق بشاشة خطأ بسيطة
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'خطأ حرج في التطبيق',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: 'Error: $e\n\nStackTrace: $stackTrace'));
                  },
                  child: const Text('نسخ معلومات الخطأ'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class PalestineMartyrApp extends StatelessWidget {
  final bool firebaseInitialized;
  final String? initError;
  
  const PalestineMartyrApp({
    Key? key, 
    required this.firebaseInitialized,
    this.initError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ضبط شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryGreen,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // دعم اللغة العربية والعربية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic - Saudi Arabia
        Locale('en', 'US'), // English - USA
      ],
      locale: const Locale('ar', 'SA'), // اللغة الافتراضية العربية
      
      // إعدادات التطبيق
      theme: ThemeData(
        // الألوان الأساسية
        primarySwatch: _createMaterialColor(AppColors.primaryGreen),
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.primaryWhite,
        
        // تخصيص شريط التطبيق
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.primaryWhite,
          elevation: 4,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        
        // تخصيص البطاقات
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: AppColors.primaryBlack.withOpacity(0.1),
        ),
        
        // تخصيص الأزرار
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.primaryWhite,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        
        // تخصيص حقول النصوص
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryGreen),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        
        // تخصيص النصوص
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
          ),
          bodySmall: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        
        // تخصيص التقسيمات
        dividerTheme: DividerThemeData(
          color: AppColors.textLight,
          thickness: 1,
        ),
        
        // دعم الاتجاه من اليمين لليسار
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // الشاشة الرئيسية
      home: initError != null
          ? DebugErrorScreen(
              errorMessage: initError!,
              stackTrace: '',
              debugLogs: ['App initialization failed'],
            )
          : const SplashScreen(),
    );
  }
  
  // إنشاء MaterialColor من Color
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}