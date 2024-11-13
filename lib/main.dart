import 'package:flutter/material.dart';
import 'package:readlog/screens/splash_screen.dart';

void main() {
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
        primarySwatch: Colors.teal,
      ),
      // 앱 실행 시 SplashScreen이 표시되도록 설정
      home: const SplashScreen(),
    );
  }
}
