import 'package:flutter/material.dart';
import 'package:readlog/screens/home_screen.dart';
import 'package:readlog/screens/library.dart';
import 'package:readlog/screens/main_screen.dart';
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
        primarySwatch: Colors.teal, // 앱의 기본 색상 설정
      ),
      home: SplashScreen(), // 앱의 시작 화면 설정
    );
  }
}
