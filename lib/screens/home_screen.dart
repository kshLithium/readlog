import 'package:flutter/material.dart';
import 'search_book_screen.dart';
import 'direct_add_book_screen.dart';
import 'timer_select_book.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showAddBookOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.search, color: Color(0xFF597E81)),
                title: Text('검색해서 등록하기'),
                onTap: () {
                  Navigator.pop(context); // 바텀시트 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookSearchScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit, color: Color(0xFF597E81)),
                title: Text('직접 등록하기'),
                onTap: () {
                  Navigator.pop(context); // 바텀시트 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DirectAddBookScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 책 추가 아이콘
              GestureDetector(
                onTap: () => _showAddBookOptions(context),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xFF597E81),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '책 추가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              // 타재 읽고있는 책 수
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '현재 읽고있는 책 권수',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // 타이머 시작 버튼
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // 타이머 시작
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerSelectBookScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF597E81),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '타이머 시작',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
