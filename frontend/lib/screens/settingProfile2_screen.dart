import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SettingProfile2Page extends StatefulWidget {
  const SettingProfile2Page({Key? key}) : super(key: key);

  @override
  State<SettingProfile2Page> createState() => _SettingProfile2PageState();
}

class _SettingProfile2PageState extends State<SettingProfile2Page> {
  double percent = 0; // 프로그레스 바 진행률
  TextEditingController projectNameController =
      TextEditingController(); // 프로젝트명 입력 컨트롤러
  TextEditingController projectExperienceController =
      TextEditingController(); // 프로젝트 경험 입력 컨트롤러
  TextEditingController githubLinkController =
      TextEditingController(); // 깃허브 링크 입력 컨트롤러
  TextEditingController rollController = TextEditingController(); // 역할 입력 컨트롤러
  TextEditingController partController =
      TextEditingController(); // 맡은 파트 입력 컨트롤러
  String? selectedDuration; // 선택된 프로젝트 기간을 저장하는 함수
  bool writtenText = false;
  String customDurationValue = ''; // 직접 입력된 프로젝트 기간을 저장하는 변수

  List<String> projectDurationOptions = [
    '1개월',
    '3개월',
    '6개월',
    '1년',
    '1년 이상',
    '직접 입력',
  ]; // 프로젝트 기간 옵션 리스트

  @override
  void initState() {
    super.initState();
    projectNameController.addListener(_updateTextState);
    projectExperienceController.addListener(_updateTextState);
    githubLinkController.addListener(_updateTextState);
    rollController.addListener(_updateTextState);
    partController.addListener(_updateTextState);
  }

  @override
  void dispose() {
    projectNameController.dispose();
    projectExperienceController.dispose();
    githubLinkController.dispose();
    rollController.dispose();
    partController.dispose();
    super.dispose();
  }

  void _updateTextState() {
    setState(() {});
  }

  void _onTapHandler() {
    setState(() {
      final projectName = projectNameController.text;
      final projectExperience = projectExperienceController.text;
      final githubLink = githubLinkController.text;
      final roll = rollController.text;
      final part = partController.text;

      if (projectName.isNotEmpty &&
          projectExperience.isNotEmpty &&
          githubLink.isNotEmpty &&
          roll.isNotEmpty &&
          part.isNotEmpty &&
          (selectedDuration != null || customDurationValue.isNotEmpty)) {
        // 입력 사항이 모두 채워져 있을 때 처리할 로직
        print('프로젝트 명 : $projectName');
        print('프로젝트 경험 : $projectExperience');
        print('깃허브 링크 : $githubLink');
        print('역할 : $roll');
        print('맡은 파트 : $part');
        if (selectedDuration == '직접 입력') {
          print('직접 입력한 프로젝트 기간 : $customDurationValue');
        } else {
          print('프로젝트 기간 : $selectedDuration');
          customDurationValue = ''; // 선택된 값 초기화
        }
        writtenText = true; // 입력 완료 상태로 변경
        percent = 1; // 100%로 진행률 증가
      } else {
        print('입력 사항을 모두 작성해주세요.');
      }
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 역할 입력 필드
                    TextFormField(
                      controller: rollController,
                      decoration: const InputDecoration(
                        labelText: '나의 역할(팀장, 팀원)을 입력해주세요',
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 깃허브 링크 입력 필드
                    TextFormField(
                      controller: githubLinkController,
                      decoration: const InputDecoration(
                        labelText: '깃허브 프로젝트 링크를 입력해주세요',
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF808080),
                        ),
                        prefixText: 'github.com/',
                        prefixStyle: TextStyle(
                          fontSize: 12,
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 맡은 파트 입력 필드
                    TextFormField(
                      controller: partController,
                      decoration: const InputDecoration(
                        labelText: '맡은 파트를 입력해주세요',
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 프로젝트 기간 드롭다운
                    DropdownButtonFormField<String>(
                      value: selectedDuration,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDuration = newValue;
                          // 선택된 값이 "직접 입력"이 아닐 때, 직접 입력 값을 초기화
                          if (newValue != '직접 입력') {
                            customDurationValue = '';
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '프로젝트 기간을 선택해주세요',
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF808080),
                      ),
                      items: projectDurationOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    if (selectedDuration == '직접 입력' &&
                        customDurationValue.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            customDurationValue = value;
                          },
                          decoration: const InputDecoration(
                            labelText: '프로젝트 기간을 직접 입력해주세요',
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (customDurationValue.isNotEmpty) // 직접 입력된 기간이 있을 때만 보여줌
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '직접 입력한 프로젝트 기간: $customDurationValue',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    // 알리미 시작하기 또는 없음 버튼
                    GestureDetector(
                      onTap: _onTapHandler,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            projectNameController.text.isNotEmpty &&
                                    projectExperienceController
                                        .text.isNotEmpty &&
                                    githubLinkController.text.isNotEmpty &&
                                    rollController.text.isNotEmpty &&
                                    partController.text.isNotEmpty &&
                                    (selectedDuration != null ||
                                        customDurationValue.isNotEmpty)
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
            ),
          ],
        ),
      ),
    );
  }
}
