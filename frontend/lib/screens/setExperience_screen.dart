import 'package:flutter/material.dart';
import 'package:frontend/screens/experience_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetExperiencePage extends StatefulWidget {
  final bool? update;
  final String? name;
  const SetExperiencePage({this.update, this.name, super.key});

  @override
  State<SetExperiencePage> createState() => _SetExperiencePageState();
}

class _SetExperiencePageState extends State<SetExperiencePage> {
  bool writtenText = false;

  double percent = 0.75; // 프로그레스 바 진행률
  int formatLength = 1; // 작성 양식 개수(경험 추가하기 버튼 누르면 증가)

  List<TextEditingController> projectNameController = []; // 프로젝트명 입력 컨트롤러
  List<TextEditingController> projectExperienceController =
      []; // 프로젝트 경험 입력 컨트롤러
  List<TextEditingController> githubLinkController = []; // 깃허브 링크 입력 컨트롤러
  List<TextEditingController> partController = []; // 맡은 파트 입력 컨트롤러

  List<String?> selectedDuration = []; // 선택된 프로젝트 기간을 저장하는 함수
  List<String?> selectedRole = []; // 드롭다운에서 선택된 역할을 저장하는 변수
  List<String> customDurationValue = []; // 직접 입력된 프로젝트 기간을 저장하는 변수

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
    _addNewExperienceFields();
  }

  @override
  void dispose() {
    // 모든 컨트롤러 해제
    for (var controller in projectNameController) {
      controller.dispose();
    }
    for (var controller in projectExperienceController) {
      controller.dispose();
    }
    for (var controller in githubLinkController) {
      controller.dispose();
    }
    for (var controller in partController) {
      controller.dispose();
    }
    super.dispose();
  }

  // 경험 추가하기 버튼을 통해 새로운 컨트롤러 혹은 String 추가
  void _addNewExperienceFields() {
    setState(() {
      // 새로운 TextEditingController 추가
      projectNameController.add(TextEditingController());
      projectExperienceController.add(TextEditingController());
      githubLinkController.add(TextEditingController());
      partController.add(TextEditingController());
      selectedDuration.add(null);
      selectedRole.add(null);
      customDurationValue.add('');
    });
  }

  // 해당 인덱스의 컨트롤러 혹은 String 삭제
  void _removeExperienceFields(int index) {
    setState(() {
      projectNameController[index].dispose();
      projectExperienceController[index].dispose();
      githubLinkController[index].dispose();
      partController[index].dispose();

      projectNameController.removeAt(index);
      projectExperienceController.removeAt(index);
      githubLinkController.removeAt(index);
      partController.removeAt(index);
      selectedDuration.removeAt(index);
      selectedRole.removeAt(index);
      customDurationValue.removeAt(index);
    });
  }

  void _updateTextState() {
    setState(() {});
  }

  Future<void> _onTapHandler() async {
    // '없음' 버튼이 클릭된 경우 모든 입력을 빈 배열로 처리
    if (projectNameController[0].text.isEmpty &&
        projectExperienceController[0].text.isEmpty &&
        githubLinkController[0].text.isEmpty &&
        partController[0].text.isEmpty &&
        selectedRole[0] == null &&
        (selectedDuration[0] == null || customDurationValue[0].isEmpty)) {
      // 빈 배열로 설정
      ProjectExperience emptyExperience = ProjectExperience(
        experienceName: '[]', // 빈 배열 값
        experienceRole: 'NONE',
        experienceContent: '[]', // 빈 배열 값
        experienceGithub: '[]', // 빈 배열 값
        experienceJob: '[]', // 빈 배열 값
        experienceDate: '[]', // 빈 배열 값
      );

      // 빈 배열 값으로 처리
      final provider = context.read<ProjectExperienceProvider>();
      await provider.createProjectExperience(emptyExperience);

      if (context.mounted) {
        if (widget.update == true) {
          final projectExperienceProvider =
              Provider.of<ProjectExperienceProvider>(context, listen: false);

          // 프로젝트 경험 데이터를 가져옴
          await projectExperienceProvider.fetchExperiences();
          // 가져온 프로젝트 경험 데이터를 리스트로 저장
          List<ProjectExperience> experiences =
              projectExperienceProvider.projectExperiences;

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExperiencePage(
                  experiences: experiences,
                  name: widget.name!,
                ),
              ),
            );
          }
        } else {
          // 홈 페이지로 이동
          final prefs = await SharedPreferences.getInstance();
          final studentId = prefs.getString('studentId');
          final password = prefs.getString('password');
          final fcmToken = prefs.getString('fcmToken');

          if (context.mounted) {
            LoginAPI().handleLogin(context, studentId!, password!, fcmToken!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );

            // 학번, 비번, 토큰 제거
            prefs.remove('studentId');
            prefs.remove('password');
            prefs.remove('fcmToken');
          }
        }
      }
    } else {
      // 경험을 1개만 작성했을 경우
      if (projectNameController.length == 1) {
        final projectName = projectNameController[0].text;
        final projectExperience = projectExperienceController[0].text;
        final githubLink = 'https://github.com/${githubLinkController[0].text}';
        final roll = selectedRole[0];
        final part = partController[0].text;
        final duration = selectedDuration[0] ?? customDurationValue[0];

        ProjectExperience newExperience = ProjectExperience(
          experienceName: projectName,
          experienceRole: roll!,
          experienceContent: projectExperience,
          experienceGithub: githubLink,
          experienceJob: part,
          experienceDate: duration,
        );

        writtenText = true;
        percent = 1;

        final provider = context.read<ProjectExperienceProvider>();
        await provider.createProjectExperience(newExperience);
      }

      if (context.mounted) {
        if (widget.update == true) {
          // 경험 추가하기로 이동할 때 코드(경험 조회 화면으로 이동)
          final projectExperienceProvider =
              Provider.of<ProjectExperienceProvider>(context, listen: false);

          // 프로젝트 경험 데이터를 가져옴
          await projectExperienceProvider.fetchExperiences();
          // 가져온 프로젝트 경험 데이터를 리스트로 저장
          List<ProjectExperience> experiences =
              projectExperienceProvider.projectExperiences;

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExperiencePage(
                  experiences: experiences,
                  name: widget.name!,
                ),
              ),
            );
          }
        } else {
          // 홈 페이지로 이동
          // 아이디, 비밀번호, fcmToken 꺼내옴
          // 이유 : 로그인 api를 호출해 본인 프로필 정보가 뜰 수 있게 구현(로그인을 호출하지 않으면 전에 로그인한 회원의 정보가 뜸)
          final prefs = await SharedPreferences.getInstance();
          final studentId = prefs.getString('studentId');
          final password = prefs.getString('password');
          final fcmToken = prefs.getString('fcmToken');

          if (context.mounted) {
            LoginAPI().handleLogin(context, studentId!, password!, fcmToken!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }

          // 학번, 비번, 토큰 제거
          prefs.remove('studentId');
          prefs.remove('password');
          prefs.remove('fcmToken');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 25.0, top: 120.0, bottom: 50.0),
        child: SingleChildScrollView(
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      percent: percent,
                      lineHeight: 20,
                      backgroundColor: const Color(0xFFD9D9D9),
                      progressColor: const Color(0xFF2A72E7),
                      width: constraints.maxWidth,
                    );
                  },
                ),
              ),
              const SizedBox(height: 75),
              Image.asset(
                'assets/images/projectExperience.png',
                width: 200,
              ),
              const SizedBox(height: 10),

              // 경험 작성 양식
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 프로젝트명 입력 필드
                      TextFormField(
                        controller: projectNameController[index],
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

                      // 역할 선택 드롭다운
                      DropdownButtonFormField<String>(
                        value: selectedRole[index], // 초기 선택값, 필요 시 변수 초기화
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole[index] = newValue; // 선택된 값을 상태로 업데이트
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: '나의 역할(LEADER, MEMBER)을 선택해주세요',
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white, // 드롭다운 메뉴의 배경 색상
                        items: ['LEADER', 'MEMBER'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),
                      // 프로젝트 경험 입력 필드
                      TextFormField(
                        controller: projectExperienceController[index],
                        maxLines: 4,
                        keyboardType: TextInputType.multiline, // 줄바꿈 가능한 키보드
                        textInputAction:
                            TextInputAction.done, // 키보드에 '확인' 버튼을 추가
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
                        controller: githubLinkController[index],
                        decoration: const InputDecoration(
                          labelText: '깃허브 프로젝트 링크를 입력해주세요',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                          prefixText: 'https://github.com/',
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
                        controller: partController[index],
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
                        value: selectedDuration[index],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDuration[index] = newValue;
                            // 선택된 값이 "직접 입력"이 아닐 때, 직접 입력 값을 초기화
                            if (newValue != '직접 입력') {
                              customDurationValue[index] = '';
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
                        dropdownColor: Colors.white, // 드롭다운 메뉴의 배경 색상
                        items: projectDurationOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (selectedDuration[index] == '직접 입력' &&
                          customDurationValue[index].isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            onChanged: (value) {
                              customDurationValue[index] = value;
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
                      // if (customDurationValue
                      //     .isNotEmpty) // 직접 입력된 기간이 있을 때만 보여줌
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //     child: Text(
                      //       '직접 입력한 프로젝트 기간: $customDurationValue',
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //         color: Color(0xFF808080),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Column(
                  // Divider로 구분
                  children: [
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                  ],
                ),
                itemCount: formatLength,
              ),

              // 겸험 추가하기 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    formatLength++;
                  });
                  _addNewExperienceFields();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(
                    color: Colors.blueAccent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '경험 추가하기',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                    // 컨트롤러와 String의 첫부분이 작성되지 않으면 알리미 시작하기 버튼으로 표시
                    Text(
                      projectNameController[0].text.isNotEmpty &&
                              projectExperienceController[0].text.isNotEmpty &&
                              githubLinkController[0].text.isNotEmpty &&
                              partController[0].text.isNotEmpty &&
                              (selectedDuration[0] != null ||
                                  customDurationValue[0].isNotEmpty)
                          ? (widget.update == true)
                              ? '경험 추가하기'
                              : '알리미 시작하기'
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
    );
  }
}
