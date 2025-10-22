import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ⚠️ FIREBASE DISABLED FOR TESTING ⚠️
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
// import 'screens/splash_screen.dart';
// import 'screens/debug_error_screen.dart';

void main() async {
  // ⚠️⚠️⚠️ FIREBASE DISABLED FOR TESTING ⚠️⚠️⚠️
  // This is a TEST BUILD to check if Firebase is causing the crash
  
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    print('=== TEST BUILD - FIREBASE DISABLED ===');
    print('Flutter initialized successfully');
    
    // ⚠️ FIREBASE INITIALIZATION COMMENTED OUT ⚠️
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    
    // معالج الأخطاء العالمي لـ Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      print('=== FLUTTER ERROR CAUGHT ===');
      print('Error: ${details.exception}');
      print('StackTrace: ${details.stack}');
      FlutterError.presentError(details);
    };
    
    // تشغيل التطبيق بدون Firebase
    runApp(const TestAppWithoutFirebase());
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

// ⚠️ TEST APP WITHOUT FIREBASE ⚠️
class TestAppWithoutFirebase extends StatelessWidget {
  const TestAppWithoutFirebase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Build - Firebase Disabled',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة النجاح
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // رسالة النجاح
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '✅ Flutter يعمل بنجاح!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '⚠️ Firebase معطّل مؤقتاً',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'هذه نسخة اختبار\n'
                            'إذا ظهرت هذه الشاشة:\n'
                            '✅ المشكلة في Firebase\n\n'
                            'إذا لم تظهر:\n'
                            '❌ المشكلة في مكان آخر',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // معلومات إضافية
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'معلومات النسخة التجريبية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '📱 التطبيق: Palestine Martyr\n'
                          '🔧 الحالة: اختبار بدون Firebase\n'
                          '📅 التاريخ: 2025-10-23',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

// ⚠️⚠️⚠️ ORIGINAL APP CODE COMMENTED OUT FOR TESTING ⚠️⚠️⚠️
// Uncomment this after testing

/*
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
    // ... original code ...
  }
}
*/