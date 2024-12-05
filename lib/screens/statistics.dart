import 'package:flutter/material.dart';

// StatisticsScreen 클래스: 통계 화면을 구성하는 메인 화면 위젯
class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 헤더
          Container(
            color: Color(0xFF597E81),
            padding: EdgeInsets.fromLTRB(16, 70, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '통계',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.bar_chart, color: Colors.white, size: 45),
              ],
            ),
          ),
          // 메인 콘텐츠
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 연간 독서 현황 카드
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '2024년 독서 현황',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildCircularProgress(
                                    '읽은 책',
                                    '12',
                                    '권',
                                    0.6,
                                    Colors.blue,
                                  ),
                                  _buildCircularProgress(
                                    '목표 달성',
                                    '60',
                                    '%',
                                    0.6,
                                    Colors.green,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 월별 독서량 그래프
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '월별 독서량',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 200,
                                child: _buildMonthlyReadingChart(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 별점 분포
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '별점 분포',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildRatingDistribution(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 월별 독서 기록
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '월별 독서 기록',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF597E81),
                                ),
                              ),
                              SizedBox(height: 20),
                              _buildMonthlyBookList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // 하단 여백
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
    String label,
    String value,
    String unit,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 10,
              ),
            ),
            Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReadingChart() {
    // 여기에 차트 라이브러리를 사용하여 월별 독서량 차트를 구현합니다
    // fl_chart 또는 charts_flutter 등을 사용할 수 있습니다
    return Container(
      // 임시로 더미 데이터 표시
      color: Colors.grey[100],
      child: Center(
        child: Text('월별 독서량 차트가 들어갈 자리입니다'),
      ),
    );
  }

  Widget _buildRatingDistribution() {
    return Column(
      children: [
        _buildRatingBar('5점', 0.8),
        SizedBox(height: 8),
        _buildRatingBar('4점', 0.6),
        SizedBox(height: 8),
        _buildRatingBar('3점', 0.3),
        SizedBox(height: 8),
        _buildRatingBar('2점', 0.2),
        SizedBox(height: 8),
        _buildRatingBar('1점', 0.1),
      ],
    );
  }

  Widget _buildRatingBar(String label, double value) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyBookList() {
    return Column(
      children: [
        _buildMonthSection('3월', [
          _buildBookItem(
            '클린 코드',
            '로버트 C. 마틴',
            4,
            '2024.03.15',
            'https://example.com/book1.jpg',
          ),
          _buildBookItem(
            '객체지향의 사실과 오해',
            '조영호',
            5,
            '2024.03.05',
            'https://example.com/book2.jpg',
          ),
        ]),
        _buildMonthSection('2월', [
          _buildBookItem(
            '함께 자라기',
            '김창준',
            5,
            '2024.02.20',
            'https://example.com/book3.jpg',
          ),
        ]),
        _buildMonthSection('1월', [
          _buildBookItem(
            '누구나 자료 구조와 알고리즘',
            '제이 웬그로우',
            4,
            '2024.01.10',
            'https://example.com/book4.jpg',
          ),
          _buildBookItem(
            '이펙티브 자바',
            '조슈아 블로크',
            5,
            '2024.01.03',
            'https://example.com/book5.jpg',
          ),
        ]),
      ],
    );
  }

  Widget _buildMonthSection(String month, List<Widget> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Text(
                month,
                style: TextStyle(
                  fontSize: 16,
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
            ],
          ),
        ),
        ...books,
      ],
    );
  }

  Widget _buildBookItem(
    String title,
    String author,
    int rating,
    String date,
    String imageUrl,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 커버 이미지
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(Icons.book, color: Colors.grey[400]),
            ),
            SizedBox(width: 12),
            // 책 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 날짜
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
