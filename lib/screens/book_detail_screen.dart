import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_screen.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  BookDetailScreen({required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isExpanded = false;
  int localRating = 0;
  String readingState = 'not_started';
  DateTime? readingStartDate;
  DateTime? readingDoneDate;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(widget.bookId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          localRating = doc.data()?['rating'] ?? 0;
          readingState = doc.data()?['readingState'] ?? 'not_started';
          readingStartDate = doc.data()?['readingStartDate']?.toDate();
          readingDoneDate = doc.data()?['readingDoneDate']?.toDate();
        });
      }
    });
  }

  @override
  void dispose() {
    if (localRating > 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('books')
          .doc(widget.bookId)
          .update({'rating': localRating});
    }
    super.dispose();
  }

  void updateLocalRating(int rating) {
    setState(() {
      localRating = rating;
    });
  }

  String _getStateText(String state) {
    switch (state) {
      case 'completed':
        return '다 읽음';
      case 'reading':
        return '읽는 중';
      case 'not_started':
      default:
        return '읽을 예정';
    }
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'completed':
        return Colors.green;
      case 'reading':
        return Colors.blue;
      case 'not_started':
      default:
        return Colors.grey;
    }
  }

  void _updateReadingState(String newState) {
    setState(() {
      readingState = newState;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(widget.bookId)
        .update({'readingState': newState});
  }

  Future<void> _deleteBook() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('로그인이 필요합니다.');

      // 삭제 확인 다이얼로그
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말로 이 책을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('삭제'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        // 트랜잭션으로 책 삭제와 카운트 감소를 동시에 처리
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userDocRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);

          // 현재 bookCount 가져오기
          final userDoc = await transaction.get(userDocRef);
          final currentCount = userDoc.data()?['bookCount'] ?? 1;

          // 책 삭제
          transaction.delete(userDocRef.collection('books').doc(widget.bookId));

          // bookCount 감소
          transaction.set(userDocRef, {'bookCount': currentCount - 1},
              SetOptions(merge: true));
        });

        // 삭제 완료 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('책이 삭제되었습니다.')),
        );

        // MainLayout의 LibraryScreen으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainLayout(initialIndex: 1),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
      );
    }
  }

  // 날짜 선택 함수 추가
  Future<DateTime?> _selectDate(
    BuildContext context, {
    required bool isStartDate,
    required String status,
  }) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate;
    DateTime lastDate;

    if (status == 'reading') {
      firstDate = DateTime(2000);
      lastDate = DateTime.now();
    } else if (status == 'not_started') {
      firstDate = DateTime.now();
      lastDate = DateTime.now().add(Duration(days: 365));
    } else if (status == 'completed') {
      firstDate = DateTime(2000);
      lastDate = DateTime.now();

      if (!isStartDate && readingStartDate != null) {
        firstDate = readingStartDate!;
        initialDate = readingDoneDate ?? readingStartDate!;
        if (initialDate.isAfter(lastDate)) {
          initialDate = lastDate;
        }
      }
    } else {
      firstDate = DateTime(2000);
      lastDate = DateTime.now().add(Duration(days: 365));
    }

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('ko', 'KR'),
      selectableDayPredicate: status == 'completed'
          ? (DateTime date) => !date.isAfter(DateTime.now())
          : null,
    );
  }

  // 상태 변경 다이얼로그 표시 함수 수정
  void _showReadingStateDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('읽기 상태 변경'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('읽기 시작 날짜'),
                  subtitle: Text(
                    readingStartDate != null
                        ? DateFormat('yyyy-MM-dd').format(readingStartDate!)
                        : '날짜 선택',
                  ),
                  onTap: () async {
                    final date = await _selectDate(
                      context,
                      isStartDate: true,
                      status: readingState,
                    );
                    if (date != null) {
                      setState(() => readingStartDate = date);
                    }
                  },
                ),
                if (readingState == 'completed')
                  ListTile(
                    title: Text('읽기 완료 날짜'),
                    subtitle: Text(
                      readingDoneDate != null
                          ? DateFormat('yyyy-MM-dd').format(readingDoneDate!)
                          : '날짜 선택',
                    ),
                    onTap: () async {
                      final date = await _selectDate(
                        context,
                        isStartDate: false,
                        status: readingState,
                      );
                      if (date != null) {
                        setState(() => readingDoneDate = date);
                      }
                    },
                  ),
                Divider(),
                ListTile(
                  title: Text('다 읽음'),
                  onTap: () {
                    setState(() => readingState = 'completed');
                  },
                  trailing: readingState == 'completed'
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                ListTile(
                  title: Text('읽는 중'),
                  onTap: () {
                    setState(() => readingState = 'reading');
                  },
                  trailing: readingState == 'reading'
                      ? Icon(Icons.check, color: Colors.blue)
                      : null,
                ),
                ListTile(
                  title: Text('읽을 예정'),
                  onTap: () {
                    setState(() => readingState = 'not_started');
                  },
                  trailing: readingState == 'not_started'
                      ? Icon(Icons.check, color: Colors.grey)
                      : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('취소'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('저장'),
                onPressed: () async {
                  if (readingStartDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('읽기 시작 날짜를 선택해주세요')),
                    );
                    return;
                  }
                  if (readingState == 'completed' && readingDoneDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('읽기 완료 날짜를 선택해주세요')),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('books')
                        .doc(widget.bookId)
                        .update({
                      'readingState': readingState,
                      'readingStartDate': readingStartDate,
                      'readingDoneDate': readingDoneDate,
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('읽기 상태가 변경되었습니다')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('상태 변경 중 오류가 발생했습니다: $e')),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF597E81),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '책 정보',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF597E81), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('books')
              .doc(widget.bookId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('오류가 발생했습니다'));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final bookData = snapshot.data?.data() as Map<String, dynamic>?;

            if (bookData == null) {
              return Center(child: Text('책 데이터를 불러올 수 없습니다.'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookData['title'] ?? '제목 없음',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF597E81),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      image: bookData['thumbnailUrl'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  bookData['thumbnailUrl']),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: bookData['thumbnailUrl'] == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(Icons.book,
                                                size: 50,
                                                color: Colors.grey[400]),
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _showReadingStateDialog,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStateColor(readingState),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          _getStateText(readingState),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bookData['author'] ?? '작가 정보 없음',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      bookData['publisher'] ?? '출판사 정보 없음',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '책 소개',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 24,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ExpandableText(
                            text: bookData['description'] ?? '책 소개가 없습니다.',
                            isExpanded: isExpanded,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    if (readingState != 'not_started')
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '나의 평가',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF597E81),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (index) => GestureDetector(
                                  onTap: () => updateLocalRating(index + 1),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(
                                      index < localRating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Color(0xFF597E81),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 130),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF597E81),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditScreen(
                                bookId: widget.bookId,
                                title: bookData['title'] ?? '',
                                author: bookData['author'] ?? '',
                                publisher: bookData['publisher'] ?? '',
                                description: bookData['description'] ?? '',
                                thumbnailUrl: bookData['thumbnailUrl'],
                                isbn: bookData['isbn'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            '수정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _deleteBook,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            '삭제',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExpandableText extends StatelessWidget {
  final String text;
  final bool isExpanded;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Text(
        text,
        style: TextStyle(fontSize: 16),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      secondChild: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 300),
    );
  }
}
