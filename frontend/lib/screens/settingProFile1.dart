import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SettingProfile1Page extends StatefulWidget {
  const SettingProfile1Page({super.key});

  @override
  State<SettingProfile1Page> createState() => _SettingProfile1PageState();
}

class _SettingProfile1PageState extends State<SettingProfile1Page> {
  double percent = 0; // 프로그레스 바 진행률
  TextEditingController linkController = TextEditingController(); // 깃허브 링크 입력
  bool writtenLink = false;

  @override
  void initState() {
    super.initState();
    linkController.addListener(_updateTextState);
  }

  @override
  void dispose() {
    linkController.removeListener(_updateTextState);
    linkController.dispose();
    super.dispose();
  }

  void _updateTextState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 120.0),
        child: Column(
          children: [
            Container(
              alignment: FractionalOffset(percent, 1 - percent),
              child: Image.asset(
                'assets/images/cyclingPerson.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                percent: percent,
                lineHeight: 20,
                backgroundColor: const Color(0xFFD9D9D9),
                progressColor: const Color(0xFF2A72E7),
                width: 370,
              ),
            ),
            const SizedBox(height: 75),
            Image.asset(
              'assets/images/githubLogo.png',
            ),
            const SizedBox(height: 59),

            // 깃허브 링크 필드
            TextFormField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: '깃허브 링크를 입력해주세요',
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                ),

                // github.com 고정
                prefixText: 'github.com/',
                prefixStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              ),
            ),
            const SizedBox(height: 136),

            // 다음으로 또는 없음 버튼
            GestureDetector(
              onTap: () {
                if (linkController.text.isNotEmpty) {
                  final githubUrl =
                      'github.com/${linkController.text}'; // 깃허브 링크 최종 주소
                  print('깃허브 링크 : $githubUrl');
                  // 이 자리에 api 작성
                } else {
                  print('깃허브 링크 없음');
                }
                writtenLink = true; // 깃허브 링크 작성 true로 설정
                percent = 0.25; // 25%로 진행률 증가
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    linkController.text.isNotEmpty ? '다음으로' : '없음',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF2A72E7),
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
