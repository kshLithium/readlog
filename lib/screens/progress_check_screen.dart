import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증
import 'package:intl/intl.dart'; // 날짜 포맷
import 'main_layout.dart'; // main_layout.dart로 화면 전환

class ProgressCheckScreen extends StatefulWidget {
  const ProgressCheckScreen({Key? key}) : super(key: key);

  @override
  _ProgressCheckScreenState createState() => _ProgressCheckScreenState();
}

class _ProgressCheckScreenState extends State<ProgressCheckScreen> {
  String? _selectedStatus; // 선택된 상태 (읽는 중, 읽을 예정, 읽기 완료)
  DateTime? _selectedStartDate; // 읽기 시작 날짜
  DateTime? _selectedEndDate; // 읽기 완료 날짜 (읽기 완료일 때만 필요)

  // 날짜 선택 함수
  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate;
    DateTime lastDate;

    if (_selectedStatus == '읽는 중') {
      firstDate = DateTime(2000);
      lastDate = DateTime.now(); // 오늘 이후 날짜 선택 불가
    } else if (_selectedStatus == '읽을 예정') {
      firstDate = DateTime.now(); // 오늘 이전 날짜 선택 불가
      lastDate = DateTime.now().add(Duration(days: 365));
    } else {
      firstDate = DateTime(2000);
      lastDate = DateTime.now().add(Duration(days: 365));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  // Firestore에 날짜 저장
  Future<void> _saveBookProgress(String status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인하지 않았습니다.");
      return;
    }

    // 저장할 날짜 포맷
    String formattedStartDate = _selectedStartDate != null ? DateFormat('yyyy-MM-dd').format(_selectedStartDate!) : '';
    String formattedEndDate = _selectedEndDate != null ? DateFormat('yyyy-MM-dd').format(_selectedEndDate!) : '';

    try {
      await FirebaseFirestore.instance.collection('books_progress').add({
        'userId': user.uid,
        'status': status,
        'startDate': formattedStartDate,
        'endDate': formattedEndDate,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Progress saved!");

      // 저장 후 main_layout.dart 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainLayout()), // MainLayout 화면으로 이동
      );
    } catch (e) {
      print("Error saving progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 진도 체크'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '책의 진도를 체크해 주세요.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // 읽는 중, 읽을 예정, 읽기 완료 아이콘 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 읽는 중 아이콘
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = '읽는 중';
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.book,
                        color: _selectedStatus == '읽는 중' ? Colors.blue : Colors.black,
                      ),
                      Text('읽는 중'),
                    ],
                  ),
                ),
                // 읽을 예정 아이콘
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = '읽을 예정';
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: _selectedStatus == '읽을 예정' ? Colors.blue : Colors.black,
                      ),
                      Text('읽을 예정'),
                    ],
                  ),
                ),
                // 읽기 완료 아이콘
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = '읽기 완료';
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: _selectedStatus == '읽기 완료' ? Colors.blue : Colors.black,
                      ),
                      Text('읽기 완료'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // 날짜 선택 부분
            if (_selectedStatus != null)
              Column(
                children: [
                  // 읽기 시작 날짜 선택
                  GestureDetector(
                    onTap: () => _selectDate(context, isStartDate: true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedStartDate != null
                            ? '읽기 시작 날짜: ${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)}'
                            : '읽기 시작 날짜 선택',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 읽기 완료 날짜 선택 (읽기 완료일 경우만 표시)
                  if (_selectedStatus == '읽기 완료')
                    GestureDetector(
                      onTap: () => _selectDate(context, isStartDate: false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedEndDate != null
                              ? '읽기 완료 날짜: ${DateFormat('yyyy-MM-dd').format(_selectedEndDate!)}'
                              : '읽기 완료 날짜 선택',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),

            SizedBox(height: 30),

            // 확인 버튼
            ElevatedButton(
              onPressed: () {
                if (_selectedStatus != null && _selectedStartDate != null) {
                  _saveBookProgress(_selectedStatus!);
                } else {
                  // 상태와 날짜가 선택되지 않은 경우
                  print("상태와 날짜를 모두 선택해주세요.");
                }
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
