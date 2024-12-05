import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'library.dart';
import 'memory_screen.dart';
import 'review_screen.dart';
import 'mypage.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    MemoryScreen(),
    ReviewScreen(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 12, bottom: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_outlined, '홈'),
            _buildNavItem(1, Icons.library_books_outlined, '서재관리'),
            _buildNavItem(2, Icons.psychology_outlined, '기억하기'),
            _buildNavItem(3, Icons.rate_review_outlined, '리뷰'),
            _buildNavItem(4, Icons.person_outline, '마이페이지'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Color(0xFF597E81) : Colors.grey,
      ),
    );
  }
}
