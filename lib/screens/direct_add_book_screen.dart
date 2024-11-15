import 'package:flutter/material.dart';

class DirectAddBookScreen extends StatelessWidget {
  const DirectAddBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 등록하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // 책 저장 로직 추가
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('책 정보가 저장되었습니다.')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 이미지 등록 버튼
            GestureDetector(
              onTap: () {
                // 이미지 선택 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이미지 선택')),
                );
              },
              child: Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50.0, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // 책 제목 입력
            _buildTextField('책 제목', 'Text...'),
            const SizedBox(height: 10.0),
            // 저자 입력
            _buildTextField('저자', 'Text...'),
            const SizedBox(height: 10.0),
            // 출판사 입력
            _buildTextField('출판사', 'Text...'),
            const SizedBox(height: 10.0),
            // ISBN 입력
            _buildTextField('ISBN', 'Text...'),
            const SizedBox(height: 10.0),
            // 페이지 수 입력
            _buildTextField('페이지 수', 'Text...'),
            const SizedBox(height: 10.0),
            // 책 소개 입력
            _buildTextField('책 소개', 'Text...'),
          ],
        ),
      ),
    );
  }

  // 텍스트 필드 위젯 생성 함수
  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // 텍스트 필드 초기화 로직 추가
          },
        ),
      ),
    );
  }
}
