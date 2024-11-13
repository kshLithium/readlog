import 'package:flutter/material.dart';
import 'login_screen.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 중앙에 아이콘과 텍스트
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 체크 아이콘
                const Icon(
                  Icons.check_circle,
                  size: 100.0,
                  color: Color(0xFF4A7C59), // 커스텀 색상
                ),
                const SizedBox(height: 20.0),
                // 가입 완료 텍스트
                const Text(
                  '가입완료!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // 화면 하단에 버튼 배치
          Positioned(
            bottom: 30.0, // 하단에서 30px 여백
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                child: ElevatedButton(
                  onPressed: () {
                    // 로그인 화면으로 이동
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false, // 이전 화면 스택 제거
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C59), // 버튼 배경 색상
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
