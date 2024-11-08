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
  double percent = 0.75; // 프로그레스 바 진행률
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
  String? selectedRole; // 드롭다운에서 선택된 역할을 저장하는 변수
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

  Future<void> _onTapHandler() async {
    // '없음' 버튼이 클릭된 경우 모든 입력을 빈 배열로 처리
    if (projectNameController.text.isEmpty &&
        projectExperienceController.text.isEmpty &&
        githubLinkController.text.isEmpty &&
        rollController.text.isEmpty &&
        partController.text.isEmpty &&
        (selectedDuration == null && customDurationValue.isEmpty)) {
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
      // 기존 입력 처리 로직 유지
      final projectName = projectNameController.text;
      final projectExperience = projectExperienceController.text;
      final githubLink = 'https://github.com/${githubLinkController.text}';
      final roll = rollController.text;
      final part = partController.text;
      final duration = selectedDuration ?? customDurationValue;

      writtenText = true;
      percent = 1;

      ProjectExperience newExperience = ProjectExperience(
        experienceName: projectName,
        experienceRole: roll,
        experienceContent: projectExperience,
        experienceGithub: githubLink,
        experienceJob: part,
        experienceDate: duration,
      );

      final provider = context.read<ProjectExperienceProvider>();
      await provider.createProjectExperience(newExperience);

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
              const SizedBox(height: 59),
              Column(
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 역할 선택 드롭다운
                  DropdownButtonFormField<String>(
                    value: selectedRole, // 초기 선택값, 필요 시 변수 초기화
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue; // 선택된 값을 상태로 업데이트
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                    controller: projectExperienceController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline, // 줄바꿈 가능한 키보드
                    textInputAction: TextInputAction.done, // 키보드에 '확인' 버튼을 추가
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                                  projectExperienceController.text.isNotEmpty &&
                                  githubLinkController.text.isNotEmpty &&
                                  rollController.text.isNotEmpty &&
                                  partController.text.isNotEmpty &&
                                  (selectedDuration != null ||
                                      customDurationValue.isNotEmpty)
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
            ],
          ),
        ),
      ),
    );
  }
}
