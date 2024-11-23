import 'package:flutter/material.dart';
import 'book_add_screen.dart';

// 안쓸거 같음

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 책 추가 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookAddScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            '책 추가',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
