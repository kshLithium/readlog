import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMemoryScreen extends StatefulWidget {
  final String bookId;
  final String bookTitle;

  AddMemoryScreen({
    required this.bookId,
    required this.bookTitle,
  });

  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final TextEditingController _textController = TextEditingController();
  final DateTime _currentDate = DateTime.now();
  String? existingText; // 기존 텍스트 저장용

  @override
  void initState() {
    super.initState();
    // 기존 텍스트 불러오기
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('books')
        .doc(widget.bookId)
        .get()
        .then((doc) {
      if (doc.exists && doc.data()?['memorialText'] != null) {
        setState(() {
          existingText = doc.data()?['memorialText'];
          _textController.text = existingText!;
        });
      }
    });
  }

  Future<void> _saveMemory() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('기억하고 싶은 문장을 작성해주세요')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not found');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(widget.bookId)
          .update({
        'memorialText': _textController.text,
        'memorialTextCreatedAt': Timestamp.fromDate(_currentDate),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existingText != null ? '수정되었습니다' : '저장되었습니다'),
        ),
      );

      Navigator.of(context).popUntil((route) {
        return route.settings.name == '/memory' || route.isFirst;
      });
    } catch (e) {
      print('Error saving memory: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6EC), // 연한 베이지색 배경
      body: SafeArea(
        child: Column(
          children: [
            // 상단 버튼 영역
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.blue),
                    onPressed: _saveMemory,
                  ),
                ],
              ),
            ),

            // 책 제목 표시
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 4.0),
                child: Text(
                  widget.bookTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF597E81),
                  ),
                ),
              ),
            ),

            // 날짜 표시 부분 수정
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  '${_currentDate.year}. ${_currentDate.month}. ${_currentDate.day}. ${_currentDate.hour < 12 ? "오전" : "오후"} ${_currentDate.hour % 12 == 0 ? 12 : _currentDate.hour % 12}:${_currentDate.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),

            // 텍스트 입력 영역
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  style: GoogleFonts.gowunBatang(
                    fontSize: 17,
                    height: 2.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '기억하고 싶은 문장을 작성해보세요',
                    hintStyle: GoogleFonts.gowunBatang(
                      fontSize: 17,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
