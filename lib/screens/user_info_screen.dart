import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/phone_number_formatter.dart';
import 'signup_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _nicknameError;
  String? _nameError;

  void _validateNickname() {
    final nickname = _nicknameController.text;

    setState(() {
      if (nickname.isEmpty) {
        _nicknameError = '닉네임을 입력해주세요';
        return;
      }

      // 한글 문자 수 계산
      int koreanCount = RegExp(r'[가-힣]').allMatches(nickname).length;
      // 영문 문자 수 계산
      int englishCount = RegExp(r'[a-zA-Z0-9]').allMatches(nickname).length;
      // 허용되지 않는 문자 검사
      bool hasInvalidChars = RegExp(r'[^a-zA-Z0-9가-힣]').hasMatch(nickname);

      if (hasInvalidChars) {
        _nicknameError = '한글, 영문, 숫자만 사용 가능합니다';
      } else if (koreanCount > 0 && nickname.length > 10) {
        _nicknameError = '한글이 포함된 닉네임은 10자 이내여야 합니다';
      } else if (koreanCount == 0 && englishCount > 0 && nickname.length > 20) {
        _nicknameError = '영문/숫자 닉네임은 20자 이내여야 합니다';
      } else if (koreanCount == 0 && englishCount == 0) {
        _nicknameError = '한글, 영문, 숫자 중 하나를 포함해야 합니다';
      } else {
        _nicknameError = null;
      }
    });
  }

  void _validateName() {
    final name = _nameController.text;
    final koreanOnly = RegExp(r'^[가-힣]+$');
    final englishOnly = RegExp(r'^[a-zA-Z]+$');

    setState(() {
      if (name.isEmpty) {
        _nameError = '이름을 입력해주세요';
      } else if (!koreanOnly.hasMatch(name) && !englishOnly.hasMatch(name)) {
        _nameError = '한글 또는 영문으로만 입력해주세요';
      } else {
        _nameError = null;
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) {
      setState(() {
        _birthController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _navigateToSignUp() {
    if (_nameController.text.isEmpty ||
        _nicknameController.text.isEmpty ||
        _birthController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 정보를 입력해주세요')),
      );
      return;
    }

    if (_nicknameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임 형식을 확인해주세요')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(
          userInfo: {
            'name': _nameController.text,
            'nickname': _nicknameController.text,
            'birthDate': _birthController.text,
            'phone': _phoneController.text,
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validateNickname);
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원님의\n정보를 입력해주세요.',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),

            // 이름 입력
            const Text('이름'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '이름을 입력해주세요',
                border: const OutlineInputBorder(),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 20.0),

            // 닉네임 입력
            const Text('닉네임'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: '닉네임을 입력해주세요',
                border: const OutlineInputBorder(),
                errorText: _nicknameError,
              ),
            ),
            const SizedBox(height: 20.0),

            // 생년월일 입력
            const Text('생년월일'),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthController,
                  decoration: const InputDecoration(
                    hintText: 'YYYY-MM-DD',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // 전화번호 입력
            const Text('전화번호'),
            const SizedBox(height: 5.0),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '전화번호를 입력해주세요',
                border: OutlineInputBorder(),
                prefixText: '+82 ',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                PhoneNumberFormatter(),
              ],
            ),
            const SizedBox(height: 40.0),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  '다음',
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
