import 'package:flutter/material.dart';

class SearchBookScreen extends StatelessWidget {
  const SearchBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '책을 찾아보세요!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            // 검색창
            TextField(
              decoration: InputDecoration(
                hintText: '검색할 책을 입력해주세요.',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.menu_book, color: Colors.grey),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20.0),
            // 검색 결과나 추가 UI를 표시할 자리
            Expanded(
              child: Center(
                child: const Text(
                  '검색 결과가 여기에 표시됩니다.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
