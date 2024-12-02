import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택 패키지
import 'progress_check_screen.dart'; // 책 진도 체크 화면

class DirectAddBookScreen extends StatefulWidget {
  final String? title;
  final String? author;
  final String? publisher;
  final String? isbn;
  final String? description;
  final String? thumbnailUrl;
  final bool isEditable; // 이미지 변경 가능 여부

  const DirectAddBookScreen({
    Key? key,
    this.title,
    this.author,
    this.publisher,
    this.isbn,
    this.description,
    this.thumbnailUrl,
    this.isEditable = true, // 기본값: 사용자가 변경 가능
  }) : super(key: key);

  @override
  State<DirectAddBookScreen> createState() => _DirectAddBookScreenState();
}

class _DirectAddBookScreenState extends State<DirectAddBookScreen> {
  String? _thumbnailUrl;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _thumbnailUrl = widget.thumbnailUrl; // 기존 썸네일 URL
    _titleController.text = widget.title ?? '';
    _authorController.text = widget.author ?? '';
    _publisherController.text = widget.publisher ?? '';
    _isbnController.text = widget.isbn ?? '';
    _descriptionController.text = widget.description ?? '';
  }

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailUrl = pickedFile.path;
      });
    }
  }

  // 책 진도 체크 화면으로 이동
  void _navigateToProgressCheck() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgressCheckScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 등록하기'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _navigateToProgressCheck, // 책 진도 체크 화면으로 이동
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 책 썸네일 이미지 선택
            GestureDetector(
              onTap: widget.isEditable ? _pickImage : null, // 이미지 변경 가능 시만 선택 가능
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: _thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_thumbnailUrl!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(child: Icon(Icons.camera_alt, color: Colors.grey)),
              ),
            ),
            SizedBox(height: 20),

            // 책 제목 입력
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '책 제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // 저자 입력
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: '저자',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // 출판사 입력
            TextField(
              controller: _publisherController,
              decoration: InputDecoration(
                labelText: '출판사',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // ISBN 입력
            TextField(
              controller: _isbnController,
              decoration: InputDecoration(
                labelText: 'ISBN',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // 책 설명 입력
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '책 설명',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
