import 'package:flutter/material.dart';
import 'completion_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordValid = false;
  bool _isPasswordMatch = false;

  @override
  void initState() {
    super.initState();

    // 비밀번호 확인 로직 추가
    _passwordController.addListener(() {
      _validatePassword();
      _validatePasswordMatch();
    });
    _confirmPasswordController.addListener(() {
      _validatePasswordMatch();
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;

    setState(() {
      // 비밀번호 조건: 8자리 이상, 숫자 포함, 영문 포함
      _isPasswordValid = password.length >= 8 &&
          RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[A-Za-z]').hasMatch(password);
    });
  }

  void _validatePasswordMatch() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signUp() async {
    if (!_isPasswordValid || !_isPasswordMatch) return;

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _idController.text,
        password: _passwordController.text,
      );

      if (credential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompletionScreen()),
        );
      }
    } on FirebaseAuthException catch (error) {
      String message = '회원가입에 실패했습니다.';

      switch (error.code) {
        case "email-already-in-use":
          message = '이미 사용 중인 이메일입니다.';
          break;
        case "invalid-email":
          message = '잘못된 이메일 형식입니다.';
          break;
        case "weak-password":
          message = '비밀번호가 너무 약합니다.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원님만의\n계정을 만들어주세요.',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            // 이메일 입력
            const Text('이메일'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                hintText: '이메일을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            // 비밀번호 입력
            const Text('비밀번호'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 10.0),
            // 비밀번호 조건 표시
            Row(
              children: [
                _buildCondition('8자리 이상', _passwordController.text.length >= 8),
                const SizedBox(width: 10.0),
                _buildCondition('숫자 포함',
                    RegExp(r'[0-9]').hasMatch(_passwordController.text)),
                const SizedBox(width: 10.0),
                _buildCondition('영문 포함',
                    RegExp(r'[A-Za-z]').hasMatch(_passwordController.text)),
              ],
            ),
            const SizedBox(height: 20.0),
            // 비밀번호 확인
            const Text('비밀번호 확인'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 10.0),
            // 비밀번호 일치 여부 및 체크 표시
            Row(
              children: [
                Icon(
                  _isPasswordMatch ? Icons.check_circle : Icons.cancel,
                  size: 16.0,
                  color: _isPasswordMatch ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 5.0),
                Text(
                  _isPasswordMatch ? '비밀번호 일치' : '비밀번호 불일치',
                  style: TextStyle(
                    color: _isPasswordMatch ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            // 가입하기 버튼
            ElevatedButton(
              onPressed: _isPasswordValid && _isPasswordMatch ? _signUp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Center(
                child: Text(
                  '가입하기',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCondition(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 16.0,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
