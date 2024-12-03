import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final TextEditingController _yearlyGoalController = TextEditingController();
  final TextEditingController _monthlyGoalController = TextEditingController();

  Future<void> _saveGoals() async {
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
              controller: _yearlyGoalController,
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
              controller: _monthlyGoalController,
              decoration: InputDecoration(
                labelText: '월간 독서 목표 (권)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 150),
            ElevatedButton(
              onPressed: _saveGoals,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[200],
                foregroundColor: Colors.white,
                minimumSize: Size(200, 55),
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

  @override
  void dispose() {
    _yearlyGoalController.dispose();
    _monthlyGoalController.dispose();
    super.dispose();
  }
}
