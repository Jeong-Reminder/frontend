import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/screens/settingProfile_screen.dart';
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
  String githubUrl = '';

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

  List<Map<String, dynamic>> positionList = [
    {
      'title': '프론트엔드',
      'isSelected': false,
    },
    {
      'title': '백엔드',
      'isSelected': false,
    },
    {
      'title': '클라우드',
      'isSelected': false,
    },
    {
      'title': '데이터 엔지니어',
      'isSelected': false,
    },
    {
      'title': 'DevOps',
      'isSelected': false,
    },
    {
      'title': '없음',
      'isSelected': false,
    },
  ];

  List<Map<String, dynamic>> chosenpositionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 120.0),
        // SingleChildScrollView를 사용하여 콘텐츠를 스크롤할 수 있게 하였고
        // 키보드가 올라올 때 발생하는 레이아웃 오버플로우 문제를 해결
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
                      width: constraints.maxWidth, // 화면 너비를 constraints에서 가져오기
                    );
                  },
                ),
              ),
              const SizedBox(height: 75),

              // 링크 작성 부분을 지나면(true) 보직 선택으로 이동
              if (writtenLink)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 보직 선택 제목
                    Row(
                      children: [
                        const Text(
                          '2. 보직 선택',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // 선택된 보직 배지
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children: chosenpositionList.map((position) {
                            return badge(
                              position['title'],
                              position['isSelected'],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 선택할 보직 배지 목록
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: positionList.map((position) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // 선택 시 isSelected를 true로 변환
                              position['isSelected'] = !position['isSelected'];
                              // true일 경우 chosenpositionList에 추가
                              if (position['isSelected'] == true) {
                                chosenpositionList.add(position);
                              } else {
                                chosenpositionList.remove(position);
                              }
                            });
                          },
                          child: badge(
                            position['title'],
                            position['isSelected'],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              else
                // 깃허브 링크 필드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. 깃허브 링크',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 깃허브 로고
                    Center(
                      child: Image.asset('assets/images/githubLogo.png'),
                    ),
                    const SizedBox(height: 59),

                    // 링크 입력 필드
                    TextFormField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        labelText: '깃허브 링크를 입력해주세요',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),

                        // github.com 고정
                        prefixText: 'https://github.com/',
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 136),

              // 다음으로 또는 없음 버튼
              GestureDetector(
                onTap: () {
                  // writtenLink이 false일 때 깃허브 링크 화면에서 진행
                  if (!writtenLink) {
                    if (linkController.text.isNotEmpty) {
                      setState(() {
                        githubUrl =
                            'https://github.com/${linkController.text}'; // 깃허브 링크 최종 주소
                      });
                    } else {
                      githubUrl = '깃허브 링크 없음';
                      print(githubUrl);
                    }
                    setState(() {
                      writtenLink = true; // 깃허브 링크 작성 true로 설정
                      percent = 0.25; // 25%로 진행률 증가
                    });
                  }
                  // writtenLink이 true가 된 후에 보직화면으로 이동하기 때문에
                  // 그 화면에서 버튼을 누르게 되면 기술 스택 화면으로 이동
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingProfilePage(
                          githubUrl,
                          chosenpositionList[0]['title'],
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      // 깃허브 링크를 적거나 보직을 선택할 때 다음으로 버튼 보이게 구현
                      writtenLink
                          ? '다음으로'
                          : (linkController.text.isNotEmpty ? '다음으로' : '없음'),
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

  // 보직 배지
  Widget badge(
    String title,
    bool isSelected,
  ) {
    return badges.Badge(
      badgeContent: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: const Color(0xFFDBE7FB),
        shape: badges.BadgeShape.square,

        // isSelected가 true일 경우 테두리 적용
        borderSide: isSelected
            ? const BorderSide(
                color: Color(0xFF2A72E7),
                width: 2.0,
              )
            : BorderSide.none,
      ),
    );
  }
}
