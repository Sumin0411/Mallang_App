import 'package:flutter/material.dart';
import 'CombinedPage.dart';
import 'MainPage.dart';
import 'Splash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 정보 서버에 보내기
  Future _signInWithEmailAndPassword() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final String url = 'http://20.249.17.142:8000/account/login';
    // 이메일과 비밀번호를 json형식으로 인코딩
    final String body = json.encode({
      'email' : email,
      'password' : password,
    });

    // http.post 메서드를 사용하여 서버에 post요청
    final http.Response response = await http.post(
      Uri.parse(url),
      // 요청 본문의 형식이 JSON임을 알림
      headers: {'Content-Type': 'application/json'},
      // 여기서는 사용자가 입력한 이메일, 비밀번호를 json 형식으로 변환한 문자열 전달
      body: body,
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      // 응답 본문을 JSON으로 변환
      String jsonData = jsonDecode(responseBody);

      if (jsonData == 'success') {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage(email)),
        );
        _showLoginSuccessDialog();
      }
      else {
        _showLoginfailDialog();
      }
    }
  }

  void _navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsOfService()),
    );
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 성공',
            style: TextStyle(
              fontFamily: 'Moebius',
            ),),
          content: Text('로그인이 성공적으로 완료되었습니다.',
            style: TextStyle(
              fontFamily: 'Moebius',
            ),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인',
                style: TextStyle(
                  fontFamily: 'Moebius',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoginfailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 실패',
            style: TextStyle(
              fontFamily: 'Moebius',
            ),
          ),

          content: Text('로그인을 다시 해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                '간편하게 로그인하고\n다양한 서비스를 이용하세요',
                style: TextStyle(
                  fontFamily: 'Moebius',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: '이메일을 입력해주세요.',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Moebius'), // 라벨 폰트 변경
                      hintStyle: TextStyle(fontFamily: 'Moebius'), // 힌트 폰트 변경
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '비밀번호를 입력해주세요.',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Moebius'), // 라벨 폰트 변경
                      hintStyle: TextStyle(fontFamily: 'Moebius'),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add logic for 아이디 찾기 button
                        },
                        child: Text(
                          '아이디 찾기',
                          style: TextStyle(fontFamily: 'Moebius', color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add logic for 비밀번호 찾기 button
                        },
                        child: Text(
                          '비밀번호 찾기',
                          style: TextStyle(fontFamily: 'Moebius', color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: 100,  // 너비 조정
                    height: 50,  // 높이 조정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow[100],
                    ),
                    child: ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      child: Text(
                        '로그인',
                        style: TextStyle(fontFamily: 'Moebius', color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 100,  // 너비 조정
                    height: 50,  // 높이 조정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow[100],
                    ),
                    child: ElevatedButton(
                      onPressed: _navigateToSignUpPage,
                      child: Text(
                        '회원가입',
                        style: TextStyle(fontFamily: 'Moebius', color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}