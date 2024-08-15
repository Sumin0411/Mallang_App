import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '카테고리',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Moebius',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: <Widget>[
            InkWell(
              onTap: () {
                // 버튼 클릭 이벤트 처리 로직을 작성하세요.
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bee.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '명작동화',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Moebius',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      '유명한 이야기가 좋아요',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Moebius',
                        color: Color(0xffffa07a),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // 버튼 클릭 이벤트 처리 로직을 작성하세요.
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/giraffe.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '전래동화',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      '옛날 이야기가 좋아요',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 14,
                        color: Color(0xffADD797),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // 버튼 클릭 이벤트 처리 로직을 작성하세요.
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/lion.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '이솝우화',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      '동물 이야기가 좋아요',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 14,
                        color: Color(0xffb0c4de),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // 버튼 클릭 이벤트 처리 로직을 작성하세요.
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/rabbit.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '그림책',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      '그림 보는게 좋아요',
                      style: TextStyle(
                        fontFamily: 'Moebius',
                        fontSize: 14,
                        color: Color(0xffffb6c1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Image.asset('assets/images/chick.png',),
    );
  }
}