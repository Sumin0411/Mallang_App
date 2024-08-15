import 'package:flutter/material.dart';
import 'package:mallang/CombinedPage.dart';
import '../main.dart';
import '../home.dart';
import 'package:mallang/pagetest.dart';

class brandnewbook extends StatelessWidget {
  const brandnewbook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('신간도서',
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
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBookImage('assets/images/끝말잇기.png'),
                  _buildBookImage('assets/images/나의 빛나는 친구.png'),
                  _buildBookImage('assets/images/너는 어떤 씨앗이니.png'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBookImage('assets/images/여기는 토끼아파트입니다.png'),
                  _buildBookImage('assets/images/친구의전설.png'),
                  _buildBookImage('assets/images/클림트의 정원으로.png'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBookImage('assets/images/도와줘,브루너.png'),
                  _buildBookImage('assets/images/봄날의즐거운모자대회.png'),
                  _buildBookImage('assets/images/변신요가.png'),
                ],
              ),
              SizedBox(height: 20), // 사진과 버튼 사이 간격 조정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBookImage('assets/images/티니핑.png'),
                  _buildBookImage('assets/images/호박목욕탕.png'),
                  _buildBookImage('assets/images/홀짝홀짝호로록.png'),
                ],
              ),
              SizedBox(height: 20), // 스크롤의 마지막 간격
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage(String imagePath) {
    return Container(
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
    );
  }
}
