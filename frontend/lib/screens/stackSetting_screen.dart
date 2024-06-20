import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class StackSettingPage extends StatefulWidget {
  const StackSettingPage({super.key});

  @override
  State<StackSettingPage> createState() => _StackSettingPageState();
}

class _StackSettingPageState extends State<StackSettingPage> {
  List<Map<String, dynamic>> fieldList = [
    {
      'logoUrl': 'assets/skilImages/typescript.png',
      'title': 'TYPESCRIPT',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF037BCB),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/javascript.png',
      'title': 'JAVASCRIPT',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFFF5DF1D),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/tailwindcss.png',
      'title': 'TAILWINDCSS',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF3DB1AB),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/html.png',
      'title': 'HTML5',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFE35026),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/css.png',
      'title': 'CSS3',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF1472B6),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/react.png',
      'title': 'REACT',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFF61DAFB),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/npm.png',
      'title': 'NPM',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFCB3837),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/vscode.png',
      'title': 'VISUAL STUDIO CODE',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF0078D7),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/docker.png',
      'title': 'DOCKER',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF0BB7ED),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/yarn.png',
      'title': 'YARN',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF2C8EBB),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/prettier.png',
      'title': 'PRETTIER',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFFF8B83E),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/eslint.png',
      'title': 'ESLINT',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF4B3263),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/figma.png',
      'title': 'FIGMA',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFF24D1D),
      'isSelected': false,
    },
  ];

  List<Map<String, dynamic>> toolsList = [
    {
      'logoUrl': 'assets/skilImages/github.png',
      'title': 'GITHUB',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF111011),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/notion.png',
      'title': 'NOTION',
      'titleColor': Colors.white,
      'badgeColor': Colors.black,
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/slack.png',
      'title': 'SLACK',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF4A144C),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/zoom.png',
      'title': 'ZOOM',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF2D8CFF),
      'isSelected': false,
    },
    {
      'logoUrl': 'assets/skilImages/discord.png',
      'title': 'DISCORD',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF5765F2),
      'isSelected': false,
    }
  ];

  List<Map<String, dynamic>> selectedFields = []; // 선택된 Field 리스트
  List<Map<String, dynamic>> selectedTools = []; // 선택된 Tools 리스트

  bool completedField = false; // Field 선택 완료 불리안

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '기술 스택 지정하기',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),

                // 초기화 버튼
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      for (var stack in selectedFields) {
                        stack['isSelected'] = false;
                      }
                      for (var tool in selectedTools) {
                        tool['isSelected'] = false;
                      }
                      selectedFields.clear();
                      selectedTools.clear();

                      completedField = false;
                    });
                  },
                  icon: const Icon(
                    Icons.restart_alt_outlined,
                    color: Colors.black,
                  ),
                  label: const Text(
                    '초기화',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Field 선택 완료 시 DEVELOPMENT TOOLS 선택으로 넘어감
            completedField
                ? const Text(
                    '2. DEVELOPMENT TOOLS 선택',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    '1. DEVELOPMENT FIELD 선택',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 28),

            // 기술 스택 목록
            // Field 선택 완료 시 Tools 스택 표시
            completedField
                ? Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: toolsList.map((tools) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tools['isSelected'] = !tools['isSelected'];
                            if (tools['isSelected']) {
                              selectedTools.add(tools);
                            } else {
                              selectedTools.remove(tools);
                            }
                          });
                          print('${tools['title']} : ${tools['isSelected']}');
                        },
                        child: badge(
                          tools['logoUrl'],
                          tools['title'],
                          tools['titleColor'],
                          tools['badgeColor'],
                          tools['isSelected'],
                        ),
                      );
                    }).toList(),
                  )
                : Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: fieldList.map((field) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            field['isSelected'] = !field['isSelected'];
                            if (field['isSelected']) {
                              selectedFields.add(field);
                            } else {
                              selectedFields.remove(field);
                            }
                          });
                          print('${field['title']} : ${field['isSelected']}');
                        },
                        child: badge(
                          field['logoUrl'],
                          field['title'],
                          field['titleColor'],
                          field['badgeColor'],
                          field['isSelected'],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),

      // Visibility 위젯을 사용해 selectedStack가 하나라도 생기면 바텀 시트 생기게 구현
      bottomSheet: Visibility(
        // Field 선택 완료 시 visible이 selectedTools 리스트가 비어있는지 확인으로 바뀜
        visible: completedField
            ? selectedTools.isNotEmpty
            : selectedFields.isNotEmpty,
        child: BottomSheet(
          onClosing: () {},
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height / 3.6,
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          builder: (context) {
            // 바텀 시트 영역
            return Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: 400,
                    height: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F6F6),
                    ),

                    // Field 선택 완료 시 선택된 기술 스택 종류가 Tools로 바뀜
                    child: completedField
                        ? Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedTools.map((tools) {
                              return badge(
                                tools['logoUrl'],
                                tools['title'],
                                tools['titleColor'],
                                tools['badgeColor'],
                                tools['isSelected'],
                              );
                            }).toList(),
                          )
                        : Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedFields.map((stack) {
                              return badge(
                                stack['logoUrl'],
                                stack['title'],
                                stack['titleColor'],
                                stack['badgeColor'],
                                stack['isSelected'],
                              );
                            }).toList(),
                          ),
                  ),
                ),
                const SizedBox(height: 15),

                // 확인 버튼
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Field 선택 완료 시 Tools 선택 창으로 바뀜
                      completedField = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color(0xFF2A72E7),
                    minimumSize: const Size(319, 46),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 기술 스택 배지
  Widget badge(
    String logoUrl,
    String title,
    Color titleColor,
    Color badgeColor,
    bool isSelected,
  ) {
    return badges.Badge(
      badgeContent: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logoUrl,
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: badgeColor,
        shape: badges.BadgeShape.square,
        borderSide: isSelected
            ? const BorderSide(
                color: Color(0xFF2A72E7),
                width: 5.0,
              )
            : BorderSide.none,
      ),
    );
  }
}
