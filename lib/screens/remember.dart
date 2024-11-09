import 'package:flutter/material.dart';

class RememberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 화면의 주요 콘텐츠를 스크롤 가능한 단일 Column으로 배치
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 영역: "기억하기" 타이틀과 아이콘
            Container(
              color: Colors.teal[300], // 배경색 설정
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16), // 여백 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우로 배치
                children: [
                  Text(
                    '기억하기', // 타이틀 텍스트
                    style: TextStyle(
                      fontSize: 34, // 폰트 크기 설정
                      fontWeight: FontWeight.bold, // 폰트 굵기 설정
                      color: Colors.white, // 폰트 색상 설정
                    ),
                  ),
                  Icon(
                    Icons.book_outlined, // 아이콘 설정
                    color: Colors.black, // 아이콘 색상
                    size: 45, // 아이콘 크기
                  ),
                ],
              ),
            ),
            // 둥근 배경과 첫 번째 카드 영역을 감싸는 Stack
            Stack(
              children: [
                // 상단 둥근 배경
                Container(
                  height: 80, // 배경 높이
                  decoration: BoxDecoration(
                    color: Colors.teal[300], // 배경색 설정
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(300.0), // 왼쪽 하단 곡률
                      bottomRight: Radius.circular(300.0), // 오른쪽 하단 곡률
                    ),
                  ),
                ),
                // 구절 박스 리스트가 시작되는 패딩 영역
                Padding(
                  padding: const EdgeInsets.only(top: 30.0), // 상단 패딩
                  child: Column(
                    children: [
                      // 구절 박스 목록 생성
                      ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 28.0), // 좌우 마진
                        physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                        shrinkWrap: true, // Column에 맞게 축소
                        itemCount: 10, // 구절 박스 개수 설정
                        itemBuilder: (context, index) {
                          return Container(
                            height: 260, // 구절 박스의 높이 설정
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // 구절 박스의 모서리 둥글게
                              ),
                              elevation: 4, // 박스 그림자 설정
                              margin: EdgeInsets.only(bottom: 35.0), // 상하 간격 설정
                              child: Padding(
                                padding: const EdgeInsets.all(16.0), // 내부 여백 설정
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // 텍스트 좌측 정렬
                                  children: [
                                    Text(
                                      '책 제목 ${index + 1}', // 책 제목 텍스트
                                      style: TextStyle(
                                        fontSize: 18, // 제목 폰트 크기
                                        fontWeight: FontWeight.bold, // 제목 폰트 굵기
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey, // 구분선 색상
                                      thickness: 1, // 구분선 두께
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment
                                            .centerLeft, // 구절 텍스트 좌측 정렬
                                        child: Text(
                                          '기억하고 싶은 구절 ${index + 1}', // 구절 텍스트
                                          style: TextStyle(
                                            fontSize: 16, // 구절 폰트 크기
                                            color:
                                                Colors.grey[600], // 구절 텍스트 색상
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
