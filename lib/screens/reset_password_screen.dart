import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 재설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '새로운 비밀번호를 설정하세요.',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Text('새 비밀번호'),
            const SizedBox(height: 5.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '새 비밀번호를 입력해주세요',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text('비밀번호 확인'),
            const SizedBox(height: 5.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호를 다시 입력해주세요',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                // 비밀번호 재설정 완료 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 재설정되었습니다.')),
                );
                Navigator.pop(context); // 로그인 화면으로 돌아가기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Center(
                child: Text(
                  '비밀번호 재설정',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
