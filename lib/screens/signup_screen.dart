import 'package:flutter/material.dart';
import 'completion_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  final Map<String, String> userInfo;

  const SignUpScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

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
  bool? _isPasswordMatch;

  // 비밀번호 조건 상태를 저장할 Map 추가
  Map<String, bool> _passwordConditions = {
    '8-16자': false,
    '대문자 포함': false,
    '소문자 포함': false,
    '숫자 포함': false,
    '특수문자 포함': false,
    '연속된 문자 없음': true,
    '반복된 문자 없음': true,
  };

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

    // 길이 체크 (8-16자)
    bool lengthValid = password.length >= 8 && password.length <= 16;

    // 대문자, 소문자, 숫자, 특수문자 포함 체크
    bool hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    bool hasNumber = RegExp(r'[0-9]').hasMatch(password);
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    // 연속된 문자 체크 (예: 1234, abcd)
    bool hasSequential = false;
    for (int i = 0; i < password.length - 3; i++) {
      String chunk = password.substring(i, i + 4);
      // 숫자 연속
      if ('0123456789'.contains(chunk) || '9876543210'.contains(chunk)) {
        hasSequential = true;
        break;
      }
      // 알파벳 연속
      if ('abcdefghijklmnopqrstuvwxyz'.contains(chunk.toLowerCase()) ||
          'zyxwvutsrqponmlkjihgfedcba'.contains(chunk.toLowerCase())) {
        hasSequential = true;
        break;
      }
    }

    // 반복된 문자 체크 (예: aaa, 111)
    bool hasRepeating = false;
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i] == password[i + 2]) {
        hasRepeating = true;
        break;
      }
    }

    setState(() {
      _isPasswordValid = lengthValid &&
          hasUpperCase &&
          hasLowerCase &&
          hasNumber &&
          hasSpecialChar &&
          !hasSequential &&
          !hasRepeating;

      // 각 조건의 상태 업데이트
      _passwordConditions = {
        '8-16자': lengthValid,
        '대문자 포함': hasUpperCase,
        '소문자 포함': hasLowerCase,
        '숫자 포함': hasNumber,
        '특수문자 포함': hasSpecialChar,
        '연속된 문자 없음': !hasSequential,
        '반복된 문자 없음': !hasRepeating,
      };
    });
  }

  void _validatePasswordMatch() {
    setState(() {
      _isPasswordMatch = _confirmPasswordController.text.isEmpty
          ? null
          : _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signUp() async {
    if (!_isPasswordValid || _isPasswordMatch != true) return;

    try {
      // 1. Firebase Authentication으로 계정 생성
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _idController.text,
        password: _passwordController.text,
      );

      if (credential.user != null) {
        // 2. Firestore에 사용자 정보 저장
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': widget.userInfo['name'],
          'nickname': widget.userInfo['nickname'],
          'birthDate': widget.userInfo['birthDate'],
          'phone': widget.userInfo['phone'],
          'email': _idController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 3. 가입 완료 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompletionScreen()),
        );
      }
    } on FirebaseAuthException catch (error) {
      String message = '회원가입에 실패했습니다.';

      switch (error.code) {
        case "email-already-in-use":
          message = '이미 가입한 이메일입니다.';
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
    } catch (e) {
      // Firestore 저장 실패 등 기타 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 중 오류가 발생했습니다: $e')),
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
      body: SingleChildScrollView(
        child: Padding(
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
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _passwordConditions.entries.map((entry) {
                  return _buildCondition(entry.key, entry.value);
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              // 비밀번호 확인 필드와 일치 여부 표시
              const Text('비밀번호 확인'),
              const SizedBox(height: 5.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력해주세요',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 10.0),
              if (_confirmPasswordController
                  .text.isNotEmpty) // 비밀번호 확인 필드가 비어있지 않을 때만 표시
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isPasswordMatch == true
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isPasswordMatch == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 14.0,
                        color: _isPasswordMatch == true
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _isPasswordMatch == true ? '비밀번호 일치' : '비밀번호 불일치',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isPasswordMatch == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30.0),
              // 가입하기 버튼
              ElevatedButton(
                onPressed: _isPasswordValid && _isPasswordMatch == true
                    ? _signUp
                    : null,
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
      ),
    );
  }

  Widget _buildCondition(String text, bool isValid) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isValid
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 14.0,
            color: isValid ? Colors.green : Colors.red,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
