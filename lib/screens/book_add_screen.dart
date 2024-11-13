import 'package:flutter/material.dart';

class BookAddScreen extends StatelessWidget {
  const BookAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 등록하기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end, // 하단에 배치
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              '책 등록하기',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 검색해서 등록하기 버튼
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 검색해서 등록 로직 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('검색해서 등록하기 클릭됨')),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search, size: 24.0),
                        SizedBox(width: 10.0),
                        Text(
                          '검색해서 등록하기',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 직접 등록하기 버튼
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 직접 등록 로직 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('직접 등록하기 클릭됨')),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.keyboard, size: 24.0),
                        SizedBox(width: 10.0),
                        Text(
                          '직접 등록하기',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0), // 하단 여백
        ],
      ),
    );
  }
}
