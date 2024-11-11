import 'package:flutter/material.dart';

// StatisticsScreen 클래스: 통계 화면을 구성하는 메인 화면 위젯
class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 영역 배경 및 타이틀
            Container(
              color: Colors.teal[300],
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '통계',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.bar_chart,
                    color: Colors.black,
                    size: 45,
                  ),
                ],
              ),
            ),
            // 통계 아이콘 목록: 수평 스크롤 가능
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    StatCard(title: '1년 동안 n권', icon: Icons.book),
                    SizedBox(width: 8),
                    StatCard(title: '월 평균 n권', icon: Icons.calendar_today),
                    SizedBox(width: 8),
                    StatCard(title: '가장 많이 읽은 달', icon: Icons.bar_chart),
                  ],
                ),
              ),
            ),
            // 나머지 통계 화면 내용
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  RatingCard(), // 별점 평균 카드
                  SizedBox(height: 20),
                  MonthHeader(title: '1월'), // 월 헤더
                  CustomBookStatTile(
                      title: '책 제목', days: '3일', rating: 5), // 책 정보 카드
                  CustomBookStatTile(
                      title: '책 제목', days: '15일', rating: 4), // 또 다른 책 정보 카드
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// StatCard 클래스: 통계 아이콘 카드 위젯
class StatCard extends StatelessWidget {
  final String title; // 카드 제목
  final IconData icon; // 카드에 표시할 아이콘

  StatCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 30), // 아이콘
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 14)), // 제목 텍스트
          ],
        ),
      ),
    );
  }
}

// RatingCard 클래스: 별점 평균을 표시하는 카드 위젯
class RatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 별점 카드 본체
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey),
          ),
          margin: EdgeInsets.only(top: 12),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5,
                  (index) => Icon(Icons.star, color: Colors.amber, size: 36)),
            ),
          ),
        ),
        // "별점 평균" 텍스트 위치 조정 (카드 상단에 걸쳐 위치)
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            color: Color(0xFFF7F0F8), // 화면 배경과 동일한 색상으로 설정
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '별점 평균',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// CustomBookStatTile 클래스: 책 제목, 별점, 날짜 등의 정보를 표시하는 리스트 아이템 위젯
class CustomBookStatTile extends StatelessWidget {
  final String title; // 책 제목
  final String days; // 읽은 날짜 정보
  final int rating; // 별점

  CustomBookStatTile(
      {required this.title, required this.days, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          // 카드 본체
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: EdgeInsets.zero,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Row(
                children: [
                  // 왼쪽 이미지 자리 (책 커버 이미지로 대체 가능)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child:
                          Icon(Icons.photo, size: 30, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(width: 12),
                  // 중앙 텍스트 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List.generate(
                              rating,
                              (index) => Icon(Icons.star,
                                  color: Colors.amber, size: 18)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '기억하고 싶은 구절이 여기에 표시됩니다.',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 오른쪽 상단에 작은 폰트로 날짜 표시
          Positioned(
            right: 12,
            top: 8,
            child: Text(
              days,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

// MonthHeader 클래스: "월"과 함께 구분선을 표시하는 헤더 위젯
class MonthHeader extends StatelessWidget {
  final String title; // 헤더의 제목 (예: "1월")

  MonthHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(child: Divider(thickness: 1, color: Colors.grey)), // 구분선
        ],
      ),
    );
  }
}
