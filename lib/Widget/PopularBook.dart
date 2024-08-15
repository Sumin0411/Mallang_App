import 'package:flutter/material.dart';

class PopularBook extends StatelessWidget {
  const PopularBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('인기도서',
          style: TextStyle(
            fontFamily: 'Moebius',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 30, // Container의 높이 설정
                color: Colors.yellow[100], // 배경색 설정
                child: Center(
                  child: Text(
                    '인기도서 베스트 12',
                    style: TextStyle(fontSize: 20,fontFamily: 'Moebius',
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildBookRow([
                BookInfo(imagePath: 'assets/images/토끼와거북이.png', text: '토끼와 거북이'),
                BookInfo(imagePath: 'assets/images/해님달님.png', text: '해님달님'),
                BookInfo(imagePath: 'assets/images/인기도서3.png', text: '미로야 놀자'),
              ]),
              SizedBox(height: 20),
              _buildBookRow([
                BookInfo(imagePath: 'assets/images/인기도서4.png', text: '주근깨가 어때서?'),
                BookInfo(imagePath: 'assets/images/인기도서5.png', text: '도도도 도착!'),
                BookInfo(imagePath: 'assets/images/인기도서6.png', text: '아빠랑 간질간질'),
              ]),
              SizedBox(height: 20),
              _buildBookRow([
                BookInfo(imagePath: 'assets/images/도와줘,브루너.png', text: '도와줘, 브루너'),
                BookInfo(imagePath: 'assets/images/봄날의즐거운모자대회.png', text: '봄날의 즐거운 모자 대회'),
                BookInfo(imagePath: 'assets/images/변신요가.png', text: '변신 요가'),
              ]),
              SizedBox(height: 20),
              _buildBookRow([
                BookInfo(imagePath: 'assets/images/인기도서1.png', text: '내 사랑 티라노'),
                BookInfo(imagePath: 'assets/images/인기도서2.png', text: '밥의 오싹오싹 맛집'),
                BookInfo(imagePath: 'assets/images/친구의전설.png', text: '친구의 전설'),
              ]),
              SizedBox(height: 20), // 스크롤의 마지막 간격
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookRow(List<BookInfo> books) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: books.map((book) {
        return _buildBookImage(book.imagePath, book.text);
      }).toList(),
    );
  }

  Widget _buildBookImage(String imagePath, String text) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        SizedBox(height: 5), // 텍스트와 이미지 사이의 간격 조절
        Text(
          text,
          style: TextStyle(fontSize: 12, fontFamily: 'Moebius'), // 텍스트의 크기 조절
        ),
      ],
    );
  }
}

class BookInfo {
  final String imagePath;
  final String text;

  BookInfo({required this.imagePath, required this.text});
}
