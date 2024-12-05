import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final TextEditingController _yearlyGoalController = TextEditingController();
  final TextEditingController _monthlyGoalController = TextEditingController();

  bool _validateGoals() {
    try {
      final monthlyGoal = int.parse(_monthlyGoalController.text);
      final yearlyGoal = int.parse(_yearlyGoalController.text);

      if (monthlyGoal < 1 || monthlyGoal > 50) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('월간 목표는 1권에서 50권 사이로 설정해주세요')),
        );
        return false;
      }

      if (yearlyGoal < 1 || yearlyGoal > (monthlyGoal * 12)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('연간 목표는 1권에서 ${monthlyGoal * 12}권 사이로 설정해주세요')),
        );
        return false;
      }

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('숫자만 입력해주세요')),
      );
      return false;
    }
  }

  Future<void> _saveGoals() async {
    if (!_validateGoals()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('goals')
            .doc('reading_goals')
            .set({
          'yearly_goal': int.parse(_yearlyGoalController.text),
          'monthly_goal': int.parse(_monthlyGoalController.text),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('목표가 저장되었습니다')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('목표 저장에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '독서 목표 설정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 70),
              Text(
                '연간 목표를 설정하세요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _yearlyGoalController,
                decoration: InputDecoration(
                  labelText: '연간 독서 목표 (권)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black87),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              SizedBox(height: 150),
              Text(
                '월간 목표를 설정하세요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _monthlyGoalController,
                decoration: InputDecoration(
                  labelText: '월간 독서 목표 (권)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black87),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              SizedBox(height: 150),
              ElevatedButton(
                onPressed: _saveGoals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '목표 저장',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _yearlyGoalController.dispose();
    _monthlyGoalController.dispose();
    super.dispose();
  }
}
