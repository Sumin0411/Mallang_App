import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:mallang/Widget/test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';

// fast api 통신할 때 필요한 라이브러리
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:mallang/stt.dart';

class test extends StatefulWidget {
  final String email;
  final String title;
  final String? selectedcharacter;
  final bool sleepMode;

  const test(this.email, this.title, this.selectedcharacter, this.sleepMode, {Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}


class _testState extends State<test> {
  List<dynamic> scriptData = [];
  Image? image; // 배경화면
  Image? role; // 역할
  int currentIndex = 0; // 현재 스크립트의 인덱스
  int? currentAudio;
  bool getScript_done = false;

  final recorder = FlutterSoundRecorder();
  bool isRecordingDone = false;
  final audioPlayer = AudioPlayer();

  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted){
      throw '마이크 권한을 허용해주세요';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    isRecordingDone = false;
    await recorder.startRecorder(toFile: 'audio.aac', codec: Codec.aacADTS);
  }

  // 녹음을 멈추고 녹음된 파일의 경로를 반환
  Future<String> stopRecorder() async {
    isRecordingDone = true;
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('녹음 파일 경로: $filePath');
    voiceChange(filePath);


    return filePath;
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
    getScripts();
    getAudio();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    audioPlayer.stop();
    super.dispose();
  }

  Future getScripts() async {
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
      List<dynamic> script = responseData['script'];
      print(scriptData);

      setState(() {
        scriptData = script;
      });

      // 스크립트를 받아온 후 첫번째 스크립트의 배경을 설정
      getImage(currentIndex.toString(), 'background');
      getImage(scriptData[currentIndex]['role'], 'role');
      getAudio();
      getScript_done = true;
    } else {
      throw Exception('Failed to send data. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future getImage(String background, String flag) async {
    Map<String, String> data = {
      'email' : widget.email,
      'type' : 'image',
      'book' : widget.title,
      'file' : background,
    };

    final response = await http.post(
      Uri.parse('http://20.249.17.142:8000/data/get/file'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Uint8List imageData = response.bodyBytes;

      setState(() {
        if (flag == 'background') {
          this.image = Image.memory(imageData);
        }
        else {
          this.role = Image.memory(imageData);
        }
      });

    } else {
      throw Exception('Failed to send data. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<void> getAudio() async {
    audioPlayer.stop();
    if (widget.sleepMode) {
      Map<String, String> data = {
        'email': widget.email,
        'type': 'audio',
        'book': widget.title,
        'file': "${currentIndex.toString()}_slow",
      };

      final response = await http.post(
        Uri.parse('http://20.249.17.142:8000/data/get/file'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        var audioData = jsonResponse['data'];
        var bytes = base64Decode(audioData);
        await audioPlayer.play(BytesSource(bytes));
      } else {
        throw Exception('Failed to load audio data');
      }
    }
    else {
      if (scriptData[currentIndex]['role'] != widget.selectedcharacter) {
        Map<String, String> data = {
          'email': widget.email,
          'type': 'audio',
          'book': widget.title,
          'file': currentIndex.toString(),
        };

        final response = await http.post(
          Uri.parse('http://20.249.17.142:8000/data/get/file'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print(jsonResponse);
          var audioData = jsonResponse['data'];
          var bytes = base64Decode(audioData);
          await audioPlayer.play(BytesSource(bytes));
        } else {
          throw Exception('Failed to load audio data');
        }
      }
    }
  }
  void nextScript() {
    // 다음 스크립트
    if (currentIndex < scriptData.length - 1) {
      setState(() {
        currentIndex++;
      });
      getImage(currentIndex.toString() ,'background');
      getImage(scriptData[currentIndex]['role'], '');
      getAudio();
    }
    else{
      audioPlayer.stop();
      showPop();
    }
  }

  void prevScript() {
    // 이전 스크립트
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      getImage(currentIndex.toString(), 'background');
      getImage(scriptData[currentIndex]['role'], '');
      getAudio();
    }
  }

  void showPop() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Transform.rotate(
          angle: -pi / -2,  // 90도 회전
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 150.0, // 높이를 원하는 값으로 설정하세요
                  width: 150.0, // 너비를 원하는 값으로 설정하세요
                  child: Lottie.asset(
                    'assets/lottie/lottie1.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30,),
                Text(
                  '${widget.title}를 다 읽으셨네요 !',
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: const Text(
                    '꾹 눌러서 나가기❤️',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    audioPlayer.stop();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Test(widget.email, widget.title),
                      ),
                    );
                  },
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (scriptData.length-1) > 0 ? currentIndex / (scriptData.length-1) : 0;
    Map<String, dynamic> currentScript = scriptData.isNotEmpty ? scriptData[currentIndex] : {};


    return RotatedBox(
      quarterTurns: 1,
      child: Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            buildPrevButton(),
            buildNextButton(),
            buildMicrophoneButton(),
            buildsttButton(),
            buildScriptText(currentScript),
          ],
        ),
        bottomNavigationBar: buildProgressBar(progress),
      ),
    );
  }

  // 배경
  Widget buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: this.image?.image ?? const AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // 이전 버튼을 그리는 위젯
  Widget buildPrevButton() {
    return Positioned(
      left: 30.0,
      bottom: 20.0,
      child: InkWell(
        onTap: () {
          prevScript();
          //getAudio();
        },
        child: Image.asset(
          'assets/images/prev.png',
          width: 60.0,
          height: 100.0,
        ),
      ),
    );
  }

  Widget buildsttButton() {
    return Positioned(
      left: 20.0,
      bottom: 80.0,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              audioPlayer.stop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SttPage(widget.email)
                ),
              );
            },
            child: Image.asset(
              'assets/images/stt.png',
              width: 45.0,
              height: 100.0,
            ),
          ),
        ],
      ),
    );
  }


