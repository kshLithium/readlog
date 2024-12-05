import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:readlog/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readlog/screens/main_layout.dart';
import 'package:readlog/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readlog/screens/splash_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 초기화
  await Firebase.initializeApp(
    // Firebase 초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReadLog',
      theme: ThemeData(
        primarySwatch: Colors.teal, // 앱의 기본 색상 설정
      ),
      home: FutureBuilder<bool>(
        // SharedPreferences를 사용하여 첫 실행 여부 확인
        future: _isFirstTime(),
        builder: (context, firstTimeSnapshot) {
          if (firstTimeSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // 순수 로딩 화면
          }

          // 첫 실행인 경우
          if (firstTimeSnapshot.data == true) {
            return const SplashLoginScreen(); // 로그인 버튼이 있는 스플래시 화면
          }

          // 첫 실행이 아닌 경우 인증 상태 확인
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen(); // 순수 로딩 화면
              }

              if (authSnapshot.hasData) {
                // 인증이 완료된 후에 API 키 초기화
                ApiConfig.initialize();
                return MainLayout();
              }

              return const SplashLoginScreen();
            },
          );
        },
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
    );
  }

  Future<bool> _isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      await prefs.setBool('first_time', false);
    }

    return isFirstTime;
  }
}
