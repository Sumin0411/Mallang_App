import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyPage extends StatelessWidget {
  final String email;
  const MyPage(this.email);

  Future<Map<String, dynamic>> getUserInfo() async {
    final response = await http.get(Uri.parse('http://20.249.17.142:8000/account/get/${email}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('유저 정보를 가져올 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage('assets/images/마이페이지토끼.png'),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.data!['name']} 님',
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$email',
                              style: const TextStyle(
                                fontFamily:  'Pretendard',
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 20.0),
                    const Text(
                      '내 데이터 관리',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.payment),
                      title: Text('녹음 기록',
                        style: TextStyle(
                            fontFamily: 'Pretendard'
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text('분석 내역',
                        style: TextStyle(
                            fontFamily: 'Pretendard'
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text('개인정보 수정',
                        style: TextStyle(
                            fontFamily: 'Pretendard'
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 20.0),
                    const Text(
                      '알림 설정',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('푸시 알림',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      value: true,
                      onChanged: (bool value) {},
                    ),
                    SwitchListTile(
                      title: const Text('이메일 알림',
                        style: TextStyle(
                            fontFamily: 'Pretendard'
                        ),
                      ),
                      value: false,
                      onChanged: (bool value) {},
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
