import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReviewScreen extends StatefulWidget {
  final String bookId;
  final String bookTitle;

  AddReviewScreen({
    required this.bookId,
    required this.bookTitle,
  });

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _textController = TextEditingController();
  final DateTime _currentDate = DateTime.now();
  String? existingText;

  @override
  void initState() {
    super.initState();
    // 기존 리뷰 불러오기 - reviews 컬렉션에서 조회
    FirebaseFirestore.instance
        .collection('reviews')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('bookId', isEqualTo: widget.bookId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          existingText = doc.data()['reviewText'];
          _textController.text = existingText!;
        });
      }
    });
  }

  Future<void> _saveReview() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰를 작성해주세요')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not found');

      // 사용자 정보(닉네임) 가져오기
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // 책 정보 가져오기
      final bookDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(widget.bookId)
          .get();

      final bookData = bookDoc.data()!;
      final userName = userDoc.data()?['nickname'] ?? 'Unknown User';

      // reviews 컬렉션에 저장
      final reviewsRef = FirebaseFirestore.instance.collection('reviews');

      // 기존 리뷰 찾기
      final existingReviews = await reviewsRef
          .where('userId', isEqualTo: user.uid)
          .where('bookId', isEqualTo: widget.bookId)
          .get();

      if (existingReviews.docs.isNotEmpty) {
        // 기존 리뷰 업데이트
        await reviewsRef.doc(existingReviews.docs.first.id).update({
          'reviewText': _textController.text,
          'updatedAt': Timestamp.fromDate(_currentDate),
        });
      } else {
        // 새 리뷰 생성
        await reviewsRef.add({
          'userId': user.uid,
          'userName': userName,
          'bookId': widget.bookId,
          'bookTitle': widget.bookTitle,
          'author': bookData['author'],
          'reviewText': _textController.text,
          'createdAt': Timestamp.fromDate(_currentDate),
          'thumbnailUrl': bookData['thumbnailUrl'],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existingText != null ? '수정되었습니다' : '저장되었습니다'),
        ),
      );

      Navigator.of(context).popUntil((route) {
        return route.settings.name == '/review' || route.isFirst;
      });
    } catch (e) {
      print('Error saving review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6EC),
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
                    onPressed: _saveReview,
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

            // 날짜 표시
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
                  maxLength: 500,
                  buildCounter: (BuildContext context,
                      {required int currentLength,
                      required bool isFocused,
                      required int? maxLength}) {
                    return Text(
                      '$currentLength/500자',
                      style: TextStyle(
                        color: currentLength >= 500
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '이 책에 대한 리뷰를 작성해보세요',
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
