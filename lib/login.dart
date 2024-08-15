import 'package:flutter/material.dart';
import 'package:mallang/Style/buttonStyle.dart';
import 'termsOfService.dart';
import 'mainTab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final String title;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToSignUpPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TermsOfServicePage()),
      );
    }

    _navigateToMainPage(String email) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainTabPage(email)),
      );
    }

    _showLoginSuccessDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // 로그인 성공 시 키보드 숨기기
          FocusScope.of(context).unfocus();

          return AlertDialog(
            title: const Text(
              '로그인 성공',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
              ),
            ),
            content: const Text(
              '로그인이 성공적으로 완료되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
              ),
            ),
            actions: [
              Center( // 여기 추가
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    _showLoginFailDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그인 실패',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
              ),
            ),
            content: const Text('로그인을 다시 해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
              ),),
            actions: [
              Center( // 여기 추가
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // 로그인 정보 서버에 보내기
    _signInWithEmailAndPassword() async {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      const String url = 'http://20.249.17.142:8000/account/login';
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

        if(!context.mounted) return;

        if (jsonData == 'success') {
          _navigateToMainPage(email);
          _showLoginSuccessDialog();
        }
        else {
          _showLoginFailDialog();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
             const Text(
                '아이가 즐거워지는\n동화 낭독 시간',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // 이미지와 텍스트 사이 여백 조정
              Image.asset('assets/images/토낑.png'), // 이미지 추가, 이미지는 assets 폴더에 넣어야 합니다.
            ],
          ),
        ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: '이메일을 입력해주세요.',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Pretendard'), // 라벨 폰트 변경
                      hintStyle: TextStyle(fontFamily: 'Pretendard'), // 힌트 폰트 변경
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: '비밀번호를 입력해주세요.',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Pretendard'),
                      hintStyle: TextStyle(fontFamily: 'Pretendard'),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 테두리 둥글기 설정
                      color: Colors.orange,
                    ),
                    child:
                    ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      style: MallangButtonStyle.noSplash,
                      child: const Text(
                        '로그인 하기',
                        style: TextStyle(fontFamily: 'Pretendard', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add logic for 아이디 찾기 button
                        },
                        child: const Text(
                          '아이디 찾기',
                          style: TextStyle(fontFamily: 'Pretendard', color: Colors.black, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add logic for 비밀번호 찾기 button
                        },
                        child: const Text(
                          '비밀번호 찾기',
                          style: TextStyle(fontFamily: 'Pretendard', color: Colors.black, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToSignUpPage,
                        child: const Text(
                          '회원가입',
                          style: TextStyle(fontFamily: 'Pretendard', color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}