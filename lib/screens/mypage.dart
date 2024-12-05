import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readlog/screens/login_screen.dart';
import 'statistics.dart'; // import 추가
import 'set_goal.dart';
import 'timer_select_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase Auth에서 현재 사용자 가져오기
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal[200],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
          Positioned(
            top: 60,
            left: 30,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.purple[100],
                    child: Icon(Icons.person, size: 45, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                // StreamBuilder를 사용하여 사용자 정보 실시간 업데이트
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('오류가 발생했습니다');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    final nickname = userData?['nickname'] ?? '사용자';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '독서와 함께하는 즐거운 하루',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.bar_chart,
                    title: "통계 보기",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatisticsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.flag,
                    title: "독서 목표",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetGoalScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.timer,
                    title: "타이머 시작",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimerSelectBookScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.manage_accounts,
                    title: "계정 관리",
                    onTap: () {
                      // 계정 관리 페이지로 이동하는 로직
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: "로그아웃",
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.teal[300]),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 1,
      height: 1,
    );
  }
}