// 다음 버튼을 그리는 위젯
  Widget buildNextButton() {
    return Positioned(
      right: 20.0,
      bottom: 17.0,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              nextScript();
              //getAudio();
            },
            child: Image.asset(
              'assets/images/next.png',
              width: 58.0,
              height: 100.0,
            ),
          ),
        ],
      ),
    );
  }

  // 마이크 버튼
  Widget buildMicrophoneButton() {
    bool isRecording = false;

    if (getScript_done) {
      if (scriptData[currentIndex]['role'] == widget.selectedcharacter) {
        return Stack(
          children: [
            Positioned(
              left: (MediaQuery.of(context).size.width - 50),
              bottom: 100.0,
              child: InkWell(
                onTap: () async {
                  if (recorder.isRecording) {
                    await stopRecorder();
                  } else {
                    await startRecord();
                  }
                  setState(() {});
                },
                child: (!recorder.isRecording)
                    ? Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    '눌러서 따라 읽어볼까요? \u{1F3A4}',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width),
              bottom: 20.0,
              child: InkWell(
                onTap: () async {
                  if (recorder.isRecording) {
                    await stopRecorder();
                  } else {
                    await startRecord();
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Image.asset(
                    recorder.isRecording ? 'assets/images/pause.png' : 'assets/images/mic.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Positioned(
          top: 0.0,
          right: 0.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(8.0),
              ),
            ),
          ),
        );
      }
    } else {
      return Positioned(
        top: 0.0,
        right: 0.0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ),
        ),
      );
    }
  }

  // 텍스트
  Widget buildScriptText(Map<String, dynamic> currentScript) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 50),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80, // 이미지의 너비를 설정합니다.
            height: 80, // 이미지의 높이를 설정합니다.
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: this.role?.image ?? AssetImage('assets/images/불꽃길.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TyperAnimatedTextKit(
                key: UniqueKey(),
                text: [currentScript['text'] ?? ''],
                textStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Pretendard',
                ),
                speed: Duration(milliseconds: 150),
                repeatForever: false,
                totalRepeatCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 하단 진행 바
  Widget buildProgressBar(double progress) {
    return SizedBox(
      height: 20.0,
      child: LinearProgressIndicator(
        value: progress,
        valueColor: AlwaysStoppedAnimation(Color(0xffa5ea89)),
      ),
    );
  }

  Future<void> voiceChange(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://20.249.17.142:8000/api/rvc/${widget.email}/${widget.title}/${scriptData[currentIndex]['role']}'));  // 서버의 URL
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('audio', 'aac'), //
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      var audioData = jsonResponse['data'];
      var bytes = base64Decode(audioData);
      await audioPlayer.play(BytesSource(bytes));
    } else {
      throw Exception('Failed to load audio data');
    }
  }
}