import 'package:flutter/material.dart';
import 'package:readlog/screens/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '반갑습니다!\n로그인을 해주세요.',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Text('아이디'),
            const SizedBox(height: 5.0),
            const TextField(
              decoration: InputDecoration(
                hintText: '아이디를 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text('비밀번호'),
            const SizedBox(height: 5.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 40.0), // 회원가입 버튼과 입력 필드 사이 간격
            // 회원가입 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('계정이 없으신가요?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0), // 회원가입 버튼과 로그인 버튼 사이 간격
            // 로그인 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 성공 시 메인 화면으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  '로그인하기',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
