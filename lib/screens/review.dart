import 'package:flutter/material.dart';

// ReviewScreen 클래스 정의: 책에 대한 정보를 표시하는 화면
class ReviewScreen extends StatelessWidget {
  final int bookIndex; // 책의 인덱스 (필요시 데이터 로드에 사용)

  // 생성자: bookIndex를 필수로 받아옴
  ReviewScreen({required this.bookIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 화면의 모든 방향에 16의 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽으로 정렬
            children: [
              // 책 이름 텍스트 위젯
              Text(
                '책 이름',
                style: TextStyle(
                  fontSize: 40, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                ),
              ),
              SizedBox(height: 30), // 책 이름과 다음 요소 간의 간격
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 상단 정렬
                children: [
                  // 책 표지를 나타내는 컨테이너
                  Container(
                    width: 150, // 너비
                    height: 200, // 높이
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // 검은색 테두리
                      borderRadius: BorderRadius.circular(8), // 둥근 테두리
                    ),
                    child: Center(
                      child: Text(
                        '책 표지', // 표지 대신 표시될 텍스트
                        style: TextStyle(fontSize: 30), // 텍스트 크기
                      ),
                    ),
                  ),
                  SizedBox(width: 30), // 책 표지와 정보 간의 간격
                  // 책 작가와 설명을 나타내는 컬럼
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                    children: [
                      // 작가 정보 텍스트
                      Text('작가',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 60), // 작가와 설명 간의 간격
                      // 설명 텍스트
                      Text('설명',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 80), // 책 정보와 리뷰 간의 간격
              Row(
                children: [
                  // 별점(5개 중 3개 채워짐)을 나타내는 아이콘 리스트
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < 3
                          ? Icons.star
                          : Icons.star_border, // 첫 3개는 채워진 별, 나머지는 빈 별
                      color: Colors.blue, // 별의 색상
                      size: 50, // 별의 크기
                    ),
                  ),
                  SizedBox(width: 50), // 별점과 "리뷰" 텍스트 간의 간격
                  // 리뷰 텍스트
                  Text('리뷰',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Spacer(), // 남은 공간을 차지하여 "수정" 버튼을 하단에 배치
              // 수정 버튼
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 이전 화면으로 돌아가기
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 89, 134, 129), // 버튼 배경색
                  minimumSize: Size(
                      double.infinity, 55), // 버튼의 최소 크기 (가로: 화면 전체, 세로: 55)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // 버튼 모서리를 둥글게
                  ),
                ),
                child: Text(
                  '수정', // 버튼 텍스트
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 25, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵게
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
