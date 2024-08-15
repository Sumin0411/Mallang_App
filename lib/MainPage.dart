import 'package:flutter/material.dart';
import 'package:mallang/Widget/Agebook.dart';
import 'main.dart';
import 'home.dart';
import 'package:mallang/Widget/Mypage.dart';
import 'package:mallang/Widget/library.dart';
import 'package:mallang/Widget/Alert.dart';
import 'package:mallang/Widget/BrandNew.dart';
import 'package:mallang/Widget/PopularBook.dart';
import 'package:mallang/pagetest.dart'; // 페이지 테스트 추가
import 'package:mallang/Widget/cartagory.dart';
import 'package:mallang/Widget/test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MainPage extends StatefulWidget {
  final String email;
  const MainPage(this.email);

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainPage> {
  int _selectedIndex = 1; // Track the selected index

  String? userName;

  // 사용자가 검색한 내용
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final response = await http.get(Uri.parse('http://20.249.17.142:8000/account/get/${widget.email}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        userName = data['name'];
      });
    } else {
      throw Exception('유저 정보를 가져올 수 없습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Color(0xffffe4e1),
        title: Text(
          "말랑",
          style: TextStyle(
            fontFamily: 'Moebius',
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            // 업데이트 사항, 신규 동화책 등록 등 알림 볼 수 있게 하기
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlertPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        //color: Color(0xffF4f1b1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              _searchBox(),
              SizedBox(height: 20,),
              _recommendBook(),
              SizedBox(height: 20,),
              _fourMenu(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 1) {
              // 홈 페이지로 이동
              // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
            } else if (_selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyLibrary()),
              );
            } else if (_selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage(widget.email)),
              );
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "내 서재",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "관리",
          ),
        ],
      ),
    );
  }

  Widget _searchBox(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          // 'value'는 사용자가 입력한 텍스트
          print('검색어: $value');
        },
        decoration: InputDecoration(
          filled: true, // 이 부분을 추가
          fillColor: Colors.white, // 배경색을 원하는 색상으로 설정
          hintText: '동화책을 검색해주세요',
          // labelStyle: TextStyle(fontFamily: 'Moebius'), // 라벨 폰트 변경
          hintStyle: TextStyle(fontFamily: 'Moebius'),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _searchController.clear(),
          ),
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색창 누르면 보일 화면
              print('검색어: ${_searchController.text}');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _recommendBook(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: EdgeInsets.only(left: 3, top: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40, // 텍스트 높이에 맞게 조절
                  decoration: BoxDecoration(
                    color: Color(0xfffaebd7), // 배경 색 및 투명도 조절
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$userName 님 취향저격 도서 \u{1F340}',
                    style: TextStyle(
                      fontSize: 21,
                      fontFamily: 'Moebius',
                      color: Color(0xff929292),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBook('assets/images/구름빵.png', '구름빵', width: 150, height: 200),
                  _buildBook('assets/images/토끼와거북이.png', '토끼와 거북이', width: 150, height: 200),
                  _buildBook('assets/images/흥부놀부.png', '흥부와 놀부', width: 150, height: 200),
                  _buildBook('assets/images/해님달님.png', '해님달님', width: 150, height: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBook(String imagePath, String title, {double width = 150, double height = 180}) {
    return GestureDetector(
      onTap: () {
        if (title == '토끼와 거북이') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Test(widget.email, title)),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: width,
              height: height,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontFamily: 'Moebius'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCard(String text, String imagePath, Color color) {
    Widget? targetScreen;

    switch (text) {
      case '신간도서':
        targetScreen = brandnewbook();
        break;
      case '인기도서':
        targetScreen = PopularBook();
        break;
      case '연령별 추천도서':
        targetScreen = agebook();
        break;
      case '카테고리':
        targetScreen = catagory();
        break;
      default:
        break;
    }

    return InkWell(
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen!),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 170,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0, // 모든 텍스트의 크기를 동일하게 설정합니다.
                  color: color, // 텍스트의 색깔을 설정합니다.
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _fourMenu(){
    return Column(
      children: [
        // SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCard('신간도서', 'assets/images/star.png', Color(0xffffa07a)),
            _buildCard('인기도서', 'assets/images/heart.png', Color(0xffADD797)),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCard('연령별 추천도서', 'assets/images/recommand.png', Color(0xffb0c4de)),
            _buildCard('카테고리', 'assets/images/category.png', Color(0xffffb6c1)),
          ],
        ),
      ],
    );
  }
}