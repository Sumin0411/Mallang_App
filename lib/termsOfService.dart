import 'package:flutter/material.dart';
import 'signUp.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  bool allAgreed = false;
  bool serviceAgreed = false;
  bool privacyAgreed = false;
  bool dataCollectionAgreed = false;
  bool marketingAgreed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '약관 동의',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              children: [
                const Text(
                  '말랑에 오신 것을 환영합니다!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '말랑 서비스를 이용하기 전에',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    color: Colors.grey.withOpacity(0.9),
                  ),
                ),
                Text(
                  '먼저 이용약관에 동의해주세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    color: Colors.grey.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 30),
                _buildCheckboxWithContainer('전체 약관 동의', allAgreed, _handleAllAgreed),
                const SizedBox(height: 20,),
                _buildTermsCheckboxes(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: (allAgreed || (serviceAgreed && privacyAgreed))
                ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage()));
            }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              backgroundColor: (allAgreed || (serviceAgreed && privacyAgreed))
                  ? Colors.orange // 변경된 부분
                  : Colors.orange.withOpacity(0.5), // 변경된 부분
              surfaceTintColor: (allAgreed || (serviceAgreed && privacyAgreed))
                  ? Colors.orange // 변경된 부분
                  : Colors.orange.withOpacity(0.5), // 변경된 부분
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('다음', style: TextStyle(fontFamily: 'Pretendard', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxWithContainer(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.withOpacity(0.05),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.orangeAccent,
      ),
    );
  }

  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.orangeAccent,
    );
  }

  Widget _buildTermsCheckboxes() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          _buildCheckbox(
              '[필수] 서비스 이용약관 동의', serviceAgreed, _handleServiceAgreed),
          SizedBox(height: 20),
          _buildCheckbox(
              '[필수] 개인정보 수집 및 이용동의', privacyAgreed, _handlePrivacyAgreed),
          SizedBox(height: 20),
          _buildCheckbox(
              '[선택] 품질 향상을 위한 이용자 데이터 수집', dataCollectionAgreed,
              _handleDataCollectionAgreed),
          SizedBox(height: 20),
          _buildCheckbox(
              '[선택] 마케팅 정보 수신 동의', marketingAgreed, _handleMarketingAgreed),
        ],
      ),
    );
  }

  void _handleAllAgreed(bool? value) {
    setState(() {
      allAgreed = value!;
      serviceAgreed = value;
      privacyAgreed = value;
      dataCollectionAgreed = value;
      marketingAgreed = value;
    });
  }

  void _handleServiceAgreed(bool? value) {
    setState(() {
      serviceAgreed = value!;
    });
  }

  void _handlePrivacyAgreed(bool? value) {
    setState(() {
      privacyAgreed = value!;
    });
  }

  void _handleDataCollectionAgreed(bool? value) {
    setState(() {
      dataCollectionAgreed = value!;
    });
  }

  void _handleMarketingAgreed(bool? value) {
    setState(() {
      marketingAgreed = value!;
    });
  }
}
