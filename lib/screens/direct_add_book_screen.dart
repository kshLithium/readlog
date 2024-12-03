import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker 패키지
import 'progress_check_screen.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class DirectAddBookScreen extends StatefulWidget {
  final String? title;
  final String? author;
  final String? publisher;
  final String? isbn;
  final String? description;
  //final String? pages;
  final String? thumbnailUrl;
  final bool isEditable; // 이미지 변경 가능 여부 추가

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
  double? _imageAspectRatio; // 이미지 비율을 저장할 변수 추가
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // 이미지 비율을 계산하는 함수
  Future<void> _calculateImageAspectRatio(String imagePath) async {
    if (imagePath.startsWith('http')) {
      // 네트워크 이미지인 경우
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
    } else {
      // 로컬 이미지인 경우
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      setState(() {
        _imageAspectRatio = image.width / image.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _authorController.text = widget.author ?? '';
    _publisherController.text = widget.publisher ?? '';
    _isbnController.text = widget.isbn ?? '';
    _descriptionController.text = widget.description ?? '';

    if (widget.thumbnailUrl != null) {
      _thumbnailUrl = widget.thumbnailUrl;
      _calculateImageAspectRatio(widget.thumbnailUrl!);
    }
  }

  void _pickImage() async {
    if (!widget.isEditable) {
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _thumbnailUrl = image.path;
      });
      await _calculateImageAspectRatio(image.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 선택이 취소되었습니다.')),
      );
    }
  }

  void _navigateToProgressCheck() {
    final bookData = {
      'title': _titleController.text,
      'author': _authorController.text,
      'publisher': _publisherController.text,
      'isbn': _isbnController.text,
      'description': _descriptionController.text,
      'thumbnailUrl': _thumbnailUrl,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgressCheckScreen(bookData: bookData),
      ),
    );
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
          '책 등록하기',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _navigateToProgressCheck,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 썸네일 이미지 표시
            GestureDetector(
              onTap: widget.isEditable ? _pickImage : null,
              child: Container(
                height: containerHeight, // 계산된 높이 사용
                width: containerWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: _thumbnailUrl != null
                      ? (_thumbnailUrl!.startsWith('http')
                          ? Image.network(
                              _thumbnailUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.file(
                              File(_thumbnailUrl!),
                              fit: BoxFit.cover,
                              width: double.infinity,
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
            // 페이지 수 입력
            // _buildTextField('페이지 수', widget.pages),
            // const SizedBox(height: 10.0),
            // 책 소개 입력 (텍스트 박스 높이 자동 조절)
            _buildMultiLineTextField('책 소개', _descriptionController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMultiLineTextField(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: null, // 줄바꿈 자동 처리
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
