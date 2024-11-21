import 'package:flutter/material.dart';
import 'package:vscode_app/main.dart';
import 'package:vscode_app/review.dart';

// 서재 관리 화면을 위한 LibraryScreen 위젯
class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 화면 상단의 앱바 설정
      appBar: AppBar(
        title: Text("서재관리"), // 앱바 타이틀
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면 전체에 16px 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 위젯 정렬 방향 설정
          children: [
            // 서재 요약 정보가 들어가는 컨테이너
            Container(
              padding: EdgeInsets.all(16.0), // 컨테이너 내부 여백
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 221, 221), // 배경 색상
                borderRadius: BorderRadius.circular(16.0), // 모서리 둥글게 처리
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "나의 서재" 제목 텍스트
                  Text(
                    '나의 서재                        ',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // 텍스트 간 간격 조절
                  // "n 권의 책을 읽었어요" 텍스트
                  Text(
                    '\n  n 권의 책을 읽었어요     ',
                    style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // 컨테이너와 GridView 사이 간격 조절
            // 책 리스트를 그리드 형태로 보여주는 GridView
            GridView.count(
              crossAxisCount: 3, // 한 줄에 표시될 아이템 개수
              crossAxisSpacing: 0.0, // 열 간 간격
              mainAxisSpacing: 15.0, // 행 간 간격
              shrinkWrap: true, // GridView가 컨테이너 내에서 크기 조절 가능
              physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
              children: List.generate(4, (index) {
                // 4개의 책 아이템을 생성
                return GestureDetector(
                    onTap: () {
                      // 책을 선택했을 때 ReviewScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(bookIndex: index),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        // 책 아이콘
                        Icon(Icons.book,
                            size: 105,
                            color: const Color.fromARGB(255, 89, 134, 129)),
                        // 책 번호를 표시하는 텍스트
                        Text(
                          '책 ${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ));
              }),
            ),
          ],
        ),
      ),
      // 하단 네비게이션 바 설정
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // 배경 투명
        child: Container(
          height: 56.0, // 네비게이션 바 높이
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 89, 134, 129), // 배경 색상
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
                bottom: Radius.circular(16.0)), // 모서리 둥글게 처리
          ),
          // "메인" 버튼
          child: TextButton(
            onPressed: () {
              // 메인 화면(HomeScreen)으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor:
                  const Color.fromARGB(255, 255, 255, 255), // 텍스트 색상
              textStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              minimumSize: Size(double.infinity, 56), // 버튼 크기 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                    bottom: Radius.circular(16.0)), // 모서리 처리
              ),
            ),
            child: Text("메인"), // 버튼 텍스트
          ),
        ),
      ),
    );
  }
}
