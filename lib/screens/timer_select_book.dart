import 'package:flutter/material.dart';
import 'library.dart';  // 같은 디렉토리의 library.dart
import 'book_timer_screen.dart';

class TimerSelectBookScreen extends StatelessWidget {
  // BookLibrary에서 책 목록을 가져옴
  final List<String> books = BookLibrary.getBooks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 선택'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index]),
            onTap: () {
              // 타이머 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookTimerScreen(bookTitle: books[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
