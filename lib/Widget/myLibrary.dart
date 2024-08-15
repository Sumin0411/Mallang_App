import 'package:flutter/material.dart';

void main() {
  runApp(MyLibrary());
}

class MyLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Library',
      home: MyLibraryPage(),
    );
  }
}

class MyLibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            '전체 도서',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1.0),
                  const BookItem(
                    imagePath: 'assets/images/토끼와거북이.png',
                    title: '토끼와 거북이',
                    progress: '73% 읽는 중',
                  ),
                  const BookItem(
                    imagePath: 'assets/images/호박목욕탕.png',
                    title: '호박 목욕탕',
                    progress: '68% 읽는 중',
                  ),
                  const BookItem(
                    imagePath: 'assets/images/인기도서1.png',
                    title: '내 사랑 티라노',
                    progress: '14% 읽는 중',
                  ),
                  const BookItem(
                    imagePath: 'assets/images/구름빵.png',
                    title: '구름빵',
                    progress: '59% 읽는 중',
                  ),
                  const BookItem(
                    imagePath: 'assets/images/여우와두루미.png',
                    title: '여우와 두루미',
                    progress: '23% 읽는 중',
                  ),
                  const BookItem(
                    imagePath: 'assets/images/인기도서3.png',
                    title: '미로야 놀자',
                    progress: '54% 읽는 중',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String progress;

  const BookItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 90,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 19,
                ),
              ),
              Text(progress),
            ],
          ),
        ],
      ),
    );
  }
}
