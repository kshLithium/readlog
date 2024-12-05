import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

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
                      child: _buildYearlyStatusCard(),
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
    double? progress,
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
                value: progress ?? 0.0,
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

  // 월별 독서량 데이터를 가져오는 스트림
  Stream<Map<int, int>> _getMonthlyReadingData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value({});

    final currentYear = DateTime.now().year;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .where('readingState', isEqualTo: 'completed') // completed 상태인 책만 가져오기
        .snapshots()
        .map((snapshot) {
      Map<int, int> monthlyCount = {};

      // 1-12월 초기화
      for (int i = 1; i <= 12; i++) {
        monthlyCount[i] = 0;
      }

      // 각 책의 완료 날짜를 확인하여 월별 카운트 증가
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final doneDate = data['readingDoneDate'];
        if (doneDate != null) {
          final date = (doneDate as Timestamp).toDate();
          // 현재 연도의 데이터만 필터링
          if (date.year == currentYear) {
            monthlyCount[date.month] = (monthlyCount[date.month] ?? 0) + 1;
          }
        }
      }

      return monthlyCount;
    });
  }

  Widget _buildMonthlyReadingChart() {
    return StreamBuilder<Map<int, int>>(
      stream: _getMonthlyReadingData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final monthlyData = snapshot.data!;
        final maxY = monthlyData.values
            .reduce((max, value) => max > value ? max : value)
            .toDouble();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY + 1,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${group.x}월: ${rod.toY.toInt()}권',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value == value.toInt().toDouble()) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                  left: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              barGroups: monthlyData.entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: Color(0xFF597E81),
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthlyBookList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Container();

    final currentYear = DateTime.now().year;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .orderBy('readingStartDate', descending: true) // 날짜순 정렬
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('오류가 발생했습니다'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('독서 기록이 없습니다'));
        }

        // 현재 연도의 데이터만 필터링하고 not_started 상태 제외
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final startDate = (data['readingStartDate'] as Timestamp).toDate();
          final state = data['readingState'] as String;
          return startDate.year == currentYear &&
              (state == 'reading' || state == 'completed');
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(child: Text('독서 기록이 없습니다'));
        }

        // 월별로 책 데이터 정리
        Map<int, List<DocumentSnapshot>> booksByMonth = {};
        for (var doc in filteredDocs) {
          final data = doc.data() as Map<String, dynamic>;
          final startDate = (data['readingStartDate'] as Timestamp).toDate();
          final month = startDate.month;

          if (!booksByMonth.containsKey(month)) {
            booksByMonth[month] = [];
          }
          booksByMonth[month]!.add(doc);
        }

        // 월별 섹션 생성
        return Column(
          children: booksByMonth.entries.map((entry) {
            return _buildMonthSection(
              '${entry.key}월',
              entry.value.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildBookItem(
                  data['title'] ?? '제목 없음',
                  data['author'] ?? '작가 미상',
                  data['rating']?.toInt() ?? 0,
                  '', // date 파라미터는 더 이상 사용하지 않음
                  data['thumbnailUrl'] ?? '',
                  data['readingState'] ?? 'reading',
                  data, // 날짜 계산을 위해 전체 데이터 전달
                );
              }).toList(),
            );
          }).toList(),
        );
      },
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
    String readingState,
    Map<String, dynamic> data,
  ) {
    // 날짜 텍스트 계산 로직
    String getDateText(Map<String, dynamic> data) {
      final startDate = (data['readingStartDate'] as Timestamp).toDate();
      final now = DateTime.now();

      if (readingState == 'completed') {
        final doneDate = (data['readingDoneDate'] as Timestamp).toDate();
        final duration = doneDate.difference(startDate).inDays + 1;
        return '${duration}일';
      } else {
        final duration = now.difference(startDate).inDays + 1;
        return '~${duration}일';
      }
    }

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
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.book, color: Colors.grey[400]),
                      ),
                    )
                  : Icon(Icons.book, color: Colors.grey[400]),
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
                    children: [
                      // 별점만 표시 (숫자 제거)
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            // index가 rating보다 작으면 노란색, 아니면 회색으로 표시
                            color: index < rating
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 날짜 (데코레이션 추가)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: readingState == 'completed'
                    ? Colors.green[100]
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                getDateText(data),
                style: TextStyle(
                  fontSize: 12,
                  color: readingState == 'completed'
                      ? Colors.green[800]
                      : Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 연간 독서 현황을 가져오는 스트림
  Stream<Map<String, dynamic>> _getReadingStats() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value({});

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots() // 사용자 문서에서 bookCount를 가져옴
        .asyncMap((userSnapshot) async {
      // 사용자 문서에서 bookCount 가져오기
      final bookCount = userSnapshot.data()?['bookCount'] ?? 0;

      // 목표 정보 가져오기
      final goalSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc('reading_goals')
          .get();
      final yearlyGoal = goalSnapshot.data()?['yearly_goal'] ?? 0;

      // completed 상태인 책의 수만 가져오기
      final completedBooksSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .where('readingState', isEqualTo: 'completed')
          .get();

      final completedBooks = completedBooksSnapshot.docs.length;

      return {
        'completedBooks': completedBooks,
        'totalBooks': bookCount,
        'yearlyGoal': yearlyGoal,
        'readingProgress': bookCount > 0 ? completedBooks / bookCount : 0.0,
        'achievementRate': yearlyGoal > 0 ? completedBooks / yearlyGoal : 0.0,
      };
    });
  }

  // 연간 독서 현황 카드 위젯 수정
  Widget _buildYearlyStatusCard() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _getReadingStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;
        final completedBooks = stats['completedBooks'];
        final readingProgress = stats['readingProgress'];
        final achievementRate = stats['achievementRate'];

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '독서 현황', // 텍스트 수정
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF597E81),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCircularProgress(
                      '읽은 책',
                      '$completedBooks',
                      '권',
                      readingProgress,
                      Colors.blue,
                    ),
                    _buildCircularProgress(
                      '연 목표 달성',
                      '${(achievementRate * 100).toInt()}',
                      '%',
                      achievementRate.clamp(0.0, 1.0),
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
