import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'direct_add_book_screen.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가
  List<dynamic> _books = [];
  bool _isLoading = false;
  bool _hasMore = true; // 더 많은 데이터가 있는지 여부
  String? _error;
  int _start = 1; // 네이버 API의 시작 위치
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // 스크롤 이벤트 리스너 추가
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 리소스 정리
    super.dispose();
  }

  // 스크롤 이벤트 처리
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMoreBooks();
    }
  }

  // 네이버 도서 검색 API 호출
  Future<void> _searchBooks(String query, {bool isLoadMore = false}) async {
    if (isLoadMore) {
      _start += 10; // 다음 페이지를 불러오기 위해 시작 위치 증가
    } else {
      setState(() {
        _start = 1;
        _books = [];
        _hasMore = true;
      });
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String clientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
    final String clientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';

    final String apiUrl =
        "https://openapi.naver.com/v1/search/book.json?query=${Uri.encodeQueryComponent(query)}&display=10&start=$_start&sort=sim";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "X-Naver-Client-Id": clientId,
          "X-Naver-Client-Secret": clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newBooks = data['items'] ?? [];

        setState(() {
          _books.addAll(newBooks);
          _hasMore = newBooks.length == 10; // 불러온 데이터가 10개면 더 있을 가능성 있음
        });
      } else {
        setState(() {
          _error = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to fetch books: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 초기 검색 또는 새 검색
  void _search(String query) {
    _query = query;
    _searchBooks(query);
  }

  // 추가 데이터 로드
  void _loadMoreBooks() {
    if (_query.isNotEmpty) {
      _searchBooks(_query, isLoadMore: true);
    }
  }

  // 선택한 책 정보 전달
  void _onBookSelected(dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DirectAddBookScreen(
          title: book['title'], // 책 제목
          author: book['author'], // 저자
          publisher: book['publisher'], // 출판사
          isbn: book['isbn'], // ISBN
          pages: book['price'], // 페이지수는 상세검색 API에서 제공하지 않음
          description: book['description'], // 책 설명
          thumbnailUrl: book['image'], // 썸네일 URL
          isEditable: false, // 이미지 변경 불가능
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '책을 찾아보세요!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '검색할 책을 입력해주세요.',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.menu_book, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      _search(query);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20.0),

            // 초기 상태, 로딩 상태, 또는 에러 상태를 처리
            if (_books.isEmpty && !_isLoading && _error == null)
              const Center(
                child: Text(
                  '검색을 시작해주세요!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            if (_isLoading && _books.isEmpty)
              const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // 검색 결과 리스트
            if (_books.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // 스크롤 컨트롤러 연결
                  itemCount:
                      _books.length + (_hasMore ? 1 : 0), // 로딩 표시를 위한 추가 항목
                  itemBuilder: (context, index) {
                    if (index == _books.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final book = _books[index];
                    return GestureDetector(
                      onTap: () => _onBookSelected(book),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: book['image'] != null
                                ? Image.network(
                                    book['image'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.book, size: 50),
                            title: Text(
                              book['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "저자: ${book['author']}\n출판사: ${book['publisher']}",
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
