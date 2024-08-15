import 'package:flutter/material.dart';
import 'package:mallang/Widget/home.dart';
import 'package:mallang/Widget/myLibrary.dart';
import 'package:mallang/Widget/mypage.dart';
import 'package:mallang/Widget/notification.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainTabPage extends StatefulWidget {
  final String email;

  const MainTabPage(this.email, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainTabState();
  }
}

class _MainTabState extends State<MainTabPage> {
  int _selectedIndex = 0; // Track the selected index
  String userName = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final response = await http.get(
        Uri.parse('http://20.249.17.142:8000/account/get/${widget.email}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        userName = data['name'];
      });
    } else {
      throw Exception('유저 정보를 가져올 수 없습니다');
    }
  }

  List<Widget> tabItems() {
    return <Widget>[
      HomePage(email: widget.email, userName: userName),
      MyLibraryPage(),
      MyPage(widget.email),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // 제목을 가운데 정렬하지 않음
        automaticallyImplyLeading: false,
        // 뒤로가기 버튼 제거
        backgroundColor: const Color(0xffffd966),
        title: Row(
          children: [
            Image.asset(
              'assets/images/appbar.png', // 이미지 경로 지정
              width: 120, // 이미지 너비 조절
              height: 140, // 이미지 높이 조절
            ),
            const SizedBox(width: 10), // 이미지와 텍스트 사이의 간격 조절
          ],
        ),
        actions: [
          IconButton(
            // 업데이트 사항, 신규 동화책 등록 등 알림 볼 수 있게 하기
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xffffd966),
      body: SafeArea(
        child: tabItems().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "내 서재",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "관리",
          ),
        ],
      ),
    );
  }
}
