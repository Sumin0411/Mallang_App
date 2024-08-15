import 'package:flutter/material.dart';
import 'package:mallang/pagetest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:button_animations/button_animations.dart';

class Test extends StatefulWidget {
  final String email;
  final String title;
  const Test(this.email,this.title, {Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String info = '';
  String? parent;
  String? rabbit;
  String? turtle;

  @override
  void initState() {
    super.initState();
    bookCheck();
  }

  Future bookCheck() async {

    Map<String, String> data = {
      'email' : widget.email,
      'type' : 'json',
      'book' : widget.title,
      'file' : '',
    };

    final response = await http.post(
      Uri.parse('http://20.249.17.142:8000/data/get/file'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      String title = responseData['title'];
      String info = responseData['info'];
      List<String> character = List<String>.from(responseData['character']);

      print('Title: $title');
      print('Info: $info');
      print('Character: $character');

      setState(() {
        this.info = info;
        this.parent = "";
        this.rabbit = character[1];
        this.turtle = character[2];
      });

    } else {
      throw Exception('Failed to send data. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 200.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/토끼와거북이.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Text(
                '${widget.title}',
                style: const TextStyle(fontSize: 28, fontFamily: 'Pretendard'),
              ),
            ),
            const Center(
              child: Text(
                '김미견 그림/만화',
                style: TextStyle(fontSize: 15, fontFamily : 'Pretendard', color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(1, 3),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/거.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          child: Text('${turtle ?? "거북이"} 모드',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.black,
                            ),),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => test(widget.email, widget.title, turtle, false), // 'rabbit' 값을 전달
                              ),
                            );
                          },
                          height: 40,
                          width: 100,
                          type: null,
                          color: Colors.white70,
                          shadowColor: Colors.amber[300],
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/토.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          child: Text('${rabbit ?? "토끼"} 모드',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.black,
                            ),),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => test(widget.email, widget.title, rabbit, false), // 'rabbit' 값을 전달
                              ),
                            );
                          },
                          height: 40,
                          width: 100,
                          type: null,
                          color: Colors.white70,
                          shadowColor: Colors.amber[300],
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(1, 3),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/to.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          child: Text('감상 모드',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.black,
                            ),),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => test(widget.email, widget.title, parent, false), // 'rabbit' 값을 전달
                              ),
                            );
                          },
                          height: 40,
                          width: 100,
                          type: null,
                          color: Colors.white70,
                          shadowColor: Colors.amber[300],
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(1, 3),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/nightmode.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          child: Text('자장가 모드',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.black,
                            ),),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => test(widget.email, widget.title, parent, true), // 'rabbit' 값을 전달
                              ),
                            );
                          },
                          height: 40,
                          width: 100,
                          type: null,
                          color: Colors.white70,
                          shadowColor: Colors.amber[300],
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12,),
            Container(
              width: 380.0,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${info}',
                      style: const TextStyle(fontSize: 16, fontFamily: 'Pretendard', color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
