import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SettingProfile2Page extends StatefulWidget {
  const SettingProfile2Page({super.key});

  @override
  State<SettingProfile2Page> createState() => _SettingProfile2PageState();
}

class _SettingProfile2PageState extends State<SettingProfile2Page> {
  double percent = 0; // 프로그레스 바 진행률
  TextEditingController projectNameController =
      TextEditingController(); // 프로젝트명 입력 컨트롤러
  TextEditingController projectExperienceController =
      TextEditingController(); // 프로젝트 경험 입력 컨트롤러
  bool writtenText = false;

  @override
  void initState() {
    super.initState();
    projectNameController.addListener(_updateTextState);
    projectExperienceController.addListener(_updateTextState);
  }

  @override
  void dispose() {
    projectNameController.removeListener(_updateTextState);
    projectExperienceController.removeListener(_updateTextState);
    projectNameController.dispose();
    projectExperienceController.dispose();
    super.dispose();
  }

  void _updateTextState() {
    setState(() {});
  }

  void _onTapHandler() {
    setState(() {
      final projectName = projectNameController.text;
      final projectExperience = projectExperienceController.text;
      if (projectName.isNotEmpty || projectExperience.isNotEmpty) {
        print('프로젝트 명 : $projectName');
        print('프로젝트 경험 : $projectExperience');
      } else {
        print('프로젝트 경험 없음');
      }
      writtenText = true; // 프로젝트 경험 작성 true로 설정
      percent = 1; // 100%로 진행률 증가
    });
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
              'assets/images/projectExperience.png',
              width: 200,
            ),
            const SizedBox(height: 59),
            // 프로젝트명 입력 필드
            TextFormField(
              controller: projectNameController,
              decoration: const InputDecoration(
                labelText: '프로젝트명을 입력해주세요',
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF808080),
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
            const SizedBox(height: 10),
            // 프로젝트 경험 입력 필드
            TextFormField(
              controller: projectExperienceController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '프로젝트 경험을 입력해주세요',
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF808080),
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
            const SizedBox(height: 100),

            // 알리미 시작하기 또는 없음 버튼
            GestureDetector(
              onTap: _onTapHandler,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    projectNameController.text.isNotEmpty &&
                            projectExperienceController.text.isNotEmpty
                        ? '알리미 시작하기'
                        : '없음',
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
