import 'package:flutter/material.dart';
import 'library.dart'; // 서재 관리 화면을 위한 라이브러리 import

// 앱의 진입점
void main() {
  runApp(MyApp());
}

// 앱의 메인 위젯
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App', // 앱의 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 기본 테마 색상 설정
      ),
      home: HomeScreen(), // 홈 화면으로 HomeScreen 설정
    );
  }
}

// 홈 화면 위젯
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 252, 248, 248), // 앱바 배경 색상 설정
        elevation: 0, // 앱바 그림자 제거
        title: SizedBox.shrink(), // 제목을 비움
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 컬럼 중앙 정렬
        children: [
          // 책 추가 버튼 및 아이콘
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.center, // 아이콘과 텍스트를 중심 정렬
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.book, // 책 아이콘
                      size: 200,
                      color: const Color.fromARGB(255, 89, 134, 129), // 아이콘 색상
                    ),
                    onPressed: () {}, // 버튼 동작 정의 필요
                  ),
                  SizedBox(height: 1),
                  Text(
                    "\n\n\n책   추가", // 아이콘 위에 표시할 텍스트
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 텍스트 색상
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 현재 읽고 있는 책 권수 표시 컨테이너
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 221, 221), // 배경 색상
              borderRadius: BorderRadius.circular(12), // 둥근 모서리
            ),
            child: Text(
              "현재 읽고있는 책 권수         ", // 텍스트 내용
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black, // 텍스트 색상
              ),
            ),
          ),
          SizedBox(height: 80), // 컨테이너와 버튼 사이 간격
          // 타이머 시작 버튼
          ElevatedButton.icon(
            onPressed: () {}, // 버튼 동작 정의 필요
            icon: Icon(Icons.access_time, size: 50), // 버튼 아이콘
            label: Text("   타이머 시작"), // 버튼 텍스트
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 89, 134, 129), // 버튼 배경 색상
              foregroundColor: Colors.white, // 버튼 텍스트 색상
              padding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 60), // 버튼 여백
              textStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold, // 버튼 텍스트 스타일
              ),
            ),
          ),
          SizedBox(height: 50), // 버튼과 바닥 간격
        ],
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // 투명 배경
        elevation: 0, // 그림자 제거
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 아이템 간격 균일
            children: [
              // 메인 버튼
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color.fromARGB(255, 89, 134, 129), // 버튼 배경 색상
                  child: TextButton(
                    onPressed: () {}, // 버튼 동작 정의 필요
                    child: Text("메인"), // 버튼 텍스트
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // 텍스트 색상
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0), // 여백
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold, // 텍스트 스타일
                      ),
                    ),
                  ),
                ),
              ),
              // 서재 관리 버튼
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color.fromARGB(255, 89, 134, 129), // 배경 색상
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LibraryScreen()), // 서재 화면으로 이동
                      );
                    },
                    child: Text("서재관리"), // 버튼 텍스트
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // 기억하기 버튼
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color.fromARGB(255, 89, 134, 129),
                  child: TextButton(
                    onPressed: () {}, // 동작 정의 필요
                    child: Text("기억하기"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // 마이페이지 버튼
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color.fromARGB(255, 89, 134, 129),
                  child: TextButton(
                    onPressed: () {}, // 동작 정의 필요
                    child: Text("마이페이지"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
