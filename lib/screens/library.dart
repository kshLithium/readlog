import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'review.dart';

// 서재 관리 화면을 위한 LibraryScreen 위젯
class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("서재관리",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0, // 앱바 그림자 제거
        backgroundColor: Color(0xFF597E81), // 테마 색상으로 통일
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 서재 요약 카드 디자인 개선
              Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('books')
                      .snapshots(),
                  builder: (context, snapshot) {
                    int bookCount =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('나의 서재',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF597E81),
                            )),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.book,
                                color: Color(0xFF597E81), size: 24),
                            SizedBox(width: 8),
                            Text('$bookCount권의 책을 읽었어요',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                )),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 24),

              // 그리드뷰 개선
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('books')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('오류가 발생했습니다'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('아직 저장된 책이 없습니다'));
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 24.0,
                        childAspectRatio: 0.7, // 책 표지 비율 조정
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final thumbnailUrl = data['thumbnailUrl'] as String?;
                        final title = data['title'] as String? ?? '제목 없음';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewScreen(bookIndex: index),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: thumbnailUrl != null
                                        ? Image.network(
                                            thumbnailUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.book,
                                                  size: 105,
                                                  color: const Color.fromARGB(
                                                      255, 89, 134, 129));
                                            },
                                          )
                                        : Container(
                                            color: Color(0xFFE5E5E5),
                                            child: Icon(Icons.book,
                                                size: 105,
                                                color: const Color.fromARGB(
                                                    255, 89, 134, 129)),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
