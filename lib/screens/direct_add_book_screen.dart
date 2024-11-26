import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker 패키지 추가

class DirectAddBookScreen extends StatefulWidget {
  final String? title;
  final String? author;
  final String? publisher;
  final String? isbn;
  final String? pages;
  final String? description;
  final String? thumbnailUrl;
  final bool isEditable; // 이미지 변경 가능 여부 추가

  const DirectAddBookScreen({
    Key? key,
    this.title,
    this.author,
    this.publisher,
    this.isbn,
    this.pages,
    this.description,
    this.thumbnailUrl,
    this.isEditable = true, // 기본값: 사용자가 변경 가능
  }) : super(key: key);

  @override
  State<DirectAddBookScreen> createState() => _DirectAddBookScreenState();
}

class _DirectAddBookScreenState extends State<DirectAddBookScreen> {
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _thumbnailUrl = widget.thumbnailUrl;
  }

  void _pickImage() async {
    if (!widget.isEditable) {
      return; // 이미지를 변경할 수 없는 경우 동작하지 않음
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _thumbnailUrl = image.path; // 선택한 이미지의 로컬 파일 경로 저장
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 선택이 취소되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 등록하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // 책 저장 로직 추가 (나중에 구현)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('책 정보가 저장되었습니다.')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 썸네일 이미지 표시
            GestureDetector(
              onTap: widget.isEditable ? _pickImage : null, // 변경 가능 여부에 따라 동작
              child: Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: _thumbnailUrl != null
                      ? (_thumbnailUrl!.startsWith('http') // URL인지 로컬 파일인지 확인
                          ? Image.network(
                              _thumbnailUrl!,
                              fit: BoxFit.contain,
                            )
                          : Image.file(
                              File(_thumbnailUrl!),
                              fit: BoxFit.contain,
                            ))
                      : const Center(
                          child:
                              Icon(Icons.image, size: 50.0, color: Colors.grey),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // 책 제목 입력
            _buildTextField('책 제목', widget.title),
            const SizedBox(height: 10.0),
            // 저자 입력
            _buildTextField('저자', widget.author),
            const SizedBox(height: 10.0),
            // 출판사 입력
            _buildTextField('출판사', widget.publisher),
            const SizedBox(height: 10.0),
            // ISBN 입력
            _buildTextField('ISBN', widget.isbn),
            const SizedBox(height: 10.0),
            // 페이지 수 입력
            _buildTextField('페이지 수', widget.pages),
            const SizedBox(height: 10.0),
            // 책 소개 입력 (텍스트 박스 높이 자동 조절)
            _buildMultiLineTextField('책 소개', widget.description),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? initialValue) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMultiLineTextField(String label, String? initialValue) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      maxLines: null, // 줄바꿈 자동 처리
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
