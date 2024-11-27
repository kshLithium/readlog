import 'package:flutter/material.dart';
import 'package:readlog/screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 초기화
  await dotenv.load(); // .env 파일 로드
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
      home: SplashScreen(), // 앱의 시작 화면 설정
    );
  }
}
