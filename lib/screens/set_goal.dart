import 'package:flutter/material.dart';

class SetGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('독서 목표 설정'),
        backgroundColor: Colors.teal[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Text(
              '연간 목표를 설정하세요',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: '연간 독서 목표 (권)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 150),
            Text(
              '월간 목표를 설정하세요',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: '월간 독서 목표 (권)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // 목표 저장 로직 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[200],
                foregroundColor: Colors.white, // 버튼 글자색
                minimumSize: Size(200, 55), // 버튼 크기 (가로, 세로)
              ),
              child: Text(
                '목표 저장',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
