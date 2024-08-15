import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

Future<String> getResponse(String question) async {
  var jsonBody = jsonEncode({
    'model': 'gpt-3.5-turbo',
    'messages': [
      {'role': 'system', 'content': '너는 아이들에게 친절하고 간략하게 대답하는 AI이다. 너는 아이들에게 긍정적이고, 친절하고, 간결한 내용을 말한다. 명심해. 당신은 본론만 말한다.'},
      {'role': 'user', 'content' : '토끼는 왜 거북이보다 빨라?'},
      {'role': 'assistant', 'content' : '토끼가 거북이보다 빠른 이유는 토끼가 다리가 너무 빨라서야! 다리가 길고 빨라서 거북이보다 빨리 움직이거든. 그래서 토끼가 뛰면 거북이보다 더 빨리 도착해!'},
      {'role' : 'user', 'content' : '토끼는 왜 낮잠을 잤어?'},
      {'role' : 'assistant', 'content' : '토끼는 자신이 빠르다고 생각해 잠시 쉬었지만, 그 동안 거북이는 천천히 가다가 결승점에 먼저 도착했어! 이 이야기는 자만하지 말고 꾸준히 노력해야 한다는 교훈을 담고 있어!'},
      {'role' : 'user', 'content' : question}
    ],
    'temperature': 0,
    'max_tokens': 1000,
  });
  //print(jsonBody);
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Authorization':
      'Bearer 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',
      'Content-Type': 'application/json',
    },
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseBody.containsKey('choices') &&
        responseBody['choices'].isNotEmpty &&
        responseBody['choices'][0].containsKey('message')) {
      return responseBody['choices'][0]['message']['content'];
    } else {
      return '잘못된 포맷';
    }
  } else {
    print('Failed to get response: ${response.body}');
    return '응답 오류';
  }
}

class SttPage extends StatefulWidget {
  final String email;

  const SttPage(this.email, {Key? key}) : super(key: key);

  @override
  _SttPageState createState() => _SttPageState();
}

class _SttPageState extends State<SttPage> {
  final audioPlayer = AudioPlayer();
  final SpeechToText _speech = stt.SpeechToText();
  String _text = "어떤 것에 대해 궁금한 거야? 무엇이든 물어봐도 돼! \u{1F64C}"; // 안내 문구
  String userQuestion = ""; // 사용자 질문을 저장할 변수 추가
  String gptResponse = "";
  bool isUserQuestionAsked = false; // 사용자 질문이 있는지 여부를 나타내는 변수 추가

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }
  @override
  void dispose(){
    audioPlayer.stop();
    // _speech.cancel();
  }

  Future<void> getTTS(String text) async {
    var jsonBody = jsonEncode({
      'email': widget.email,
      'text': text,
      'book': "토끼와 거북이",
      'role': "나레이션",
    });

    final response = await http.post(
      Uri.parse('http://20.249.17.142:8000/api/tts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      var audioData = jsonResponse['data'];
      var bytes = base64Decode(audioData);
      await audioPlayer.play(BytesSource(bytes));
    } else {
      print('Failed to send TTS request: ${response.body}');
    }
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
        onStatus: (status) => print('Speech recognition status: $status'),
        onError: (errorNotification) {
          print('Speech recognition error: $errorNotification');
          _stopListening();
        });

    if (available) {
      print('Speech recognition initialized');
    } else {
      print('Speech recognition not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Scaffold(
        backgroundColor: const Color(0xfffff2cc),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '무엇이든지 물어봐! \u{1f60e}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color(0xfffff2cc),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffffb13d),
          onPressed: _speech.isNotListening ? _startListening : _stopListening,
          shape: const CircleBorder(
            side: BorderSide(
              color: Color(0xffffb467),
              width: 4.0,
            ),
          ),
          child: Icon(
            _speech.isNotListening ? Icons.mic : Icons.stop,
            size: 40,
            color: Colors.white, // 마이크 아이콘 크기 조정
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Column(
              children: <Widget>[
                if (!isUserQuestionAsked) // 사용자 질문이 없는 경우에만 _text 표시
                  Container(
                    alignment: Alignment.center, // 수평 및 수직 정렬을 위해 사용
                    child: Text(
                      '$_text', // 처음에는 _text 표시
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                    ),
                  ),
                if (isUserQuestionAsked) // 사용자 질문이 있으면 user와 gpt 표시
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1.3, // 화면 너비의 80%만큼 제한
                            ),
                            child: IntrinsicHeight(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    '$userQuestion', // 사용자 질문 표시
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1.3, // 화면 너비의 80%만큼 제한
                            ),
                            child: IntrinsicHeight(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xffffb467),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    '$gptResponse',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void _startListening() async {
    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      localeId: 'ko-KR',
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        onDevice: false,
        listenMode: ListenMode.confirmation,
      ),
    );
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      userQuestion = result.recognizedWords; // 사용자 질문 저장
      gptResponse = await getResponse(userQuestion);
      print('gpt답변: $gptResponse');
      await getTTS(gptResponse); // tts로 읽기
      setState(() {
        _text = '$_text\n User: $userQuestion\nGPT-3: $gptResponse';
        isUserQuestionAsked = true; // 사용자 질문이 있음을 표시
      });
    }
  }
}