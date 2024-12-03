import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class EditScreen extends StatefulWidget {
  final String? bookId;
  final String? title;
  final String? author;
  final String? publisher;
  final String? description;
  final String? thumbnailUrl;
  final String? isbn;

  const EditScreen({
    this.bookId,
    this.title,
    this.author,
    this.publisher,
    this.description,
    this.thumbnailUrl,
    this.isbn,
  });

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _isbnController = TextEditingController();
  final _descriptionController = TextEditingController();
  double? _imageAspectRatio;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _authorController.text = widget.author ?? '';
    _publisherController.text = widget.publisher ?? '';
    _isbnController.text = widget.isbn ?? '';
    _descriptionController.text = widget.description ?? '';

    if (widget.thumbnailUrl != null) {
      _calculateImageAspectRatio(widget.thumbnailUrl!);
    }
  }

  Future<void> _saveChanges() async {
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
        'isbn': _isbnController.text,
        'description': _descriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정이 완료되었습니다.')),
      );

      // 이전 화면으로 돌아가기
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> _calculateImageAspectRatio(String imagePath) async {
    if (imagePath.startsWith('http')) {
      final imageProvider = NetworkImage(imagePath);
      final imageStream = imageProvider.resolve(ImageConfiguration());
      final completer = Completer<double>();

      imageStream.addListener(ImageStreamListener((info, _) {
        completer.complete(info.image.width / info.image.height);
      }));

      final aspectRatio = await completer.future;
      setState(() {
        _imageAspectRatio = aspectRatio;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width - 32.0;
    final containerHeight = _imageAspectRatio != null
        ? containerWidth / _imageAspectRatio!
        : containerWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '책 정보 수정',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상을 검정으로
          ),
        ),
        backgroundColor: Colors.white, // AppBar 배경색을 흰색으로
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상을 검정으로
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 썸네일 이미지 표시
              Container(
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: widget.thumbnailUrl != null
                      ? Image.network(
                          widget.thumbnailUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Center(
                          child:
                              Icon(Icons.image, size: 50.0, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 20.0),
              // 책 제목 입력
              _buildTextField('책 제목', _titleController),
              const SizedBox(height: 10.0),
              // 저자 입력
              _buildTextField('저자', _authorController),
              const SizedBox(height: 10.0),
              // 출판사 입력
              _buildTextField('출판사', _publisherController),
              const SizedBox(height: 10.0),
              // ISBN 입력
              _buildTextField('ISBN', _isbnController),
              const SizedBox(height: 10.0),
              // 책 소개 입력
              _buildMultiLineTextField('책 소개', _descriptionController),
              SizedBox(height: 30.0),
              // 저장 버튼
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF597E81),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    );
  }
}
