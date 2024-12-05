import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'select_review_book_screen.dart';
import 'add_review_screen.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 단색 컨테이너
          Container(
            color: Color(0xFF597E81),
            padding: EdgeInsets.fromLTRB(16, 70, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '책 리뷰',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.rate_review,
                  color: Colors.white,
                  size: 45,
                ),
              ],
            ),
          ),
          // 그라데이션과 콘텐츠를 포함하는 Expanded
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF597E81), Colors.white],
                  stops: [0.0, 0.3],
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final reviews = snapshot.data!.docs;

                  if (reviews.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            '아직 작성된 리뷰가 없네요',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '첫 번째 리뷰를 작성해보세요',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 80.0),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review =
                          reviews[index].data() as Map<String, dynamic>;
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final isMyReview = review['userId'] == currentUser?.uid;

                      return GestureDetector(
                        onLongPress: isMyReview
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.edit,
                                              color: Color(0xFF597E81)),
                                          title: Text('수정하기'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddReviewScreen(
                                                  bookId: review['bookId'],
                                                  bookTitle:
                                                      review['bookTitle'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete,
                                              color: Colors.red),
                                          title: Text('삭제하기',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            bool? confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('삭제 확인'),
                                                content:
                                                    Text('이 리뷰를 삭제하시겠습니까?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('취소'),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                  ),
                                                  TextButton(
                                                    child: Text('삭제',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              await FirebaseFirestore.instance
                                                  .collection('reviews')
                                                  .doc(reviews[index].id)
                                                  .delete();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.15),
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 책 썸네일
                                    Container(
                                      width: 50,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: review['thumbnailUrl'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                review['thumbnailUrl'],
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(Icons.book,
                                              color: Colors.grey[400]),
                                    ),
                                    SizedBox(width: 12),
                                    // 책 제목과 저자
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF597E81)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  '${review['userName']}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF597E81),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            review['bookTitle'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF597E81),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            review['author'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // 리뷰 내용
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        review['reviewText'],
                                        style: GoogleFonts.gowunBatang(
                                          fontSize: 17,
                                          height: 2.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatDate(review['createdAt']
                                                as Timestamp),
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectReviewBookScreen(),
            ),
          );
        },
        backgroundColor: Color(0xFF597E81),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}.${date.month}.${date.day}';
  }
}
