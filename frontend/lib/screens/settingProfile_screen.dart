import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/widgets/badge_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class SettingProfilePage extends StatefulWidget {
  final String githubLink;
  final String hopeJob;
  const SettingProfilePage(this.githubLink, this.hopeJob, {super.key});

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  String developmentField = '';
  String developmentTool = '';

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
    {
      'logoUrl': 'assets/skilImages/vscode.png',
      'title': 'VISUAL STUDIO CODE',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF0078D7),
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
  double percent = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 60),
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
            completedField
                ? Row(
                    children: [
                      const Text(
                        '2. DEVELOPMENT TOOLS 선택',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 선택한 Tool이 없으면 없음 버튼에서 프로필 생성 api 연동
                          developmentTool = '없음';

                          // body에 집어넣을 프로필 model
                          final profile = Profile(
                            hopeJob: widget.hopeJob,
                            githubLink: widget.githubLink,
                            developmentField: developmentField,
                            developmentTool: developmentTool,
                          );

                          try {
                            int profileId =
                                await ProfileProvider().createProfile(profile);

                            if (context.mounted) {
                              Provider.of<ProfileProvider>(context,
                                      listen: false)
                                  .memberId = profileId;
                            }

                            if (context.mounted) {
                              Navigator.pushNamed(
                                  context, '/member-experience');
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: const Text(
                          '없음',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Text(
                        '1. DEVELOPMENT FIELD 선택',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            developmentField = '없음';
                            completedField = true;
                          });
                        },
                        child: const Text(
                          '없음',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: const Offset(0, 0),
                    ),
                  ),
                  child: child,
                );
              },
              layoutBuilder:
                  (Widget? currentChild, List<Widget> previousChildren) {
                return Stack(
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: completedField
                  ? Wrap(
                      key: ValueKey<bool>(completedField),
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
                          child: DevelopmentBadge(
                            logoUrl: tools['logoUrl'],
                            title: tools['title'],
                            titleColor: tools['titleColor'],
                            badgeColor: tools['badgeColor'],
                            isSelected: tools['isSelected'],
                          ),
                        );
                      }).toList(),
                    )
                  : Wrap(
                      key: ValueKey<bool>(completedField),
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
                          child: DevelopmentBadge(
                            logoUrl: field['logoUrl'],
                            title: field['title'],
                            titleColor: field['titleColor'],
                            badgeColor: field['badgeColor'],
                            isSelected: field['isSelected'],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
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
            return Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: 400,
                    height: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F6F6),
                    ),
                    child: completedField
                        ? Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedTools.map((tools) {
                              return DevelopmentBadge(
                                logoUrl: tools['logoUrl'],
                                title: tools['title'],
                                titleColor: tools['titleColor'],
                                badgeColor: tools['badgeColor'],
                                isSelected: tools['isSelected'],
                              );
                            }).toList(),
                          )
                        : Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedFields.map((stack) {
                              return DevelopmentBadge(
                                logoUrl: stack['logoUrl'],
                                title: stack['title'],
                                titleColor: stack['titleColor'],
                                badgeColor: stack['badgeColor'],
                                isSelected: stack['isSelected'],
                              );
                            }).toList(),
                          ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (!completedField) {
                      setState(() {
                        completedField = true;

                        percent = 0.75;
                      });
                    } else {
                      setState(() {
                        // selectedFields에서 title들을 가져와 하나의 문자열로 생성
                        if (developmentField.isNotEmpty) {
                          developmentField = selectedFields
                              .map((f) => f['title'])
                              .toList()
                              .join(',');
                        }
                        developmentField = '없음';

                        // selectedTools에서 title들을 가져와 하나의 문자열로 생성
                        developmentTool = selectedTools
                            .map((t) => t['title'])
                            .toList()
                            .join(','); // 요소 사이에 콤마(,) 추가
                      });

                      // body에 집어넣을 프로필 model
                      final profile = Profile(
                        hopeJob: widget.hopeJob,
                        githubLink: widget.githubLink,
                        developmentField: developmentField,
                        developmentTool: developmentTool,
                      );

                      try {
                        // 처음에 프로필 생성할 때 바로 조회할려면 생성 api의 응답데이터를 가져와서 저장하도록 작성
                        int profileId =
                            await ProfileProvider().createProfile(profile);

                        Provider.of<ProfileProvider>(context, listen: false)
                            .memberId = profileId;
                        if (context.mounted) {
                          Navigator.pushNamed(context, '/member-experience');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    }
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
}
