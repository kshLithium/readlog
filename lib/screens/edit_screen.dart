import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_layout.dart';

class EditScreen extends StatefulWidget {
  final String? bookId;
  final String? title;
  final String? author;
  final String? publisher;
  final String? description;
  final String? thumbnailUrl;

  const EditScreen({
    this.bookId,
    this.title,
    this.author,
    this.publisher,
    this.description,
    this.thumbnailUrl,
  });

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _authorController.text = widget.author ?? '';
    _publisherController.text = widget.publisher ?? '';
    _descriptionController.text = widget.description ?? '';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('로그인이 필요합니다.');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .doc(widget.bookId)
            .update({
          'title': _titleController.text,
          'author': _authorController.text,
          'publisher': _publisherController.text,
          'description': _descriptionController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정이 완료되었습니다.')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainLayout(initialIndex: 1),
          ),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 정보 수정', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(),
                SizedBox(height: 30),
                _buildTextField('책 제목', _titleController),
                SizedBox(height: 30),
                _buildTextField('저자', _authorController),
                SizedBox(height: 30),
                _buildTextField('출판사', _publisherController),
                SizedBox(height: 30),
                _buildMultiLineTextField('책 소개', _descriptionController),
                SizedBox(height: 70),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('저장',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 원하는 색상으로 변경
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        image: widget.thumbnailUrl != null
            ? DecorationImage(
                image: NetworkImage(widget.thumbnailUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: widget.thumbnailUrl == null
          ? Center(
              child: Icon(Icons.photo, size: 60, color: Colors.grey),
            )
          : null,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label을(를) 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _buildMultiLineTextField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label을(를) 입력해주세요.';
        }
        return null;
      },
    );
  }
}
