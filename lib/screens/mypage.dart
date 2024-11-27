import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readlog/screens/login_screen.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경의 원 부분
          Column(
            children: [
              Container(
                // 배경의 원 높이와 너비 설정
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  // 배경 색상 설정
                  color: Colors.teal[200],
                  // 아래쪽 모서리를 둥글게 만들기
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(100),
                  ),
                ),
              ),
              // 배경과 나머지 내용 사이의 여백 공간 확보
              SizedBox(height: 80),
            ],
          ),
          // 프로필 사진과 닉네임 섹션
          Positioned(
            // 프로필 사진과 닉네임을 배경 위에 배치할 위치 설정
            top: 40, // 위쪽 여백
            left: 30, // 왼쪽 여백
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40, // 프로필 사진의 반지름 크기 설정
                  backgroundColor: Colors.purple[100], // 아바타 배경색 설정
                  child: Icon(Icons.person,
                      size: 40, color: Colors.white), // 아이콘 설정
                ),
                SizedBox(width: 20), // 아바타와 닉네임 간의 간격 설정
                Text(
                  '닉네임1234', // 닉네임 텍스트
                  style: TextStyle(
                    fontSize: 24, // 폰트 크기 설정
                    fontWeight: FontWeight.bold, // 폰트 두께 설정
                    color: Colors.white, // 텍스트 색상 설정
                  ),
                ),
              ],
            ),
          ),
          // 계정 관리와 통계 보기 버튼이 들어있는 박스
          Positioned(
            top: 140, // 박스를 원과 겹치도록 위쪽 위치 설정
            left: 20, // 좌측 여백 설정
            right: 20, // 우측 여백 설정
            child: Container(
              padding: EdgeInsets.all(20), // 내부 여백 설정
              decoration: BoxDecoration(
                color: Colors.white, // 박스 배경색 설정
                borderRadius: BorderRadius.circular(15), // 박스 모서리를 둥글게
                boxShadow: [
                  // 박스에 그림자 효과 추가
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // 그림자 색상과 투명도 설정
                    spreadRadius: 2, // 그림자 확산 정도
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(0, 3), // 그림자의 위치 설정 (x축, y축)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                children: [
                  // "계정 관리" 버튼
                  TextButton(
                    onPressed: () {
                      // 계정 관리 페이지로 이동하는 로직 추가
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 버튼 내부 여백 제거
                      minimumSize: Size(50, 30), // 버튼 최소 크기 설정
                      alignment: Alignment.centerLeft, // 텍스트 왼쪽 정렬
                      foregroundColor: Colors.black, // 버튼 텍스트 색상 설정
                    ),
                    child: Text("계정 관리"), // 버튼 텍스트
                  ),
                  Divider(), // 계정 관리와 통계 보기 버튼 사이 구분선
                  // "통계 보기" 버튼
                  TextButton(
                    onPressed: () {
                      // 통계 보기 페이지로 이동하는 로직 추가
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 버튼 내부 여백 제거
                      minimumSize: Size(50, 30), // 버튼 최소 크기 설정
                      alignment: Alignment.centerLeft, // 텍스트 왼쪽 정렬
                      foregroundColor: Colors.black, // 버튼 텍스트 색상 설정
                    ),
                    child: Text("통계 보기"), // 버튼 텍스트
                  ),
                  Divider(),
                  // 로그아웃 버튼 추가
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("로그아웃"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
