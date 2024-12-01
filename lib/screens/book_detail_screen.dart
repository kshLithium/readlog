import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        return '아직 안 읽음';
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

            final bookData = snapshot.data!.data() as Map<String, dynamic>;

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
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('읽기 상태 변경'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  title: Text('다 읽음'),
                                                  onTap: () {
                                                    _updateReadingState(
                                                        'completed');
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  title: Text('읽는 중'),
                                                  onTap: () {
                                                    _updateReadingState(
                                                        'reading');
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  title: Text('아직 안 읽음'),
                                                  onTap: () {
                                                    _updateReadingState(
                                                        'not_started');
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
                                  padding: EdgeInsets.symmetric(horizontal: 4),
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
